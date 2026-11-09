import 'package:flutter/material.dart';
import 'package:khdle/widgets/assets.dart';
import 'package:khdle/models/category_info.dart';
import 'package:khdle/screens/game_layout.dart';
import 'package:khdle/widgets/custom/back_button.dart';
import 'package:khdle/widgets/custom/info_button.dart';
import 'package:khdle/widgets/game.dart';

class GuessCharacterPage extends StatefulWidget {
  const GuessCharacterPage({super.key});

  @override
  State<GuessCharacterPage> createState() => _GuessCharacterPageState();
}

class _GuessCharacterPageState extends State<GuessCharacterPage> {
  late final Future<GuessGame> _gameFuture = GameRepository.get(
    'character',
    seed:
        13700000000 +
        (int.parse(
              DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
              ).toString().replaceAll("-", "").replaceAll(" 00:00:00.000", ""),
            ) -
            20261108),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(image: gameBg, fit: BoxFit.cover),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              top: 64,
              child: FutureBuilder<GuessGame>(
                future: _gameFuture,
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final game = snap.data! as CharacterGame;
                  return GamePage(
                    game,
                    characterCategories,
                    game.guessFromName(game.hiddenCharacter.name),
                  );
                },
              ),
            ),
            CustomBackButton(),
            CustomInfoButton(characterCategories),
          ],
        ),
      ),
    );
  }
}
