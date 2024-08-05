import 'package:flutter/material.dart';

class FfButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color textColor;
  final Color backgroundColor;
  final Color disabledColor;
  final VoidCallback onPressed;
  final double height;
  final double width;
  final double iconSize;
  final bool disabled;
  final TextStyle textStyle;

  const FfButton({
    super.key,
    required this.text,
    this.icon,
    this.textStyle = const TextStyle(),
    required this.textColor,
    required this.backgroundColor,
    required this.onPressed,
    this.disabledColor = Colors.grey,
    this.disabled = false,
    this.width = double.infinity,
    this.height = 30,
    this.iconSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: disabled ? disabledColor : backgroundColor,
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(horizontal: 0), // remove default padding
          ),
          shape: WidgetStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
          ),
          backgroundColor: WidgetStateProperty.all<Color>(
              disabled ? disabledColor : backgroundColor),
        ),
        onPressed: disabled ? null : onPressed,
        child: icon != null
            ? Stack(
                children: [
                  Positioned(
                    left: 20,
                    top: height / 2 - iconSize / 2,
                    child: Icon(icon, color: textColor, size: iconSize),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(text,
                            style: textStyle.copyWith(color: textColor)),
                      ),
                    ],
                  ),
                ],
              )
            : Text(text, style: textStyle.copyWith(color: textColor)),
      ),
    );
  }
}
