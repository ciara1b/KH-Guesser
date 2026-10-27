import 'dart:convert';
import 'package:flutter/services.dart';

class Enemy {
  Enemy({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  final int id;
  final String name;
  final String imageUrl;

  factory Enemy.fromJson(Map<String, dynamic> json) {
    final String nameForImage = (json['name'] as String).toLowerCase().replaceAll(' ', '-');

    return Enemy(
      id: json['id'] as int,
      name: json['name'] as String,
      imageUrl: 'assets/images/$nameForImage',
    );
  }
}

final Set<Enemy> allEnemies = {};

Future<void> loadEnemies() async {
  final String response = await rootBundle.loadString('assets/json/enemies.json');
  final Map<String, dynamic> data = json.decode(response) as Map<String, dynamic>;
  final List<dynamic> enemies = data['enemies'] as List<dynamic>;

  allEnemies.addAll(
    enemies.map((item) => Enemy.fromJson(item as Map<String, dynamic>)),
  );
}