import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:khdle/widgets/assets.dart';

class CustomPopupBox extends StatelessWidget {
  const CustomPopupBox(this.boolInfo, this.numInfo, this.gameType, {super.key});

  final bool boolInfo;
  final int numInfo;
  final String Function() gameType;

  @override
  Widget build(BuildContext context) {
    final String clipboardText =
        "I ${boolInfo ? "won" : "lost"} today's Kingdom Hearts ${gameType()} guesser${boolInfo ? " with $numInfo guesses remaining!\nThink you can beat me? " : ".\n"}Try it out here: https://www.khguesser.com";

    return SafeArea(
      child: Align(
        alignment: Alignment.topRight,
        child: Dialog(
          constraints: BoxConstraints(minWidth: 320, maxWidth: 512),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColours.seaBlue, width: 3.0),
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    spacing: 8.0,
                    children: [
                      Stack(
                        children: [
                          Text(
                            boolInfo ? 'YOU WIN!' : 'YOU LOSE!',
                            style:
                                TextStyle(
                                  fontFamily: 'ITCBenguiatStdBold',
                                  fontSize: 48,
                                ).copyWith(
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 6
                                    ..strokeJoin = StrokeJoin.round
                                    ..color = AppColours.outlineGrey,
                                ),
                          ),
                          ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (bounds) =>
                                LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    AppColours.orange,
                                    AppColours.yellow,
                                  ],
                                ).createShader(
                                  Rect.fromLTWH(
                                    0,
                                    0,
                                    bounds.width,
                                    bounds.height,
                                  ),
                                ),
                            child: Text(
                              boolInfo ? 'YOU WIN!' : 'YOU LOSE!',
                              style: TextStyle(
                                fontFamily: 'ITCBenguiatStdBold',
                                fontSize: 48,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Share your result online:',
                        style: TextStyle(color: AppColours.white),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromARGB(255, 94, 93, 93),
                            width: 3.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          color: AppColours.outlineGrey,
                          boxShadow: [
                            BoxShadow(
                              color: AppColours.black,
                              blurRadius: 0.5,
                              spreadRadius: 0.5,
                            ),
                          ],
                        ),
                        child: Row(
                          spacing: 8.0,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  clipboardText,
                                  style: TextStyle(color: AppColours.white),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                await Clipboard.setData(
                                  ClipboardData(text: clipboardText),
                                );
                              },
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                hoverColor: AppColours.white.withAlpha(60),
                                highlightColor: AppColours.white.withAlpha(60),
                                fixedSize: Size(44, 44),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(6.0),
                                    bottomLeft: Radius.circular(6.0),
                                  ),
                                ),
                              ),
                              icon: Icon(Icons.copy, color: AppColours.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
