import 'package:flutter/material.dart';

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
                        child: Container(
                          alignment: AlignmentGeometry.center,
                          width: 480.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(25),
                            shape: BoxShape.rectangle,
                          ),
                          child: Text(
                            value,
                            style: const TextStyle(fontSize: 24),
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