import 'dart:convert';

import 'package:flutter/services.dart';

class Character {
  final int id;
  final String name;
  final String gender;
  final List<String> species;
  final String debutGame;
  final String? weapon;
  final bool? norted;
  final String origin;
  final String imageUrl;

  Character({
    required this.id,
    required this.name,
    required this.gender,
    required this.species,
    required this.debutGame,
    this.weapon,
    this.norted,
    required this.origin,
    required this.imageUrl,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    final String nameForImage = (json['name'] as String)
        .replaceAll(RegExp(r"[',./]"), "")
        .replaceAll(' ', '_');

    return Character(
      id: json['id'] as int,
      name: json['name'] as String,
      gender: json['gender'] as String,
      species: (json['species'] as List<dynamic>)
          .map((w) => w as String)
          .toList(),
      debutGame: json['debutGame'] as String,
      weapon: json['weapon'] as String? ?? 'n/a',
      norted: json['norted'] as bool? ?? false,
      origin: json['origin'] as String,
      imageUrl: 'assets/images/characters/$nameForImage.png',
    );
  }

  Map<String, dynamic> toMap() => {
    'image': imageUrl,
    'name': name,
    'gender': gender,
    'species': species,
    'debutGame': debutGame,
    'weapon': weapon,
    'norted': norted,
    'origin': origin,
  };
}

final Set<Character> allCharacters = {};

Future<void> loadCharacters() async {
  final String response = await rootBundle.loadString(
    'assets/json/characters.json',
  );
  final Map<String, dynamic> data =
      json.decode(response) as Map<String, dynamic>;
  final List<dynamic> characters = data['characters'] as List<dynamic>;

  allCharacters.addAll(
    characters.map((item) => Character.fromJson(item as Map<String, dynamic>)),
  );
}
