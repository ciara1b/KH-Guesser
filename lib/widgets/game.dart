import 'package:flutter/material.dart';
import 'package:khdle/models/category_info.dart';
import 'package:khdle/widgets/custom/gradient_progress_bar.dart';
import 'package:khdle/widgets/custom/popup_box.dart';
import 'package:khdle/widgets/custom/tile.dart';
import 'package:khdle/widgets/custom/guess_input.dart';

class GamePage extends StatefulWidget {
  const GamePage(this.game, this.possibleSolutions, this.categories, {super.key});

  final dynamic game;
  final List<String> possibleSolutions;
  final List<CategoryInfo> categories;

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
        CustomPopupBox(widget.game.didWin, widget.game.guessesRemaining),
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

    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        children: [
          SizedBox(
            width: rowWidth,
            child: GuessInput(
              gameType: () => widget.game.gameType,
              gameOver: isGameOver,
              remainingSolutions: widget.possibleSolutions,
              onSubmitGuess: (String guess) {
                setState(() {
                  widget.game.guess(guess);
                });
                widget.possibleSolutions.remove(guess);

                if (isGameOver) _showResultDialog();
              },
            )
          ),
          SizedBox(
            width: rowWidth,
            child: Padding(
              padding: EdgeInsets.only(bottom: 32.0),
              child: GradientProgressBar(
                percent: ((widget.game.guessesRemaining / widget.game.maxGuesses) * 100).round(),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color(0xFF32FB39),
                    Color(0xFFC0FF0D)
                  ],
                ),
                backgroundColor: Color(0xFF171928),
              )
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
                                style: TextStyle(
                                  color: Color(0xFFFDFFFD),
                                  fontSize: 10,
                                  fontFamily: 'KH-Numbers'
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
          for (var guess in widget.game.guesses.reversed)
            guess.isEmpty ? SizedBox() :
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var category in guess.categoryResults)
                    Padding(
                      padding: EdgeInsetsGeometry.only(top: tilePadding),
                      child: SizedBox(
                        width: tileSlot,
                        child: Column(
                          children: [
                            Tile(category.value, category.type, category.clue)
                          ]
                        )
                      )
                    ),
                ],
              ),
        ],
      ),
    );
  }
}