import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:khdle/models/category_info.dart';
import 'package:khdle/widgets/assets.dart';

class CustomInfoButton extends StatelessWidget {
  const CustomInfoButton(this.info, {this.useCanonGames = false, super.key});

  final List<CategoryInfo> info;
  final bool useCanonGames;

  List<TextSpan> buildInfoSpans() {
    final spans = <TextSpan>[];

    for (CategoryInfo c in info) {
      if (c.value is String) {
        spans.add(
          TextSpan(
            text: c.category.toUpperCase(),
            style: TextStyle(fontFamily: 'KH-Numbers', fontSize: 12),
          ),
        );
        spans.add(TextSpan(text: '\n${c.value}\n\n'));
      }
    }

    spans.add(
      TextSpan(
        text: 'GAMES INCLUDED\n',
        style: TextStyle(fontFamily: 'KH-Numbers', fontSize: 12),
      ),
    );

    for (String gameName in (useCanonGames ? canonicalGames : games)) {
      spans.add(
        TextSpan(
          text: ' • ',
          style: TextStyle(fontFamily: 'KH-Numbers'),
        ),
      );
      spans.add(TextSpan(text: '$gameName\n'));
    }

    spans.add(
      TextSpan(
        text: 'N.B. some canon and non-canon secret endings debut characters and keyblades.',
      ),
    );

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    return SafeArea(
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: EdgeInsets.only(right: 32.0, top: 24.0),
          child: Transform.rotate(
            angle: math.pi / 4,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: AppColours.deepOrange, width: 2.0),
                  bottom: BorderSide(color: AppColours.deepOrange, width: 2.0),
                ),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColours.deepOrange, AppColours.brightOrange],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColours.black.withValues(alpha: 0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: AppColours.deepOrange,
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
                            color: AppColours.seaBlue,
                            width: 3.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          gradient: LinearGradient(
                            begin: AlignmentGeometry.topCenter,
                            end: AlignmentGeometry.bottomCenter,
                            colors: [AppColours.seaBlue, AppColours.oceanBlue],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColours.black,
                              blurRadius: 0.5,
                              spreadRadius: 0.5,
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 4.0),
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text.rich(
                                      TextSpan(children: buildInfoSpans()),
                                      style: TextStyle(color: AppColours.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                style:
                    ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ).copyWith(
                      overlayColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.pressed)) {
                          return AppColours.white.withValues(alpha: 0.3);
                        }
                        if (states.contains(WidgetState.hovered)) {
                          return AppColours.white.withValues(alpha: 0.2);
                        }
                        return null;
                      }),
                    ),
                child: Transform.rotate(
                  angle: -math.pi / 4,
                  child: Text(
                    'i',
                    style: TextStyle(
                      color: AppColours.white,
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
