import "package:ffapp/components/expandable_core.dart";
import "package:flutter/material.dart";

class RobotImageHolder extends StatefulWidget {
  final String url;
  final double height;
  final double width;
  final bool? coreClickable;

  const RobotImageHolder(
      {Key? key,
      this.coreClickable,
      required this.url,
      required this.height,
      required this.width})
      : super(key: key);

  @override
  _RobotImageHolderState createState() => _RobotImageHolderState();
}

class _RobotImageHolderState extends State<RobotImageHolder> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              center: const Alignment(0, 0),
              colors: [
                Theme.of(context).colorScheme.onSurface.withOpacity(1),
                Theme.of(context).colorScheme.onSurface.withOpacity(0),
              ],
              radius: .48,
            ),
          ),
          child: OverflowBox(
            maxHeight: 1000,
            maxWidth: 1000,
            child: Center(
              child: Stack(
                children: [
                  Center(
                    child: Image.asset(
                      "lib/assets/${widget.url}.gif",
                      height: widget.height <= 400
                          ? widget.height * (5 / 8)
                          : widget.height * (3 / 4),
                      width: widget.width <= 400
                          ? widget.width * (5 / 8)
                          : widget.width * (3 / 4),
                    ),
                  ),
                  Center(
                    child: Opacity(
                      opacity: 0,
                      child: SizedBox(
                          height: 75,
                          width: 75,
                          child: OverflowBox(
                              maxHeight: 1000,
                              maxWidth: 1000,
                              child: ExpandableCore(isExpanded: true))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
