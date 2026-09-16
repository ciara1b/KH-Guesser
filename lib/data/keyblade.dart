import 'dart:convert';
import 'package:flutter/services.dart';

class Keyblade {
  Keyblade({
    required this.id,
    required this.name,
    required this.origin,
    required this.strength,
    required this.magic,
    this.wielders,
    required this.appearances,
  });

  final int id;
  final String name;
  final String origin;
  final int strength;
  final int magic;
  final List<String>? wielders;
  final int appearances;

  factory Keyblade.fromJson(Map<String, dynamic> json) {
    return Keyblade(
      id: json['id'] as int,
      name: json['name'] as String,
      origin: json['origin'] as String,
      strength: json['strength'] as int,
      magic: json['magic'] as int,
      wielders: (json['wielders'] as List<dynamic>?)
          ?.map((w) => w as String)
          .toList(),
      appearances: json['appearances'] as int,
    );
  }
}

final Set<Keyblade> allKeyblades = {};

Future<void> loadKeyblades() async {
  final String response = await rootBundle.loadString('assets/keyblades.json');
  final Map<String, dynamic> data = json.decode(response) as Map<String, dynamic>;
  final List<dynamic> keyblades = data['keyblades'] as List<dynamic>;

  allKeyblades.addAll(
    keyblades.map((item) => Keyblade.fromJson(item as Map<String, dynamic>)),
  );
}