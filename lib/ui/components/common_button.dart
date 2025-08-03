import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final String label;
  final TextStyle? textStyle;
  final ButtonStyle? style;
  final Function? onPressed;

  const CommonButton({super.key, required this.label, this.textStyle, this.style, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed as void Function()?,
      style: style ?? ButtonStyle(
        backgroundColor: onPressed != null ?  WidgetStateProperty.all<Color>(Theme.of(context).colorScheme.onSecondary) : WidgetStateProperty.all<Color>(Theme.of(context).colorScheme.onTertiaryFixedVariant),
        padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(vertical: 12, horizontal: 10)),
      ),
      child: Text(
        label,
        style: textStyle ?? TextStyle(
          fontFamily: "Klavika",
          fontWeight: FontWeight.bold,
          fontSize: 28,
          color: Theme.of(context).colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }
}
