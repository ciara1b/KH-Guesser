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
  late List<bool> _isHovering;

  @override
  void initState() {
    super.initState();
    _isHovering = List.filled(widget.buttonOptions.length, false);
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
    return Center(
        child: GridView.count(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          primary: false,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          mainAxisExtent: WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.height / 2.5,
          crossAxisCount: 2,
          children: <Widget>[
            Image.asset('images/back-arrow.png',),
            Image.asset('images/main-menu-logo.png'),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [for (var (_, value) in widget.buttonOptions.indexed)
                MenuOptionButton(
                  onPressed: () => _openPage(value),
                  text: value,
                ),
              ],
            ),
            Text('Test footer.')
          ],
        ),
    );
  }
}