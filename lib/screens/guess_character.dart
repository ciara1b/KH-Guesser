import 'package:flutter/material.dart';
import 'package:khdle/widgets/character_game.dart';
import 'package:khdle/widgets/game.dart';

class GuessCharacterPage extends StatelessWidget {
  const GuessCharacterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Guess Today's Character!")),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('guessing-bg-light.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(child: GamePage(Game(), possibleCharacters, categories))
      ),
    );
  }
}