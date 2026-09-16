import 'dart:convert';
import 'package:flutter/services.dart';

class Character {
  Character({
    required this.id,
    required this.name,
    required this.gender,
    required this.species,
    required this.debutGame,
    required this.appearances,
    required this.weapon,
    this.norted = false,
    required this.origin,
  });

  final int id;
  final String name;
  final String gender;
  final String species;
  final String debutGame;
  final int appearances;
  final String weapon;
  final bool? norted;
  final String origin;

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] as int,
      name: json['name'] as String,
      gender: json['gender'] as String,
      species: json['species'] as String,
      debutGame: json['debutGame'] as String,
      appearances: json['appearances'] as int,
      weapon: json['weapon'] as String,
      norted: json['norted'] as bool,
      origin: json['origin'] as String,
    );
  }
}

final Set<Character> allCharacters = {};

Future<void> loadCharacters() async {
  final String response = await rootBundle.loadString('assets/characters.json');
  final Map<String, dynamic> data = json.decode(response) as Map<String, dynamic>;
  final List<dynamic> characters = data['characters'] as List<dynamic>;

  allCharacters.addAll(
    characters.map((item) => Character.fromJson(item as Map<String, dynamic>)),
  );
}