import "package:flutter/material.dart";

class RobotImageHolder extends StatefulWidget {
  final String url;
  final double height;
  final double width;
  final bool? coreClickable;

  const RobotImageHolder(
      {super.key,
      this.coreClickable,
      required this.url,
      required this.height,
      required this.width,});

  @override
  RobotImageHolderState createState() => RobotImageHolderState();
}

class RobotImageHolderState extends State<RobotImageHolder> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: widget.width,
          height: widget.height,
          child: Center(
            child: Stack(
              children: [
                OverflowBox(
                  maxHeight: double.infinity,
                  maxWidth: double.infinity,
                  child: Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      height: widget.height,
                      width: widget.width,
                      child: Image.asset("lib/assets/${widget.url}.gif",
                          scale: 0.8,
                          height: widget.height * 2,
                          width: widget.width * 2,),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
