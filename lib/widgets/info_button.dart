import 'dart:math' as math;
import 'package:flutter/material.dart';

class CustomInfoButton extends StatelessWidget {
  const CustomInfoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: EdgeInsets.only(right: 24.0, top: 16.0),
          child: Transform.rotate(
            angle: math.pi / 4,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                border: const Border(
                  right: BorderSide(color: Color(0xFFE53E01), width: 2.0),
                  bottom: BorderSide(color: Color(0xFFE53E01), width: 2.0),
                ),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFE53E01), Color(0xFFFD8305)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: const Color(0xFFE53E01), // dark navy, like 0xFF491225 is for red
                    offset: Offset.fromDirection(6.0, 3.0),
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ).copyWith(
                  overlayColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.pressed)) {
                      return Colors.white.withValues(alpha: 0.3);
                    }
                    if (states.contains(WidgetState.hovered)) {
                      return Colors.white.withValues(alpha: 0.2);
                    }
                    return null;
                  }),
                ),
                child: Transform.rotate(
                  angle: -math.pi / 4,
                  child: Text(
                    'i',
                    style: TextStyle(
                      color: Color(0xFFFDFFFD),
                      fontSize: 36,
                      fontFamily: 'TitanOne',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
