import 'package:flutter/material.dart';
import 'package:khdle/widgets/custom/back_button.dart';
import 'package:khdle/widgets/game.dart';
import 'package:khdle/widgets/custom/info_button.dart';
import 'package:khdle/widgets/keyblade_game.dart';

class GuessKeybladePage extends StatefulWidget {
  const GuessKeybladePage({super.key});

  @override
  State<GuessKeybladePage> createState() => _GuessKeybladePageState();
}

class _GuessKeybladePageState extends State<GuessKeybladePage> {
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
            Positioned.fill(
              top: 64,
              child: GamePage(
                _game,
                categories,
                KeybladeGuess.fromString(_game.hiddenKeyblade.name),
              ),
            ),
            CustomBackButton(),
            CustomInfoButton(categories),
          ],
        ),
      ),
    );
  }
}