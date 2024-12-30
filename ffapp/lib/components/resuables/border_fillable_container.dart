import 'package:flutter/material.dart';

class BorderFillableContainer extends StatelessWidget {
  final Widget child;
  final double borderWidth;
  final double max;
  final double current;
  final Color borderColor;
  final Color fillColor;
  final EdgeInsets padding;

  const BorderFillableContainer(
      {super.key,
      required this.child,
      required this.borderWidth,
      required this.borderColor,
      this.fillColor = const Color.fromRGBO(68, 68, 68, 1),
      this.padding = const EdgeInsets.all(10),
      this.max = 4.0,
      this.current = 2.0,});

  @override
  Widget build(BuildContext context) {
    final double fullStop = current / max;
    // final bool full = current >= max;
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        gradient: SweepGradient(
          colors: const [
            Color.fromRGBO(34, 90, 76, 1),
            Color.fromRGBO(34, 90, 76, 1),
            Color.fromRGBO(0, 164, 123, 0),
          ],
          stops: [0, fullStop - 0.01, fullStop],
        ),
        borderRadius: const BorderRadius.all(Radius.circular(200)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(padding: padding, child: child),
        ],
      ),
    );
  }
}
