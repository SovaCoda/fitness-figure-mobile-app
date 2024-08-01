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
      width: 370,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: backgroundColor,
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          shape: WidgetStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
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
                  Text(text,
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge!
                          .copyWith(color: textColor)),
                ],
              )
            : Text(text,
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(color: textColor)),
      ),
    );
  }
}
