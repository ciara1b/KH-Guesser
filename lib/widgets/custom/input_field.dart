import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:khdle/widgets/assets.dart';

class InputField extends StatefulWidget {
  const InputField({
    super.key,
    required this.gameType,
    required this.gameOver,
    required this.onSubmitGuess,
    required this.remainingSolutions,
  });

  final String Function() gameType;
  final bool gameOver;
  final void Function(String) onSubmitGuess;
  final List<String> remainingSolutions;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _suggestionsScrollController = ScrollController();
  final Map<String, String> _lowerCaseCache = {};

  static final List<Shadow> _buttonShadows = outlinedText();

  late final FocusNode _focusNode = FocusNode(
    onKeyEvent: (node, event) {
      final isEnter =
          event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.numpadEnter;
      if (isEnter) {
        if (event is KeyDownEvent) _onSubmit();
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    },
  );

  static List<Shadow> outlinedText({
    double strokeWidth = 1,
    Color strokeColor = AppColours.black,
    int precision = 5,
  }) {
    Set<Shadow> result = HashSet();
    for (int x = 1; x < strokeWidth + precision; x++) {
      for (int y = 1; y < strokeWidth + precision; y++) {
        double offsetX = x.toDouble();
        double offsetY = y.toDouble();
        result.add(
          Shadow(
            offset: Offset(-strokeWidth / offsetX, -strokeWidth / offsetY),
            color: strokeColor,
          ),
        );
        result.add(
          Shadow(
            offset: Offset(-strokeWidth / offsetX, strokeWidth / offsetY),
            color: strokeColor,
          ),
        );
        result.add(
          Shadow(
            offset: Offset(strokeWidth / offsetX, -strokeWidth / offsetY),
            color: strokeColor,
          ),
        );
        result.add(
          Shadow(
            offset: Offset(strokeWidth / offsetX, strokeWidth / offsetY),
            color: strokeColor,
          ),
        );
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
    final text = _textEditingController.text.trim();
    if (text.isEmpty) return;
    widget.onSubmitGuess(text);
    _textEditingController.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 8.0, bottom: 16.0, right: 8.0),
            child: TypeAheadField<String>(
              constraints: BoxConstraints(maxHeight: 384),
              debounceDuration: Duration(milliseconds: 50),
              controller: _textEditingController,
              focusNode: _focusNode,
              scrollController: _suggestionsScrollController,
              hideOnEmpty: true,
              builder: (context, controller, focusNode) {
                return TextField(
                  controller: controller,
                  enabled: !widget.gameOver,
                  focusNode: focusNode,
                  maxLength: 32,
                  textInputAction: TextInputAction.send,
                  decoration: InputDecoration(
                    fillColor: AppColours.white,
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
              suggestionsCallback: (pattern) {
                if (pattern.length < 2) return null;
                final p = pattern.toLowerCase();
                final results = <String>[];
                for (final s in widget.remainingSolutions) {
                  if (_lowerCaseCache
                      .putIfAbsent(s, s.toLowerCase)
                      .contains(p)) {
                    results.add(s);
                    if (results.length == 5) break;
                  }
                }
                return results;
              },
              itemBuilder: (context, suggestion) => Material(
                color: AppColours.darkGrey,
                child: ListTile(
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 16.0,
                    children: [
                      SizedBox(
                        width: 48,
                        child: Semantics(
                          label:
                              "Render of Kingdom Hearts ${widget.gameType()}",
                          child: Image.asset(
                            'assets/images/${widget.gameType()}s/${suggestion.replaceAll(RegExp(r"[',./]"), "").replaceAll("χ", "X").replaceAll(' ', '_')}.png',
                            height: 48,
                            cacheHeight: 96,
                            gaplessPlayback: true,
                            errorBuilder: (_, _, _) => SizedBox(height: 48),
                          ),
                        ),
                      ),
                      Text(suggestion),
                    ],
                  ),
                  textColor: AppColours.white,
                  hoverColor: AppColours.crimson,
                  focusColor: AppColours.crimson,
                  onTap: () => _textEditingController.text = suggestion,
                ),
              ),
              decorationBuilder: (context, child) => Material(
                type: MaterialType.card,
                color: AppColours.darkGrey,
                surfaceTintColor: Colors.transparent,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(width: 1, color: AppColours.crimson),
                ),
                clipBehavior: Clip.antiAlias,
                child: ScrollbarTheme(
                  data: ScrollbarThemeData(
                    thumbColor: WidgetStatePropertyAll(AppColours.white),
                    trackVisibility: WidgetStatePropertyAll(false),
                    thickness: WidgetStatePropertyAll(6),
                    radius: Radius.circular(3),
                    crossAxisMargin: 3,
                  ),
                  child: Scrollbar(
                    controller: _suggestionsScrollController,
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context)
                          .copyWith(scrollbars: false),
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
          padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
          child: Container(
            constraints: BoxConstraints(
              minWidth: 128,
              minHeight: 48,
              maxHeight: 384,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: AppColours.dangerRed, width: 3.0),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
                bottomLeft: Radius.circular(5.0),
                topRight: Radius.circular(5.0),
              ),
              gradient: LinearGradient(
                begin: AlignmentGeometry.topCenter,
                end: AlignmentGeometry.bottomCenter,
                colors: [AppColours.bloodRed, AppColours.dangerRed],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColours.magenta,
                  offset: Offset.fromDirection(1.0, 4.0),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: AppColours.white,
                textStyle: TextStyle(shadows: _buttonShadows, fontSize: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                    bottomLeft: Radius.circular(5.0),
                    topRight: Radius.circular(5.0),
                  ),
                ),
              ),
              child: Text('Send'),
            ),
          ),
        ),
      ],
    );
  }
}
