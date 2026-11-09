library;
import 'dart:convert';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:khdle/models/category_info.dart';
import '../models/character.dart';
import '../models/keyblade.dart';

class Guess {
  Guess(this.categoryResults);

  factory Guess.empty(List<String> categories) => Guess([
    for (final c in categories) (category: c, value: null, type: HitType.none, clue: null),
  ]);

  factory Guess.fromMap(Map<String, dynamic> map) => Guess([
    for (final e in map.entries) (category: e.key, value: e.value, type: HitType.none, clue: null),
  ]);

  final List<CategoryResult> categoryResults;

  bool get isEmpty => categoryResults.every((c) => c.type == HitType.none);

  bool get isCorrect => categoryResults.every((c) => c.type == HitType.hit);

  Guess evaluate(Map<String, dynamic> hidden) {
    final result = <CategoryResult>[];

    for (final r in categoryResults) {
      final currentValue = hidden[r.category];
      HitType type;
      dynamic clue;

      if (currentValue == r.value ||
          currentValue is List && DeepCollectionEquality.unordered().equals(currentValue, r.value)) {
        type = HitType.hit;
      } else if ((r.value is List && currentValue.toSet().intersection(r.value.toSet()).isNotEmpty) ||
          (r.value is int && (currentValue - r.value).abs() <= 2)) {
        type = HitType.partial;
      } else {
        type = HitType.miss;
      }

      if (r.value is int) {
        clue = r.value < currentValue;
      }

      result.add((category: r.category, value: r.value, type: type, clue: clue));
    }

    return Guess(result);
  }
}

class GuessGame<T> {
  static const int defaultMaxGuesses = 8;

  GuessGame({
    required List<T> items,
    required String Function(T) nameOf,
    required Map<String, dynamic> Function(T) toMap,
    required List<String> categories,
    required this.gameType,
    this.maxGuesses = defaultMaxGuesses,
    this.seed,
  }) : _items = items,
       _nameOf = nameOf,
       _toMap = toMap,
       _categories = categories,
       _hidden = _pickInitial(items, seed),
       _guesses = List<Guess>.filled(maxGuesses, Guess.empty(categories)),
       _remaining = items.map(nameOf).toList();

  final int maxGuesses;
  final int? seed;
  final String gameType;

  final List<T> _items;
  final String Function(T) _nameOf;
  final Map<String, dynamic> Function(T) _toMap;
  final List<String> _categories;

  T _hidden;
  List<Guess> _guesses;
  List<String> _remaining;

  List<String> get _guessedNames => [
    for (final g in _guesses)
      if (!g.isEmpty)
        g.categoryResults.firstWhere((c) => c.category == 'name').value as String,
  ];

  List<String> get possibleNames => _items.map(_nameOf).toList();

  UnmodifiableListView<String> get remainingSolutions => UnmodifiableListView(_remaining);

  T get hidden => _hidden;

  UnmodifiableListView<Guess> get guesses => UnmodifiableListView(_guesses);

  Guess get previousGuess {
    final index = _guesses.lastIndexWhere((c) => !c.isEmpty);
    return index == -1 ? Guess.empty(_categories) : _guesses[index];
  }

  int get activeIndex => _guesses.indexWhere((c) => c.isEmpty);

  int get guessesRemaining {
    if (activeIndex == -1) return 0;
    return maxGuesses - activeIndex;
  }

  bool get didWin {
    if (_guesses.first.isEmpty) return false;
    return previousGuess.isCorrect;
  }

  bool get didLose => guessesRemaining == 0 && !didWin;

  void resetGame() {
    _hidden = _pickInitial(_items, seed);
    _guesses = List<Guess>.filled(maxGuesses, Guess.empty(_categories));
    _remaining = _items.map(_nameOf).toList();
    GameStorage.clear(gameType);
  }

  Map<String, dynamic> toJson() => {
    'hidden': _nameOf(_hidden),
    'guessed': List<String>.from(_guessedNames),
    'seed': seed,
  };

  bool restore(Map<String, dynamic> json) {
    if (json['seed'] != seed) return false;

    final match = _items.where((i) => _nameOf(i) == json['hidden']);
    if (match.isEmpty) return false;

    _hidden = match.first;
    _guesses = List<Guess>.filled(maxGuesses, Guess.empty(_categories));
    _remaining = _items.map(_nameOf).toList();

    for (final name in (json['guessed'] as List).cast<String>()) {
      if (activeIndex == -1) break;
      guess(name);
    }
    return true;
  }

