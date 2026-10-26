import 'package:flutter/material.dart';
import 'package:khdle/data/category_info.dart';
import 'package:khdle/widgets/gradient_progress_bar.dart';
import 'package:khdle/widgets/tile.dart';
import 'package:khdle/widgets/guess_input.dart';

class GamePage extends StatefulWidget {
  const GamePage(this.game, this.possibleSolutions, this.categories, {super.key});

  final dynamic game;
  final List<String> possibleSolutions;
  final List<CategoryInfo> categories;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {

  @override
  Widget build(BuildContext context) {
    final double rowWidth = 4 * tileSlot;

    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        children: [
          SizedBox(
            width: rowWidth,
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
          SizedBox(
            width: rowWidth,
            height: 128.0,
            child: GuessInput(
              gameType: () => widget.game.gameType,
              didWin: () => widget.game.didWin,
              remainingSolutions: widget.possibleSolutions,
              onSubmitGuess: (String guess) {
                setState(() {
                  widget.game.guess(guess);
                });
                widget.possibleSolutions.remove(guess);
              },
            )
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
