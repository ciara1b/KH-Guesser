import 'package:flutter/material.dart';
import 'package:khdle/character_game.dart';

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
  const Tile(this.value, this.hitType, {super.key});

  final dynamic value;
  final HitType hitType;

  String _display(dynamic value) {
    if (value == null) return '';
    if (value is List) return value.join(', ');
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.bounceIn,
      width: 128,
      height: 128,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        color: switch (hitType) {
          HitType.hit => Colors.green,
          HitType.partial => Colors.yellow,
          HitType.miss => Colors.grey,
          _ => Colors.white,
        },
      ),
      child: Center(
        child: Text(
          _display(value),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleSmall,
        ),
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          GuessInput(
            onSubmitGuess: (String guess) {
              setState(() {
                _game.guess(guess);
              });
            },
          ),
          for (var guess in _game.guesses)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var category in guess.categoryResults)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Tile(category.value, category.type),
                  )
              ],
            ),
        ],
      ),
    );
  }
}

class GuessInput extends StatefulWidget {
  const GuessInput({super.key, required this.onSubmitGuess});

  final void Function(String) onSubmitGuess;

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
            child: TextField(
              maxLength: 32,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(35)),
                ),
              ),
              controller: _textEditingController,
              autofocus: true,
              focusNode: _focusNode,
              onSubmitted: (value) {
                _onSubmit();
              },
            ),
          ),
        ),
        IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.arrow_circle_up),
          onPressed: _onSubmit,
        ),
      ],
    );
  }
}
