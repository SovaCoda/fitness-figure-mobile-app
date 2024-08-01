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
      this.current = 2.0});

  @override
  Widget build(BuildContext context) {
    bool full = current >= max;
    return Container(
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Stack(
        children: [
          Container(padding: padding, child: child),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: (current / max).clamp(0, 1),
              heightFactor: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border(
                    bottom: BorderSide(
                      color: borderColor,
                      width: borderWidth,
                    ),
                    top: BorderSide(
                      color: borderColor,
                      width: borderWidth,
                    ),
                    left: BorderSide(
                      color: borderColor,
                      width: borderWidth,
                    ),
                    right: full
                        ? BorderSide(
                            color: borderColor,
                            width: borderWidth,
                          )
                        : BorderSide.none,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(13),
                    bottomLeft: const Radius.circular(13),
                    topRight: full ? const Radius.circular(13) : Radius.zero,
                    bottomRight: full ? const Radius.circular(13) : Radius.zero,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
