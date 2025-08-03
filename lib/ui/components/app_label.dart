import 'package:flutter/material.dart';

class AppLabel extends StatelessWidget {
  final String? label;
  final double? fontSize;
  final Color? color;
  const AppLabel({super.key, this.label, this.fontSize, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      label ?? "ChatMe",
      maxLines: 1,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: "Klavika",
        fontWeight: FontWeight.w700,
        color: color ?? Theme.of(context).colorScheme.onPrimaryContainer,
        fontSize: fontSize ?? 48,
      ),
    );
  }
}
