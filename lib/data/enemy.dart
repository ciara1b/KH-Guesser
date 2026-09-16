import 'dart:convert';
import 'package:flutter/services.dart';

class Enemy {
  Enemy({
    required this.id,
    required this.name,
    required this.species,
    required this.debutGame,
    required this.appearances,
    this.isBoss = false,
    required this.worlds,
  });

  final int id;
  final String name;
  final String species;
  final String debutGame;
  final int appearances;
  final bool? isBoss;
  final List<String> worlds;

  factory Enemy.fromJson(Map<String, dynamic> json) {
    return Enemy(
      id: json['id'] as int,
      name: json['name'] as String,
      species: json['species'] as String,
      debutGame: json['debutGame'] as String,
      appearances: json['appearances'] as int,
      isBoss: json['isBoss'] as bool,
      worlds: (json['worlds'] as List<dynamic>).map((w) => w as String).toList(),
    );
  }
}

final Set<Enemy> allEnemies = {};

Future<void> loadEnemies() async {
  final String response = await rootBundle.loadString('assets/enemies.json');
  final Map<String, dynamic> data = json.decode(response) as Map<String, dynamic>;
  final List<dynamic> enemies = data['enemies'] as List<dynamic>;

  allEnemies.addAll(
    enemies.map((item) => Enemy.fromJson(item as Map<String, dynamic>)),
  );
}