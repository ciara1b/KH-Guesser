import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:khdle/models/category_info.dart';

class CustomInfoButton extends StatelessWidget {
  const CustomInfoButton(this.info, {super.key});

  final List<CategoryInfo> info;

  List<TextSpan> buildInfoSpans() {
    final spans = <TextSpan>[];

    for (CategoryInfo c in info) {
      if (c.value is String) {
        spans.add(
          TextSpan(
            text: c.category.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'KH-Numbers',
              fontSize: 12,
            ),
          ),
        );
        spans.add(TextSpan(text: '\n${c.value}\n\n'));
      }
    }

    spans.add(
      TextSpan(
        text: 'GAMES INCLUDED\n',
        style: const TextStyle(
          fontFamily: 'KH-Numbers',
          fontSize: 12,
        ),
      )
    );

    for (String gameName in games) {
      spans.add(
        TextSpan(
          text: ' • ',
          style: const TextStyle(
            fontFamily: 'KH-Numbers',
          ),
        ),
      );
      spans.add(
        TextSpan(
          text: '$gameName\n'
        ),
      );
    }

    spans.add(
      TextSpan(
        text: 'N.B. some canon and non-canon secret endings debut characters and keyblades.',
      )
    );

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: EdgeInsets.only(right: 24.0, top: 16.0),
          child: Transform.rotate(
            angle: math.pi / 4,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                border: const Border(
                  right: BorderSide(color: Color(0xFFE53E01), width: 2.0),
                  bottom: BorderSide(color: Color(0xFFE53E01), width: 2.0),
                ),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFE53E01), Color(0xFFFD8305)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: const Color(0xFFE53E01), // dark navy, like 0xFF491225 is for red
                    offset: Offset.fromDirection(6.0, 3.0),
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      constraints: BoxConstraints(maxWidth: 512),
                      child: Container(
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
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text.rich(
                                  TextSpan(children: buildInfoSpans()),
                                  style: const TextStyle(
                                    color: Color(0xFFFDFFFD),
                                  ),
                                ),
                              ),
                            ),
                          )],
                        ),
                      ),
                    );
                  }
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ).copyWith(
                  overlayColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.pressed)) {
                      return Colors.white.withValues(alpha: 0.3);
                    }
                    if (states.contains(WidgetState.hovered)) {
                      return Colors.white.withValues(alpha: 0.2);
                    }
                    return null;
                  }),
                ),
                child: Transform.rotate(
                  angle: -math.pi / 4,
                  child: Text(
                    'i',
                    style: TextStyle(
                      color: Color(0xFFFDFFFD),
                      fontSize: 36,
                      fontFamily: 'TitanOne',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
