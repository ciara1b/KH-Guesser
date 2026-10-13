library;

import 'dart:collection';
import 'dart:math';
import 'data/character.dart';

enum HitType {
  none,
  hit,
  partial,
  miss,
}

typedef CategoryResult = ({String category, dynamic value, HitType type});

List<String> get possibleCharacters => allCharacters.map((c) => c.name).toList();

final List<Object> categories = [
  {
    "type": 'Name',
    "info": '',
  },
  {
    "type": 'Gender',
    "info": '',
  },
  {
    "type": 'Species',
    "info": '',
  },
  {
    "type": 'Debut Game',
    "info": '',
  },
  {
    "type": 'Apperances',
    "info": '',
  },
  {
    "type": 'Weapon',
    "info": '',
  },
  {
    "type": 'Norted',
    "info": '',
  },
  {
    "type": 'Origin',
    "info": '',
  }
];

class Game {
  static const int defaultMaxGuesses = 5;

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
      (category: "name", value: null, type: HitType.none),
      (category: "gender", value: null, type: HitType.none),
      (category: "species", value: null, type: HitType.none),
      (category: "debutGame", value: null, type: HitType.none),
      (category: "appearances", value: null, type: HitType.none),
      (category: "weapon", value: null, type: HitType.none),
      (category: "norted", value: null, type: HitType.none),
      (category: "origin", value: null, type: HitType.none),
    ]
  );

  factory CharacterGuess.fromString(String guess) {
    final guessedCharacter = allCharacters.firstWhere((c) => c.name == guess);
    final categoryResults = guessedCharacter.toMap().entries.map((entry) => (category: entry.key, value: entry.value, type: HitType.none)).toList();
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

      if (currentValue == r.value) {
        type = HitType.hit;
      } else if ((r.category == "species" && currentValue.toSet().intersection(r.value.toSet()).isNotEmpty) || (r.category == "appearances" && (r.value - 2 <= currentValue && currentValue <= r.value + 2))) {
        type = HitType.partial;
      } else {
        type = HitType.miss;
      }

      result.add((category: r.category, value: r.value, type: type));
    }

    return CharacterGuess(result);
  }
}