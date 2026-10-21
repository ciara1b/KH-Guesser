import 'package:flutter/material.dart';
import 'package:khdle/character_game.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

const double tileSize = 128;
const double tilePadding = 8;
const double tileSlot = tileSize + tilePadding * 2;

class GuessCharacterPage extends StatelessWidget {
  const GuessCharacterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Guess Today's Character!")),
      body: Center(child: GamePage()),
    );
  }
}

class Tile extends StatelessWidget {
  const Tile(this.value, this.hitType, this.clue, {super.key});

  final dynamic value;
  final HitType hitType;
  final dynamic clue;

  String _display(dynamic value) {
    if (value == null) return '';
    if (value is List) return value.join(', ');
    if (value == true) return 'Yes';
    if (value == false) return 'No';
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.bounceIn,
      width: tileSize,
      height: tileSize,
      decoration: BoxDecoration(
        image: value is int && hitType != HitType.hit ? (clue != null && clue ? DecorationImage(image: NetworkImage('assets/up-arrow.png'), fit: BoxFit.cover, opacity: 0.1) : DecorationImage(image: NetworkImage('assets/down-arrow.png'), fit: BoxFit.cover, opacity: 0.1)) : null,
        border: Border.all(color: Colors.grey.shade300),
        color: switch (hitType) {
          HitType.hit => Colors.green,
          HitType.partial => Colors.yellow,
          HitType.miss => Colors.grey,
          _ => Colors.white,
        },
      ),
      child: Center(
        child: Padding(padding: EdgeInsets.all(tilePadding), child: Text(
          _display(value),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight(900),
            fontSize: 16,
          ),
        )),
      ),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final Game _game = Game();

  var guessableSolutions = possibleCharacters;

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
              remainingCharacters: guessableSolutions,
              onSubmitGuess: (String guess) {
                setState(() {
                  _game.guess(guess);
                });
                guessableSolutions.remove(guess);
              },
            )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_game.guesses.first.isEmpty)
                for (var categoryType in categories)
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
                              ),
                            ),
                            if (categoryType.value is String) ...[
                              const SizedBox(width: tilePadding / 2),
                              Tooltip(
                                message: categoryType.value,
                                constraints: BoxConstraints(maxWidth: rowWidth / 2),
                                child: Align(alignment: Alignment.topRight, child: Padding(padding: const EdgeInsets.only(right: 4.0), child: Icon(Icons.info_outline, size: 14))),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                ),
            ],
          ),
          for (var guess in _game.guesses.reversed)
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

class GuessInput extends StatefulWidget {
  const GuessInput({super.key, required this.onSubmitGuess, required this.remainingCharacters});

  final void Function(String) onSubmitGuess;
  final List<String> remainingCharacters;

  @override
  State<GuessInput> createState() => _GuessInputState();
}

class _GuessInputState extends State<GuessInput> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSubmit() {
    widget.onSubmitGuess(_textEditingController.text);
    _textEditingController.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TypeAheadField<String>(
              controller: _textEditingController,
              focusNode: _focusNode,
              builder: (context, controller, focusNode) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  maxLength: 32,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(35)),
                    ),
                  ),
                  autofocus: true,
                  onSubmitted: (_) => _onSubmit(),
                );
              },
              suggestionsCallback: (pattern) async {
                return widget.remainingCharacters
                    .where((s) => s.toLowerCase().contains(pattern.toLowerCase()))
                    .toList();
              },
              itemBuilder: (context, suggestion) => ListTile(title: Text(suggestion)),
              hideOnSelect: true,
              onSelected: (suggestion) {
                _textEditingController.text = suggestion;
              },
            ),
          ),
        )
      ],
    );
  }
}
