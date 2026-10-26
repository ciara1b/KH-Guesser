import 'package:flutter/material.dart';
import 'package:khdle/data/category_info.dart';
import 'package:khdle/widgets/tile.dart';
import 'package:khdle/widgets/guess_input.dart';

class GamePage extends StatefulWidget {
  const GamePage(this.gameType, this.possibleSolutions, this.categories, {super.key});

  final dynamic gameType;
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
            height: 128.0,
            child: GuessInput(
              remainingCharacters: widget.possibleSolutions,
              didWin: () => widget.gameType.didWin,
              onSubmitGuess: (String guess) {
                setState(() {
                  widget.gameType.guess(guess);
                });
                widget.possibleSolutions.remove(guess);
              },
            )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!widget.gameType.guesses.first.isEmpty)
                for (var categoryType in widget.categories)
                  SizedBox(
                    width: tileSlot,
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
                                  fontWeight: FontWeight.bold,
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
          for (var guess in widget.gameType.guesses.reversed)
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
