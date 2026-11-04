import 'package:flutter/material.dart';
import 'package:khdle/widgets/custom/menu_option_button.dart';
import 'guess_character.dart';
import 'guess_enemy.dart';
import 'guess_keyblade.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key, required this.buttonOptions});

  final List<String> buttonOptions;

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

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

  @override
  Widget build(BuildContext context) {
    return Column(
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
              Expanded(
                flex: 1,
                child: Center(
                  child: Image.asset('images/back-arrow.png', width: 200, height: 200),
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
    );
  }
}