  Future<void> save() => GameStorage.save(this);

  String? _canonicalName(String guess) {
    final g = guess.trim().toLowerCase();
    return _remaining.firstWhereOrNull((n) => n.toLowerCase() == g);
  }

  Guess? guess(String guess) {
    final name = _canonicalName(guess);
    if (name == null) return null;

    final result = matchGuessOnly(name);
    addGuessToList(result);
    _remaining.remove(name);
    return result;
  }

  bool isLegalGuess(String guess) => _canonicalName(guess) != null;

  Guess matchGuessOnly(String name) => guessFromName(name).evaluate(_toMap(_hidden));

  void addGuessToList(Guess guess) {
    final guessIndex = activeIndex;
    if (guessIndex == -1) {
      throw StateError('No guesses remaining.');
    }
    _guesses[guessIndex] = guess;
  }

  Guess guessFromName(String name) => Guess.fromMap(_toMap(_items.firstWhere((i) => _nameOf(i) == name)));

  Guess randomGuess() {
    final names = possibleNames;
    return guessFromName(names[Random().nextInt(names.length)]);
  }

  Guess guessFromSeed(int seed) {
    final names = possibleNames;
    return guessFromName(names[seed % names.length]);
  }

  static T _pickInitial<T>(List<T> items, int? seed) {
    if (seed != null) return items.elementAt(_scramble(seed) % items.length);
    return items.elementAt(Random().nextInt(items.length));
  }

  static int _scramble(int seed) {
    const mod32 = 0x100000000;
    int mul(int a, int b) => (((a & 0xFFFF) * b) + ((((a >>> 16) * b) & 0xFFFF) << 16)) % mod32;

    int h = (seed % mod32) ^ mul((seed ~/ mod32) + 1, 0x9E3779B1);
    h ^= h >>> 16;
    h = mul(h, 0x85EBCA6B);
    h ^= h >>> 13;
    h = mul(h, 0xC2B2AE35);
    h ^= h >>> 16;
    return h;
  }
}

List<String> get possibleCharacters => allCharacters.map((c) => c.name).toList();

List<String> get possibleKeyblades => allKeyblades.map((k) => k.name).toList();

class CharacterGame extends GuessGame<Character> {
  CharacterGame({super.maxGuesses, super.seed})
    : super(
        items: allCharacters.toList(),
        nameOf: (c) => c.name,
        toMap: (c) => c.toMap(),
        gameType: 'character',
        categories: const [
          'image',
          'name',
          'gender',
          'species',
          'debutGame',
          'appearances',
          'weapon',
          'norted',
          'origin',
        ],
      );

  Character get hiddenCharacter => hidden;
}

class KeybladeGame extends GuessGame<Keyblade> {
  KeybladeGame({super.maxGuesses, super.seed})
    : super(
        items: allKeyblades.toList(),
        nameOf: (k) => k.name,
        toMap: (k) => k.toMap(),
        gameType: 'keyblade',
        categories: const [
          'image',
          'name',
          'debutGame',
          'strength',
          'magic',
          'wielders',
          'appearances',
        ],
      );

  Keyblade get hiddenKeyblade => hidden;
}

class GameStorage {
  static String _key(String gameType) => 'saved_game_$gameType';

  static Future<void> save(GuessGame game) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(game.gameType), jsonEncode(game.toJson()));
  }

  static Future<void> load(GuessGame game) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key(game.gameType));
    if (raw == null) return;
    try {
      final ok = game.restore(jsonDecode(raw) as Map<String, dynamic>);
      if (!ok) await clear(game.gameType);
    } catch (_) {
      game.resetGame();
    }
  }

  static Future<void> clear(String gameType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key(gameType));
  }
}

class GameRepository {
  static final Map<String, GuessGame> _cache = {};

  static Future<GuessGame> get(String gameType, {int? seed}) async {
    final cached = _cache[gameType];
    if (cached != null && cached.seed == seed) return cached;

    final GuessGame game = gameType == 'character'
        ? CharacterGame(seed: seed)
        : KeybladeGame(seed: seed);
    await GameStorage.load(game);
    return _cache[gameType] = game;
  }
}