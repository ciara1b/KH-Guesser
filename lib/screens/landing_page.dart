import 'package:flutter/material.dart';
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
              children: [for (var (index, value) in widget.buttonOptions.indexed)
                Padding(
                  padding: EdgeInsets.only(
                    bottom: index == widget.buttonOptions.length - 1 ? 0 : 16,
                  ),
                  child: MouseRegion(
                    onEnter: (_) => setState(() => _isHovering[index] = true),
                    onExit: (_) => setState(() => _isHovering[index] = false),
                    cursor: SystemMouseCursors.click,
                    child: AnimatedScale(
                      scale: _isHovering[index] ? 1.05 : 1.0,
                      duration: const Duration(milliseconds: 150),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 480),
                        child: SizedBox(
                          height: 100,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(100),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(),
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            onPressed: () => _openPage(value),
                            child: Text(
                              value,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Text('Test footer.')
          ],
        ),
    );
  }
}