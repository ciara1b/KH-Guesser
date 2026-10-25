library;

import 'package:collection/collection.dart';
import 'dart:math';
import '../data/character.dart';

enum HitType {
  none,
  hit,
  partial,
  miss,
}

typedef CategoryResult = ({String category, dynamic value, HitType type, dynamic clue});
typedef CategoryInfo = ({String category, String? value});

List<String> get possibleCharacters => allCharacters.map((c) => c.name).toList();

const String gamesIncluded = '\n\nGames included:\n • Kingdom Hearts\n • Kingdom Hearts Final Mix\n • Kingdom Hearts: Chain of Memories\n • Kingdom Hearts II\n • Kingdom Hearts II Final Mix\n • Kingdom Hearts 358/2 Days\n • Kingdom Hearts Birth By Sleep\n • Kingdom Hearts Birth By Sleep Final Mix\n • Kingdom Hearts Re:Coded\n • Kingdom Hearts 3D: Dream Drop Distance\n • Kingdom Hearts χ[chi]\n • Kingdom Hearts Union χ[Cross]\n • Kingdom Hearts Dark Road\n • Kingdom Hearts III + Re Mind';
const List<CategoryInfo> categories = [
  (
    category: 'Name',
    value: null,
  ),
  (
    category: 'Gender',
    value: null,
  ),
  (
    category: 'Species',
    value: null,
  ),
  (
    category: 'Debut Game',
    value: 'The game in which they first appeared. $gamesIncluded',
  ),
  (
    category: 'Appearances',
    value: 'The number of games the character has appeared in throughout the franchise, including canon and non-canon secret endings. $gamesIncluded',
  ),
  (
    category: 'Weapon',
    value: null,
  ),
  (
    category: 'Norted',
    value: 'Whether or not they have been part Xehanort at any point throughout the series.',
  ),
  (
    category: 'Franchise',
    value: 'The franchise they originate from, e.g. Kingdom Hearts, Toy Story, Final Fantasy, etc.',
  )
];

class Game {
  static const int defaultMaxGuesses = 8;

  Game({this.maxGuesses = defaultMaxGuesses, this.seed}) : _characterToGuess = _generateInitialCharacter(seed), _guesses = List<CharacterGuess>.filled(maxGuesses, CharacterGuess.empty());

  final int maxGuesses;
  final int? seed;

  Character _characterToGuess;

  List<CharacterGuess> _guesses;

  Character get hiddenCharacter => _characterToGuess;

  UnmodifiableListView<CharacterGuess> get guesses => UnmodifiableListView(_guesses);

  CharacterGuess get previousGuess {
    final index = _guesses.lastIndexWhere((c) => !c.isEmpty);
    return index == -1 ? CharacterGuess.empty() : _guesses[index];
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
    _characterToGuess = _generateInitialCharacter(seed);
    _guesses = List<CharacterGuess>.filled(maxGuesses, CharacterGuess.empty());
  }

  CharacterGuess? guess(String guess) {
    if (isLegalGuess(guess)) {
      final result = matchGuessOnly(guess);
      addGuessToList(result);
      return result;
    }

    return null;
  }

  bool isLegalGuess(String guess) => possibleCharacters.contains(guess);

  CharacterGuess matchGuessOnly(String guess) => CharacterGuess.fromString(guess).evaluateGuess(_characterToGuess);

  void addGuessToList(CharacterGuess guess) {
    final guessIndex = activeIndex;
    if (guessIndex == -1) {
      throw StateError('No guesses remaining.');
    }

    _guesses[guessIndex] = guess;
  }

  static Character _generateInitialCharacter(int? seed) {
    if (seed != null) {
      return allCharacters.elementAt(seed % allCharacters.length);
    }
    final random = Random();
    return allCharacters.elementAt(random.nextInt(allCharacters.length));
  }
}

class CharacterGuess {
  CharacterGuess(this.categoryResults);

  factory CharacterGuess.empty() => CharacterGuess(
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

  factory CharacterGuess.fromString(String guess) {
    final guessedCharacter = allCharacters.firstWhere((c) => c.name == guess);
    final categoryResults = guessedCharacter.toMap().entries.map((entry) => (category: entry.key, value: entry.value, type: HitType.none, clue: null)).toList();
    return CharacterGuess(categoryResults);
  }

  factory CharacterGuess.random() {
    final random = Random();
    final nextCharacter = possibleCharacters[random.nextInt(possibleCharacters.length)];
    return CharacterGuess.fromString(nextCharacter);
  }

  factory CharacterGuess.fromSeed(int seed) => CharacterGuess.fromString(possibleCharacters[seed % possibleCharacters.length]);

  final List<CategoryResult> categoryResults;

  bool get isEmpty => categoryResults.every((c) => c.type == HitType.none);

  bool get isCorrect => categoryResults.every((c) => c.type == HitType.hit);
}

extension CharacterGuessUtils on CharacterGuess {
  CharacterGuess evaluateGuess(Character hiddenCharacter) {
    final hiddenCharacterMap = hiddenCharacter.toMap();
    var result = <CategoryResult>[];

    for (var r in categoryResults) {
      final currentValue = hiddenCharacterMap[r.category];
      HitType type;
      dynamic clue;

      if (currentValue == r.value || currentValue is List && DeepCollectionEquality.unordered().equals(currentValue, r.value)) {
        type = HitType.hit;
      } else if ((r.category == "species" && currentValue.toSet().intersection(r.value.toSet()).isNotEmpty)) {
        type = HitType.partial;
      } else {
        type = HitType.miss;
      }

      if (r.category == "appearances") {
        clue = r.value < currentValue;
      }

      result.add((category: r.category, value: r.value, type: type, clue: clue));
    }

    return CharacterGuess(result);
  }
}