import 'package:flutter/material.dart';
import 'package:khdle/widgets/keyblade_game.dart';
import 'package:khdle/widgets/game.dart';

class GuessKeybladePage extends StatelessWidget {
  const GuessKeybladePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Guess Today's Keyblade!")),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('guessing-bg-light.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(child: GamePage(Game(), possibleKeyblades, categories))
      ),
    );
  }
}