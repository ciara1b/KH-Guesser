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
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('guessing-bg-light.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              // Content is at least as tall as the page, so it lays out as
              // before, and grows (and scrolls) once it exceeds the page.
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Align(
                alignment: Alignment.topCenter,
                child: GamePage(Game(), possibleCharacters, categories),
              ),
            ),
          ),
        ),
      ),
    );
  }
}