import 'package:flutter/material.dart';

class GradientedContainer extends StatelessWidget {
  final Widget child;
  final double radius;
  final bool doWeBinkTheBorder;
  final Color borderColor;
  const GradientedContainer(
      {super.key,
      required this.child,
      this.borderColor = const Color.fromRGBO(68, 68, 68, 1),
      this.doWeBinkTheBorder = true,
      this.radius = 3.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: borderColor,
          width: 4,
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
