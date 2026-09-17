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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            for (var (index, value) in widget.buttonOptions.indexed)
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: index == widget.buttonOptions.length - 1
                        ? EdgeInsets.zero
                        : EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
                    child: MouseRegion(
                      onEnter: (_) => setState(() => _isHovering[index] = true),
                      onExit: (_) => setState(() => _isHovering[index] = false),
                      cursor: SystemMouseCursors.click,
                      child: AnimatedScale(
                        scale: _isHovering[index] ? 1.05 : 1.0,
                        duration: const Duration(milliseconds: 150),
                        child: Expanded(
                          flex: 1,
                          child: Container(
                            width: 480.0,
                            height: 100.0,
                            alignment: AlignmentGeometry.center,
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(25),
                              shape: BoxShape.rectangle,
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size.fromHeight(116),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                              ),
                              onPressed: () {
                                dynamic screen;
                                switch (value) {
                                  case 'Character':
                                    screen = const GuessCharacterPage();
                                    break;
                                  case 'Keyblade':
                                    screen = const GuessKeybladePage();
                                    break;
                                  case 'Enemy':
                                    screen = const GuessEnemyPage();
                                    break;
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (context) => screen
                                  ),
                                );
                              },
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
          ],
        ),
      ],
    );
  }
}