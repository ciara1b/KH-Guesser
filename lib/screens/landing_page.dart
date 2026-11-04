import 'package:flutter/material.dart';
import 'package:khdle/widgets/custom/menu_option_button.dart';
import 'guess_character.dart';
import 'guess_enemy.dart';
import 'guess_keyblade.dart';
import 'package:url_launcher/url_launcher.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key, required this.buttonOptions});

  final List<String> buttonOptions;

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
  }

  void _openPage(String value) {
    final Widget screen = switch (value) {
      'Character' => const GuessCharacterPage(),
      'Keyblade' => const GuessKeybladePage(),
      'Enemy' => const GuessEnemyPage(),
      _ => throw ArgumentError('Unknown option: $value'),
    };
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => screen),
    );
  }

  void _nameOnHover(bool hovering) {
    setState(() => _hovered = hovering);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          bottom: 0,
          right: 0,
          child: IgnorePointer(
            child: Image.asset(
              'images/author.png',
              fit: BoxFit.fitHeight,
              alignment: Alignment.centerRight,
            ),
          ),
        ),
        Column(
          children: [
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top: 4.0, bottom: 4.0, left: 128.0, right: 4.0),
                        child: Image.asset(
                          'images/main-menu-logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 32.0),
                    child: Text(
                      "DEVELOPED BY",
                      style: TextStyle(
                        color: Color(0xFF8C8C8C),
                        fontFamily: "ScienceGothic",
                        fontSize: 24.0,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.5,
                        height: 1.2,
                      ),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: 0.2,
                    child: Container(
                      height: 2.0,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF8C8C8C), Color(0x008C8C8C)],
                        ),
                      ),
                    ),
                  ),
                  AnimatedScale(
                    scale: _hovered ? 1.05 : 1.0,
                    duration: Duration(milliseconds: 150),
                    curve: Curves.easeOut,
                    child: Padding(
                      padding: EdgeInsets.only(left: 32.0),
                      child: InkWell(
                        onHover: _nameOnHover,
                        hoverColor: Colors.transparent,
                        onTap: () => launchUrl(
                          Uri.parse("https://www.ciarabarry.ie")
                        ),
                        child: Text(
                          "ZEKROFIRE",
                          style: TextStyle(
                            color: Color(0xFF8C8C8C),
                            fontFamily: "ScienceGothic",
                            fontSize: 32.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(bottom: 64.0),
                child: Column(
                  spacing: 32.0,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    for (final value in widget.buttonOptions)
                      MenuOptionButton(
                        onPressed: () => _openPage(value),
                        text: value,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}