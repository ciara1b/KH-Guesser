import 'package:flutter/material.dart';
import 'package:khdle/widgets/assets.dart';
import 'package:khdle/models/category_info.dart';
import 'package:khdle/screens/game_layout.dart';
import 'package:khdle/widgets/custom/back_button.dart';
import 'package:khdle/widgets/custom/info_button.dart';
import 'package:khdle/widgets/game.dart';

class GuessKeybladePage extends StatefulWidget {
  const GuessKeybladePage({super.key});

  @override
  State<GuessKeybladePage> createState() => _GuessKeybladePageState();
}

class _GuessKeybladePageState extends State<GuessKeybladePage> {
  late final Future<GuessGame> _gameFuture = GameRepository.get(
    'keyblade',
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
                  final game = snap.data! as KeybladeGame;
                  return GamePage(
                    game,
                    keybladeCategories,
                    game.guessFromName(game.hiddenKeyblade.name),
                  );
                },
              ),
            ),
            CustomBackButton(),
            CustomInfoButton(keybladeCategories),
          ],
        ),
      ),
    );
  }
}
