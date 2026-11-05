import 'package:flutter/material.dart';
import 'package:khdle/models/category_info.dart';
import 'package:khdle/widgets/custom/gradient_progress_bar.dart';
import 'package:khdle/widgets/custom/popup_box.dart';
import 'package:khdle/widgets/custom/tile.dart';
import 'package:khdle/widgets/custom/guess_input.dart';

class GamePage extends StatefulWidget {
  const GamePage(this.game, this.categories, this.answer, {super.key});

  final dynamic game;
  final List<CategoryInfo> categories;
  final dynamic answer;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  bool _resultShown = false;

  bool get isGameOver =>
    widget.game.didWin || widget.game.guessesRemaining <= 0;

  void _showResultDialog() {
    if (_resultShown) return;
    _resultShown = true;

    showDialog(
      context: context,
      builder: (_) =>
        CustomPopupBox(widget.game.didWin, widget.game.guessesRemaining, () => widget.game.gameType),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && isGameOver) _showResultDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double rowWidth = 4 * tileSlot;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: rowWidth,
                  child: GuessInput(
                    gameType: () => widget.game.gameType,
                    gameOver: isGameOver,
                    remainingSolutions: widget.game.remainingSolutions,
                    onSubmitGuess: (String guess) {
                      setState(() {
                        widget.game.guess(guess);
                      });

                      if (isGameOver) _showResultDialog();
                    },
                  ),
                ),
                SizedBox(
                  width: rowWidth,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 32.0),
                    child: GradientProgressBar(
                      percent: ((widget.game.guessesRemaining / widget.game.maxGuesses) * 100).round(),
                      gradient: const LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Color(0xFF32FB39),
                          Color(0xFFC0FF0D),
                        ],
                      ),
                      backgroundColor: const Color(0xFF171928),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!widget.game.guesses.first.isEmpty)
                      for (var categoryType in widget.categories)
                        SizedBox(
                          width: tileSlot,
                          height: tileSize / 4,
                          child: Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Text(
                                      categoryType.category,
                                      style: const TextStyle(
                                        color: Color(0xFFFDFFFD),
                                        fontSize: 10,
                                        fontFamily: 'KH-Numbers',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                  ],
                ),
                if (_resultShown && !widget.game.didWin)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var category in widget.answer.categoryResults)
                        Padding(
                          padding: EdgeInsetsGeometry.only(top: tilePadding),
                          child: SizedBox(
                            width: tileSlot,
                            child: Column(
                              children: [
                                Tile(category.value, HitType.none, null),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                for (var guess in widget.game.guesses.reversed)
                  guess.isEmpty
                      ? const SizedBox()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (var category in guess.categoryResults)
                              Padding(
                                padding: EdgeInsetsGeometry.only(top: tilePadding),
                                child: SizedBox(
                                  width: tileSlot,
                                  child: Column(
                                    children: [
                                      Tile(category.value, category.type, category.clue),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
              ],
            ),
          ),
        ),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
          child: Text(
            "Zekrofire is not affiliated with Disney or Square Enix and does not own or claim any rights to any trademark belonging to either party.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontFamily: "ScienceGothic",
              fontSize: 12.0,
            ),
          ),
        ),
      ],
    );
  }
}