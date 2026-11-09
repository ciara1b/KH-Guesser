import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:khdle/models/category_info.dart';
import 'package:khdle/widgets/custom/gradient_progress_bar.dart';
import 'package:khdle/widgets/custom/popup_box.dart';
import 'package:khdle/widgets/custom/tile.dart';
import 'package:khdle/widgets/custom/input_field.dart';

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
  bool _showAnswer = false;
  bool _hasGuessed = false;

  static const _flipStagger = Duration(milliseconds: 500);

  bool get isGameOver =>
      widget.game.didWin || widget.game.guessesRemaining <= 0;

  void _showResultDialog() {
    if (_resultShown) return;
    _resultShown = true;

    final wait = _hasGuessed
        ? _flipStagger * widget.categories.length + Duration(milliseconds: 700)
        : Duration.zero;

    Future.delayed(wait, () {
      if (!mounted) return;
      setState(() => _showAnswer = true);
      showDialog(
        context: context,
        builder: (_) => CustomPopupBox(
          widget.game.didWin,
          widget.game.guessesRemaining,
          () => widget.game.gameType,
        ),
      );
    });
  }

  Widget _buildGuessRow(int index, dynamic guess, bool isNewest) {
    if (guess.isEmpty) return SizedBox();

    final results = guess.categoryResults.toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < results.length; i++)
          Padding(
            padding: EdgeInsets.only(top: tilePadding),
            child: SizedBox(
              width: tileSlot,
              child: Column(
                children: [
                  FlipTile(
                    animate: isNewest && _hasGuessed,
                    delay: _flipStagger * i,
                    child: Tile(
                      results[i].value,
                      results[i].type,
                      results[i].clue,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double contentWidth = math.max(
                constraints.maxWidth,
                math.max(rowWidth, widget.categories.length * tileSlot),
              );

              return SizedBox(
                width: contentWidth,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 32.0),
                      child: SizedBox(
                        width: rowWidth,
                        child: InputField(
                          gameType: () => widget.game.gameType,
                          gameOver: isGameOver,
                          remainingSolutions: widget.game.remainingSolutions,
                          onSubmitGuess: (String guess) {
                            setState(() {
                              _hasGuessed = true;
                              widget.game.guess(guess);
                            });

                            widget.game.save();

                            if (isGameOver) _showResultDialog();
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: rowWidth,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 32.0),
                        child: GradientProgressBar(
                          percent:
                              ((widget.game.guessesRemaining /
                                          widget.game.maxGuesses) *
                                      100)
                                  .round(),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Color(0xFF32FB39), Color(0xFFC0FF0D)],
                          ),
                          backgroundColor: Color(0xFF171928),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          children: [
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  categoryType.category,
                                                  style: TextStyle(
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
                            if (_showAnswer && !widget.game.didWin)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (var category
                                      in widget.answer.categoryResults)
                                    Padding(
                                      padding: EdgeInsetsGeometry.only(
                                        top: tilePadding,
                                      ),
                                      child: SizedBox(
                                        width: tileSlot,
                                        child: Column(
                                          children: [
                                            Tile(
                                              category.value,
                                              HitType.none,
                                              null,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ...() {
                              final guesses = widget.game.guesses as List;
                              final newest = widget.game.activeIndex - 1;
                              return [
                                for (int i = guesses.length - 1; i >= 0; i--)
                                  _buildGuessRow(i, guesses[i], i == newest),
                              ];
                            }(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        Padding(
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
