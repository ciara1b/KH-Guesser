import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class GuessInput extends StatefulWidget {
  const GuessInput({super.key, required this.gameType, required this.didWin, required this.onSubmitGuess, required this.remainingSolutions});

  final String Function() gameType;
  final bool Function() didWin;
  final void Function(String) onSubmitGuess;
  final List<String> remainingSolutions;

  @override
  State<GuessInput> createState() => _GuessInputState();
}

class _GuessInputState extends State<GuessInput> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _suggestionsScrollController = ScrollController();

  static List<Shadow> outlinedText({double strokeWidth = 1, Color strokeColor = Colors.black, int precision = 5}) {
    Set<Shadow> result = HashSet();
    for (int x = 1; x < strokeWidth + precision; x++) {
      for(int y = 1; y < strokeWidth + precision; y++) {
        double offsetX = x.toDouble();
        double offsetY = y.toDouble();
        result.add(Shadow(offset: Offset(-strokeWidth / offsetX, -strokeWidth / offsetY), color: strokeColor));
        result.add(Shadow(offset: Offset(-strokeWidth / offsetX, strokeWidth / offsetY), color: strokeColor));
        result.add(Shadow(offset: Offset(strokeWidth / offsetX, -strokeWidth / offsetY), color: strokeColor));
        result.add(Shadow(offset: Offset(strokeWidth / offsetX, strokeWidth / offsetY), color: strokeColor));
      }
    }
    return result.toList();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    _suggestionsScrollController.dispose();
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
            padding: const EdgeInsets.only(top: 8.0, bottom: 16.0, right: 8.0),
            child: TypeAheadField<String>(
              constraints: BoxConstraints(maxHeight: 384),
              controller: _textEditingController,
              focusNode: _focusNode,
              scrollController: _suggestionsScrollController,
              builder: (context, controller, focusNode) {
                return TextField(
                  controller: controller,
                  enabled: !widget.didWin(),
                  focusNode: focusNode,
                  maxLength: 32,
                  decoration: InputDecoration(
                    fillColor: Color(0xFFFDFFFD),
                    filled: true,
                    counterText: '',
                    hintText: 'Type any ${widget.gameType()}...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  autofocus: true,
                  onSubmitted: (_) => _onSubmit(),
                );
              },
              suggestionsCallback: (pattern) async {
                return pattern.length >= 2 ? widget.remainingSolutions
                    .where((s) => s.toLowerCase().contains(pattern.toLowerCase()))
                    .toList() : null;
              },
              itemBuilder: (context, suggestion) => Material(
                color: const Color(0xFF121214),
                child: ListTile(
                  title: Text(suggestion),
                  textColor: Color(0xFFFDFFFD),
                  hoverColor: Color(0xFF42100F),
                  focusColor: Color(0xFF42100F),
                  onTap: () => _textEditingController.text = suggestion,
                ),
              ),
              decorationBuilder: (context, child) => Material(
                type: MaterialType.card,
                color: const Color(0xFF121214),
                surfaceTintColor: Colors.transparent,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(width: 1, color: Color(0xFF42100F)),
                ),
                clipBehavior: Clip.antiAlias,
                child: ScrollbarTheme(
                  data: ScrollbarThemeData(
                    thumbColor: const WidgetStatePropertyAll(Colors.white),
                    thumbVisibility: const WidgetStatePropertyAll(true),
                    trackVisibility: const WidgetStatePropertyAll(false),
                    thickness: const WidgetStatePropertyAll(6),
                    radius: const Radius.circular(3),
                    crossAxisMargin: 3,
                  ),
                  child: Scrollbar(
                    controller: _suggestionsScrollController,
                    thumbVisibility: true,
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                      child: child,
                    ),
                  ),
                ),
              ),
              hideOnSelect: true,
              onSelected: (suggestion) {
                _textEditingController.text = suggestion;
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
          child: Container(
            constraints: BoxConstraints(minWidth: 128, minHeight: 48, maxHeight: 384),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xFFDF1835),
                width: 3.0,
              ),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0), bottomLeft: Radius.circular(5.0), topRight: Radius.circular(5.0)),
              gradient: LinearGradient(
                begin: AlignmentGeometry.topCenter,
                end: AlignmentGeometry.bottomCenter,
                colors: [Color(0xFF9A1129), Color(0xFFDF1835)]
              ),
              boxShadow: [BoxShadow(color: Color(0xFF491225), offset: Offset.fromDirection(1.0, 4.0), spreadRadius: 1)],
            ),
            child: ElevatedButton(
              onPressed: _onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: Colors.white,
                textStyle: TextStyle(shadows: outlinedText(), fontSize: 16.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0), bottomLeft: Radius.circular(5.0), topRight: Radius.circular(5.0))),
              ),
              child: Text('Send'),
            ),
          ),
        ),
      ],
    );
  }
}