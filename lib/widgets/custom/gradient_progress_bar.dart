import 'package:flutter/material.dart';

class GradientProgressBar extends StatelessWidget {
  final int percent;
  final LinearGradient gradient;
  final Color backgroundColor;

  const GradientProgressBar({
    required this.percent,
    required this.gradient,
    required this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: percent,
          fit: FlexFit.tight,
          child: Container(
            decoration: BoxDecoration(
              gradient: gradient,
              border: Border(
                left: BorderSide(color: Colors.black, width: 4.0),
                bottom: BorderSide(color: Colors.black, width: 4.0),
                top: BorderSide(color: Colors.black, width: 4.0),
              ),
            ),
            child: SizedBox(height: 40.0),
          ),
        ),
        Flexible(
          fit: FlexFit.tight,
          flex: 100 - percent,
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border(
                right: BorderSide(color: Colors.black, width: 4.0),
                bottom: BorderSide(color: Colors.black, width: 4.0),
                top: BorderSide(color: Colors.black, width: 4.0),
              ),
            ),
            child: SizedBox(height: 40.0),
          ),
        ),
      ],
    );
  }
}
