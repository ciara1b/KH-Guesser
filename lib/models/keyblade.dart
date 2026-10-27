import 'dart:convert';
import 'package:flutter/services.dart';

class Keyblade {
  Keyblade({
    required this.id,
    required this.name,
    required this.debutGame,
    this.strength,
    this.magic,
    this.wielders,
    required this.appearances,
    required this.imageUrl,
  });

  final int id;
  final String name;
  final String debutGame;
  final int? strength;
  final int? magic;
  final List<String>? wielders;
  final int appearances;
  final String imageUrl;

  factory Keyblade.fromJson(Map<String, dynamic> json) {
    final String nameForImage = (json['name'] as String).replaceAll(' ', '_').replaceAll('/', '');

    return Keyblade(
      id: json['id'] as int,
      name: json['name'] as String,
      debutGame: json['debutGame'] as String,
      strength: json['strength'] as int?,
      magic: json['magic'] as int?,
      wielders: (json['wielders'] as List<dynamic>?)
          ?.map((w) => w as String)
          .toList(),
      appearances: json['appearances'] as int,
      imageUrl: 'assets/images/keyblades/$nameForImage.png',
    );
  }

  Map<String, dynamic> toMap() => {
    'image': imageUrl,
    'name': name,
    'debutGame': debutGame,
    'strength': strength,
    'magic': magic,
    'wielders': wielders,
    'appearances': appearances,
  };
}

final Set<Keyblade> allKeyblades = {};

Future<void> loadKeyblades() async {
  final String response = await rootBundle.loadString('assets/json/keyblades.json');
  final Map<String, dynamic> data = json.decode(response) as Map<String, dynamic>;
  final List<dynamic> keyblades = data['keyblades'] as List<dynamic>;

  allKeyblades.addAll(
    keyblades.map((item) => Keyblade.fromJson(item as Map<String, dynamic>)),
  );
}