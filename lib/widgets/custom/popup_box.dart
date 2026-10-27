import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomPopupBox extends StatelessWidget {
  const CustomPopupBox(this.boolInfo, this.numInfo, {super.key});

  final bool boolInfo;
  final int numInfo;

  @override
  Widget build(BuildContext context) {
    final String clipboardText = "I ${boolInfo ? "won with $numInfo guesses remaining." : "lost"} today's Kingdom Hearts character guesser!\nThink you can beat me? Try it out here: https://www.khguesser.com";

    return SafeArea(
      child: Align(
        alignment: Alignment.topRight,
        child: Dialog(
          constraints: BoxConstraints(minWidth: 320, maxWidth: 512),
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
                            style: const TextStyle(
                              fontFamily: 'ITCBenguiatStdBold',
                              fontSize: 48,
                            ).copyWith(
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 6
                                ..strokeJoin = StrokeJoin.round
                                ..color = const Color(0xFF272727),
                            ),
                          ),
                          ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (bounds) => LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFFEF6F13),
                                Color(0xFFFEC902),
                              ]).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                            ),
                            child: Text(
                              boolInfo ? 'YOU WIN!' : 'YOU LOSE!',
                              style: const TextStyle(
                                fontFamily: 'ITCBenguiatStdBold',
                                fontSize: 48,
                              ),
                            )
                          ),
                        ],
                      ),
                      Text(
                        'Share your result online:',
                        style: const TextStyle(
                          color: Color(0xFFFDFFFD),
                        )
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromARGB(255, 94, 93, 93),
                            width: 3.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          color: Color(0xFF272727),
                          boxShadow: [BoxShadow(color: Colors.black, blurRadius: 0.5, spreadRadius: 0.5)],
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
                                  style: TextStyle(
                                    color: Color(0xFFFDFFFD),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                await Clipboard.setData(ClipboardData(text: clipboardText));
                              },
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                hoverColor: Colors.white24,
                                highlightColor: Colors.white24,
                                fixedSize: const Size(44, 44),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(6.0),
                                    bottomLeft: Radius.circular(6.0),
                                  ),
                                ),
                              ),
                              icon: Icon(
                                Icons.copy,
                                color: Color(0xFFFDFFFD),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
