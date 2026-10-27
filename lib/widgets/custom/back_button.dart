import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          width: 96,
          height: 64,
          decoration: BoxDecoration(
            border: const Border(
              bottom: BorderSide(color: Color(0xFF002077), width: 2.0),
              right: BorderSide(color: Color(0xFF002077), width: 2.0),
            ),
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(20.0),
            ),
            gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF002077), Color(0xFF0191CE)],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
              BoxShadow(
                color: const Color(0xFF002077),
                offset: Offset.fromDirection(2.0, 3.0),
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
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20.0),
                ),
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
            child: Center(
              child: Image.asset('images/back-arrow.png'),
            ),
          ),
        ),
      ),
    );
  }
}
