import 'package:flutter/material.dart';
import 'package:khdle/assets.dart';
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
  final Game _game = Game(
    seed: 13700000000 + (int.parse(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toString().replaceAll("-", "").replaceAll(" 00:00:00.000", "")) - 20261108)
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: gameBg,
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              top: 64,
              child: GamePage(
                _game,
                categories,
                CharacterGuess.fromString(_game.hiddenCharacter.name),
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