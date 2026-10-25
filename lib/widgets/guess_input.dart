import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class GuessInput extends StatefulWidget {
  const GuessInput({super.key, required this.onSubmitGuess, required this.remainingCharacters, required this.didWin});

  final void Function(String) onSubmitGuess;
  final List<String> remainingCharacters;
  final bool Function() didWin;

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
                  enabled: !widget.didWin(),
                  focusNode: focusNode,
                  maxLength: 32,
                  decoration: const InputDecoration(
                    fillColor: Color(0xFFFDFFFD),
                    filled: true,
                    counterText: '',
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
