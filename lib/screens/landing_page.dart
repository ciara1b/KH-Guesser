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
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.asset(
                    'images/main-menu-logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Image.asset('images/back-arrow.png', width: 200, height: 200),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: 250,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
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
              ),
              const Expanded(
                child: Center(child: Text('Test footer.')),
              ),
            ],
          ),
        ),
      ],
    );
  }
}