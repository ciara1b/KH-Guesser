import 'package:flutter/material.dart';

class MenuOptionButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final TextStyle? textStyle;

  const MenuOptionButton({
    required this.text,
    required this.onPressed,
    this.textStyle,
    super.key,
  });

  @override
  State<MenuOptionButton> createState() => _MenuOptionButtonState();
}

class _MenuOptionButtonState extends State<MenuOptionButton>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;

  late final AnimationController _pulseController;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    _pulse = CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onHover(bool hovering) {
    setState(() => _hovered = hovering);
    if (hovering) {
      _pulseController.repeat(reverse: true);
    } else {
      _pulseController.stop();
      _pulseController.value = 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 64.0),
      child: AnimatedScale(
        scale: _hovered ? 1.05 : 1.0,
        duration: Duration(milliseconds: 150),
        curve: Curves.easeOut,
        alignment: Alignment.centerLeft,
        child: Container(
          width: double.infinity,
          foregroundDecoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black, width: 3))
          ),
          child: InkWell(
            onTap: widget.onPressed,
            onHover: _onHover,
            hoverColor: Colors.transparent,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: 16.0,
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 0),
                  decoration: BoxDecoration(
                    color: _hovered ? Color(0xFFFF8400) : Colors.black,
                    border: Border.all(color: Colors.black, width: 16.0),
                  ),
                  width: 64.0,
                  height: 64.0,
                  child: Stack(
                    fit: StackFit.expand,
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Center(
                        child: AnimatedBuilder(
                          animation: _pulse,
                          builder: (context, child) {
                            final scale = _hovered
                                ? 0.5 +
                                    (2.0 - 0.5) *
                                        _pulse.value
                                : 0.0;
                            return Transform.scale(scale: scale, child: child);
                          },
                          child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Color.fromRGBO(255, 255, 255, 1.0),
                                Color.fromRGBO(255, 255, 75, 0.75),
                                Color.fromRGBO(255, 255, 75, 0.0),
                              ],
                              stops: [0.0, 0.55, 1.0],
                            ),
                          ),
                        ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 64.0,
                    decoration: BoxDecoration(
                      gradient: _hovered ? LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: [0.0, 0.3, 0.6, 1.0],
                        colors: [Color(0xFFd0bff9).withAlpha(0), Color(0xFFd0bff9).withAlpha(50), Color(0xFFd0bff9).withAlpha(255), Color(0xFFd095f9)],
                      ) : null,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.text,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 32.0,
                          fontFamily: 'KH-Numbers',
                        ),
                      ),
                    ),
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