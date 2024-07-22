import 'package:flutter/material.dart';

class FfButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color textColor;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final double height;

  const FfButton({
    super.key,
    required this.text,
    this.icon,
    required this.textColor,
    required this.backgroundColor,
    required this.onPressed,
    this.height = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1),
      height: height,
      decoration: BoxDecoration(
        border: Border.all(
            color: backgroundColor.withAlpha(127),
            width: 2,
            strokeAlign: BorderSide.strokeAlignInside),
        borderRadius: BorderRadius.circular(4),
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          shape: WidgetStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          backgroundColor: WidgetStateProperty.all<Color>(backgroundColor),
        ),
        onPressed: onPressed,
        child: icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: textColor),
                  const SizedBox(width: 4),
                  Text(text, style: TextStyle(color: textColor)),
                ],
              )
            : Text(text, style: TextStyle(color: textColor)),
      ),
    );
  }
}
