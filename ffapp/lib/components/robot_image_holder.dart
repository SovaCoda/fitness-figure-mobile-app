import "package:flutter/material.dart";

class RobotImageHolder extends StatelessWidget {
  final String url;
  final double height;
  final double width;

  const RobotImageHolder({super.key, required this.url, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            center: Alignment(0, 0),
            colors: [
              Theme.of(context).colorScheme.onBackground.withOpacity(1),
              Theme.of(context).colorScheme.onBackground.withOpacity(0),
            ],
            radius: .48,
          ),
        ),
        child: Center(
          child: Image.asset(
            "lib/assets/$url.gif",
            height: height <= 400 ?  height*(5/8) : height*(3/4),
            width: width <= 400 ? width*(5/8) : width*(3/4),
          ),
        ),
      ), 
    ]
    );
  }
}