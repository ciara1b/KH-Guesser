library;

import 'package:collection/collection.dart';
import 'package:khdle/data/category_info.dart';
import 'dart:math';
import '../data/keyblade.dart';

List<String> get possibleKeyblades => allKeyblades.map((c) => c.name).toList();

const List<CategoryInfo> categories = [
  (
    category: 'Name',
    value: null,
  ),
  (
    category: 'Debut Game',
    value: 'The game in which they first appeared.',
  ),
  (
    category: 'Strength',
    value: 'The base strength stat/boost the keyblade provides in the first game it can be used. Yellow indicates you are within 2 of the correct number.',
  ),
  (
    category: 'Magic',
    value: 'The base magic stat/boost the keyblade provides in the first game it can be used. Yellow indicates you are within 2 of the correct number.',
  ),
  (
    category: 'Wielders',
    value: 'Characters you can play as whilst wielding the keyblade.',
  ),
  (
    category: 'Appearances',
    value: 'The number of games the keyblade is equippable in throughout the franchise. Yellow indicates you are within 2 of the correct number.',
  )
];

class Game {
  static const int defaultMaxGuesses = 8;

  Game({this.maxGuesses = defaultMaxGuesses, this.seed}) : _keybladeToGuess = _generateInitialKeyblade(seed), _guesses = List<KeybladeGuess>.filled(maxGuesses, KeybladeGuess.empty());

  final int maxGuesses;
  final int? seed;

  Keyblade _keybladeToGuess;

  List<KeybladeGuess> _guesses;

  Keyblade get hiddenKeyblade => _keybladeToGuess;

  UnmodifiableListView<KeybladeGuess> get guesses => UnmodifiableListView(_guesses);

  KeybladeGuess get previousGuess {
    final index = _guesses.lastIndexWhere((c) => !c.isEmpty);
    return index == -1 ? KeybladeGuess.empty() : _guesses[index];
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
    _keybladeToGuess = _generateInitialKeyblade(seed);
    _guesses = List<KeybladeGuess>.filled(maxGuesses, KeybladeGuess.empty());
  }

  KeybladeGuess? guess(String guess) {
    if (isLegalGuess(guess)) {
      final result = matchGuessOnly(guess);
      addGuessToList(result);
      return result;
    }

    return null;
  }

  bool isLegalGuess(String guess) => possibleKeyblades.contains(guess);

  KeybladeGuess matchGuessOnly(String guess) => KeybladeGuess.fromString(guess).evaluateGuess(_keybladeToGuess);

  void addGuessToList(KeybladeGuess guess) {
    final guessIndex = activeIndex;
    if (guessIndex == -1) {
      throw StateError('No guesses remaining.');
    }

    _guesses[guessIndex] = guess;
  }

  static Keyblade _generateInitialKeyblade(int? seed) {
    if (seed != null) {
      return allKeyblades.elementAt(seed % allKeyblades.length);
    }
    final random = Random();
    return allKeyblades.elementAt(random.nextInt(allKeyblades.length));
  }
}

class KeybladeGuess {
  KeybladeGuess(this.categoryResults);

  factory KeybladeGuess.empty() => KeybladeGuess(
    <CategoryResult>[
      (category: "name", value: null, type: HitType.none, clue: null),
      (category: "gender", value: null, type: HitType.none, clue: null),
      (category: "species", value: null, type: HitType.none, clue: null),
      (category: "debutGame", value: null, type: HitType.none, clue: null),
      (category: "appearances", value: null, type: HitType.none, clue: null),
      (category: "weapon", value: null, type: HitType.none, clue: null),
      (category: "norted", value: null, type: HitType.none, clue: null),
      (category: "origin", value: null, type: HitType.none, clue: null),
    ]
  );

  factory KeybladeGuess.fromString(String guess) {
    final guessedKeyblade = allKeyblades.firstWhere((c) => c.name == guess);
    final categoryResults = guessedKeyblade.toMap().entries.map((entry) => (category: entry.key, value: entry.value, type: HitType.none, clue: null)).toList();
    return KeybladeGuess(categoryResults);
  }

  factory KeybladeGuess.random() {
    final random = Random();
    final nextKeyblade = possibleKeyblades[random.nextInt(possibleKeyblades.length)];
    return KeybladeGuess.fromString(nextKeyblade);
  }

  factory KeybladeGuess.fromSeed(int seed) => KeybladeGuess.fromString(possibleKeyblades[seed % possibleKeyblades.length]);

  final List<CategoryResult> categoryResults;

  bool get isEmpty => categoryResults.every((c) => c.type == HitType.none);

  bool get isCorrect => categoryResults.every((c) => c.type == HitType.hit);
}

extension KeybladeGuessUtils on KeybladeGuess {
  KeybladeGuess evaluateGuess(Keyblade hiddenKeyblade) {
    final hiddenKeybladeMap = hiddenKeyblade.toMap();
    var result = <CategoryResult>[];

    for (var r in categoryResults) {
      final currentValue = hiddenKeybladeMap[r.category];
      HitType type;
      dynamic clue;

      if (currentValue == r.value || currentValue is List && DeepCollectionEquality.unordered().equals(currentValue, r.value)) {
        type = HitType.hit;
      } else if ((r.value is List && currentValue.toSet().intersection(r.value.toSet()).isNotEmpty) || (r.value is int && (currentValue - r.value).abs() <= 2)) {
        type = HitType.partial;
      } else {
        type = HitType.miss;
      }

      if (r.value is int) {
        clue = r.value < currentValue;
      }

      result.add((category: r.category, value: r.value, type: type, clue: clue));
    }

    return KeybladeGuess(result);
  }
}