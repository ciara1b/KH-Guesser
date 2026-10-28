import 'package:flutter/material.dart';

class MenuOptionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final double? borderRadius;
  final TextStyle? textStyle;

  const MenuOptionButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color,
    this.borderRadius,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: SizedBox(
          height: 100,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: color ?? Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            ),
            onPressed: onPressed,
            child: Text(
              text,
              style: TextStyle(
                color: Colors.black,
              )
            ),
          ),
        ),
      ),
  );
  }
}