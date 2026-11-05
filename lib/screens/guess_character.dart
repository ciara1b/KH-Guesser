import 'package:flutter/material.dart';
import 'package:khdle/widgets/custom/back_button.dart';
import 'package:khdle/widgets/character_game.dart';
import 'package:khdle/widgets/game.dart';
import 'package:khdle/widgets/custom/info_button.dart';

class GuessCharacterPage extends StatefulWidget {
  const GuessCharacterPage({super.key});

  @override
  State<GuessCharacterPage> createState() => _GuessCharacterPageState();
}

class _GuessCharacterPageState extends State<GuessCharacterPage> {
  final Game _game = Game();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/guessing-bg-light.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 64),
                      child: GamePage(_game, categories, CharacterGuess.fromString(_game.hiddenCharacter.name)),
                    ),
                  ),
                ),
              ),
            ),
            CustomBackButton(),
            CustomInfoButton(categories, useCanonGames: true),
          ],
        ),
      ),
    );
  }
}