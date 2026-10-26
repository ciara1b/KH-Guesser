import 'package:flutter/material.dart';
import 'package:khdle/widgets/back_button.dart';
import 'package:khdle/widgets/game.dart';
import 'package:khdle/widgets/info_button.dart';
import 'package:khdle/widgets/keyblade_game.dart';

class GuessKeybladePage extends StatelessWidget {
  const GuessKeybladePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('guessing-bg-light.png'),
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
                      child: GamePage(Game(), possibleKeyblades, categories),
                    ),
                  ),
                ),
              ),
            ),
            CustomBackButton(),
            CustomInfoButton(),
          ],
        ),
      ),
    );
  }
}