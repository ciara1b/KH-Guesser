import 'package:flutter/material.dart';
import 'package:khdle/widgets/assets.dart';

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
            border: Border(
              bottom: BorderSide(color: AppColours.oceanBlue, width: 2.0),
              right: BorderSide(color: AppColours.oceanBlue, width: 2.0),
            ),
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(20.0)),
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomCenter,
              colors: [AppColours.oceanBlue, AppColours.seaBlue],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColours.black.withValues(alpha: 0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
              BoxShadow(
                color: AppColours.oceanBlue,
                offset: Offset.fromDirection(2.0, 3.0),
                spreadRadius: 1,
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style:
                ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20.0),
                    ),
                  ),
                ).copyWith(
                  overlayColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.pressed)) {
                      return AppColours.white.withValues(alpha: 0.3);
                    }
                    if (states.contains(WidgetState.hovered)) {
                      return AppColours.white.withValues(alpha: 0.2);
                    }
                    return null;
                  }),
                ),
            child: Center(
              child: Semantics(
                label: "Curved arrow pointing left.",
                child: Image.asset('assets/images/back-arrow.png'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
