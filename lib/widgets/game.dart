import 'package:flutter/material.dart';
import 'package:khdle/widgets/character_game.dart';
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
      padding: const EdgeInsets.all(tilePadding),
      child: Column(
        children: [
          SizedBox(
            width: rowWidth,
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
                                ),
                              ),
                            ),
                            if (categoryType.value is String) ...[
                              const SizedBox(width: tilePadding / 2),
                              Tooltip(
                                message: categoryType.value,
                                constraints: BoxConstraints(maxWidth: rowWidth / 2),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xFF0191CE),
                                    width: 3.0,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  gradient: LinearGradient(
                                    begin: AlignmentGeometry.topCenter,
                                    end: AlignmentGeometry.bottomCenter,
                                    colors: [Color(0xFF0191CE), Color(0xFF002077)]
                                  ),
                                  boxShadow: [BoxShadow(color: Colors.black, blurRadius: 0.5, spreadRadius: 0.5)],
                                ),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: Icon(
                                      Icons.info_outline,
                                      size: 14,
                                      color: Color(0xFFFDFFFD)
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
