import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:khdle/widgets/character_game.dart';

const double tileSize = 128;
const double tilePadding = 8;
const double tileSlot = tileSize + tilePadding * 2;

class Tile extends StatelessWidget {
  const Tile(this.value, this.hitType, this.clue, {super.key});

  final dynamic value;
  final HitType hitType;
  final dynamic clue;

  String _display(dynamic value) {
    if (value == null) return '';
    if (value is List) return value.join(', ');
    if (value == true) return 'Yes';
    if (value == false) return 'No';
    return value.toString();
  }

  static List<Shadow> outlinedText({double strokeWidth = 1, Color strokeColor = Colors.black, int precision = 5}) {
    Set<Shadow> result = HashSet();
    for (int x = 1; x < strokeWidth + precision; x++) {
      for(int y = 1; y < strokeWidth + precision; y++) {
        double offsetX = x.toDouble();
        double offsetY = y.toDouble();
        result.add(Shadow(offset: Offset(-strokeWidth / offsetX, -strokeWidth / offsetY), color: strokeColor));
        result.add(Shadow(offset: Offset(-strokeWidth / offsetX, strokeWidth / offsetY), color: strokeColor));
        result.add(Shadow(offset: Offset(strokeWidth / offsetX, -strokeWidth / offsetY), color: strokeColor));
        result.add(Shadow(offset: Offset(strokeWidth / offsetX, strokeWidth / offsetY), color: strokeColor));
      }
    }
    return result.toList();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.bounceIn,
      width: tileSize,
      height: tileSize,
      decoration: BoxDecoration(
        image: value is int && hitType != HitType.hit ? (clue != null && clue ? DecorationImage(image: NetworkImage('assets/up-arrow.png'), fit: BoxFit.cover, opacity: 0.1) : DecorationImage(image: NetworkImage('assets/down-arrow.png'), fit: BoxFit.cover, opacity: 0.1)) : null,
        border: Border.all(
          color: Color.fromARGB(255, 94, 93, 93),
          width: 3.0,
        ),
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        color: switch (hitType) {
          HitType.hit => Color(0xFF34A314),
          HitType.partial => Color(0xFFffdb5b),
          HitType.miss => Color(0xFF272727),
          _ => Colors.white,
        },
      ),
      child: Center(
        child: Padding(padding: EdgeInsets.all(tilePadding), child: Text(
          _display(value),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight(900),
            fontSize: 16,
            color: Color(0xFFFDFFFD),
            shadows: outlinedText(),
          ),
        )),
      ),
    );
  }
}
