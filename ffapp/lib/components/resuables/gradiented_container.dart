import 'package:flutter/material.dart';

class GradientedContainer extends StatelessWidget {
  final Widget child;
  final double radius;
  final double borderWidth;
  final double? height;
  final bool doWeBinkTheBorder;
  final Color borderColor;
  final EdgeInsets padding;
  final EdgeInsets margin;

  const GradientedContainer(
      {super.key,
      required this.child,
      this.height = null,
      this.borderColor = const Color.fromRGBO(68, 68, 68, 1),
      this.doWeBinkTheBorder = true,
      this.borderWidth = 4,
      this.padding = const EdgeInsets.all(0),
      this.margin = const EdgeInsets.all(0),
      this.radius = 3.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: borderColor,
          width: borderWidth,
          style: doWeBinkTheBorder ? BorderStyle.solid : BorderStyle.none,
        ),
        gradient: RadialGradient(
          center: Alignment.center,
          radius: radius,
          colors: [
            Theme.of(context).colorScheme.onPrimary,
            Theme.of(context).colorScheme.surface,
          ],
        ),
      ),
      child: child,
    );
  }
}
