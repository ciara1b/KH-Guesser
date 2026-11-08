import 'dart:collection';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:khdle/models/category_info.dart';

const double tileSize = 128;
const double tilePadding = 8;
const double tileSlot = tileSize + tilePadding * 2;

class Tile extends StatelessWidget {
  const Tile(this.value, this.hitType, this.clue, {super.key});

  final dynamic value;
  final HitType hitType;
  final dynamic clue;

  String _display(dynamic value) {
    if (value == null) return '';
    if (value is List) return value.join(', ');
    if (value == true) return 'Yes';
    if (value == false) return 'No';
    return value.toString();
  }

  static List<Shadow> outlinedText({double strokeWidth = 1, Color strokeColor = Colors.black, int precision = 5}) {
    Set<Shadow> result = HashSet();
    for (int x = 1; x < strokeWidth + precision; x++) {
      for(int y = 1; y < strokeWidth + precision; y++) {
        double offsetX = x.toDouble();
        double offsetY = y.toDouble();
        result.add(Shadow(offset: Offset(-strokeWidth / offsetX, -strokeWidth / offsetY), color: strokeColor));
        result.add(Shadow(offset: Offset(-strokeWidth / offsetX, strokeWidth / offsetY), color: strokeColor));
        result.add(Shadow(offset: Offset(strokeWidth / offsetX, -strokeWidth / offsetY), color: strokeColor));
        result.add(Shadow(offset: Offset(strokeWidth / offsetX, strokeWidth / offsetY), color: strokeColor));
      }
    }
    return result.toList();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.bounceIn,
      width: tileSize,
      height: tileSize,
      decoration: BoxDecoration(
        image: value is int && hitType != HitType.hit && hitType != HitType.none ? (clue != null && clue ? 
          DecorationImage(
            image: NetworkImage('assets/images/up-arrow.png'),
            fit: BoxFit.cover,
            opacity: 0.2
          ) : 
          DecorationImage(
            image: NetworkImage('assets/images/down-arrow.png'),
            fit: BoxFit.cover,
            opacity: 0.2
          )
        ) : null,
        border: Border.all(
          color: Color.fromARGB(255, 94, 93, 93),
          width: 3.0,
        ),
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        color: switch (hitType) {
          HitType.hit => Color(0xFF34A314),
          HitType.partial => Color(0xFFffdb5b),
          HitType.miss => Color(0xFF272727),
          _ => Colors.red,
        },
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(tilePadding),
          child: value is String && value.startsWith('assets/images/') ? 
            Image.asset(
              value,
              width: tileSize - tilePadding,
            ) : (value is List ? 
              Tooltip(
                message: _display(value),
                constraints: BoxConstraints(maxWidth: 256),
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
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Center(
                      child: Text(
                        _display(value),
                        textAlign: TextAlign.center,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: value is int ? 'KH-Numbers' : 'PRGothIWA',
                          fontWeight: FontWeight(900),
                          fontSize: value is int ? 12 : 16,
                          color: Color(0xFFFDFFFD),
                          shadows: outlinedText(),
                        ),
                      ),
                    ),
                  ),
                ),
              ) : Text(
                _display(value),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: value is int ? 'KH-Numbers' : 'PRGothIWA',
                  fontWeight: FontWeight(900),
                  fontSize: value is int ? 12 : 16,
                  color: Color(0xFFFDFFFD),
                  shadows: outlinedText(),
                ),
              )
            ),
        ),
      ),
    );
  }
}


class FlipTile extends StatefulWidget {
  const FlipTile({
    super.key,
    required this.child,
    required this.delay,
    this.animate = true,
  });

  final Widget child;
  final Duration delay;
  final bool animate;

  @override
  State<FlipTile> createState() => _FlipTileState();
}

class _FlipTileState extends State<FlipTile> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _flip;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _flip = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);

    if (widget.animate) {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    } else {
      _controller.value = 1;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _flip,
      child: widget.child,
      builder: (context, child) {
        final angle = (1 - _flip.value) * (math.pi / 2);

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()..setEntry(3, 2, 0.002)..rotateY(angle),
          child: child,
        );
      },
    );
  }
}