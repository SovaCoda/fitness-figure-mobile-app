import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FFAppButton extends StatefulWidget {
  final double? size;
  final double? height;
  final String text;
  final Color? color;
  final double fontSize;
  final VoidCallback? onPressed;
  final bool isShiny;
  final bool isBack;
  final bool isDelete;
  final IconData? icon; // New optional icon parameter

  const FFAppButton({
    super.key,
    required this.text,
    this.size,
    this.height,
    this.color,
    this.fontSize = 30,
    this.onPressed,
    this.isShiny = false,
    this.isBack = false,
    this.isDelete = false,
    this.icon, // Add to constructor
  });

  @override
  _FFAppButtonState createState() => _FFAppButtonState();
}

class _FFAppButtonState extends State<FFAppButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: Container(
        width: widget.size,
        height: widget.height ?? widget.size,
        child: Stack(
          fit: StackFit.expand, // Ensure stack fills the container
          alignment: Alignment.center,
          children: [
            // SVG Button Base with Animated Opacity
            AnimatedOpacity(
              duration: const Duration(milliseconds: 50),
              opacity: _isPressed ? 0.7 : 1.0,
              child: Image.asset(
                widget.isShiny
                    ? "lib/assets/art/button_base_special.png"
                    : widget.isBack
                        ? "lib/assets/art/back_button.png"
                        : widget.isDelete
                            ? "lib/assets/art/delete_button.png"
                            : "lib/assets/art/button_base.png",
                width: widget.size,
                height: widget.height ?? widget.size,
                fit: BoxFit.fill,
                colorBlendMode:
                    _isPressed ? BlendMode.srcATop : BlendMode.darken,
                color:
                    _isPressed ? Colors.black.withOpacity(0.3) : widget.color,
              ),
            ),

            // Content Stack with LayoutBuilder
            LayoutBuilder(builder: (context, constraints) {
              return Stack(
                children: [
                  // Centered Text
                  Center(
                    child: Stack(
                      children: [
                        Text(
                          widget.text,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  fontSize: widget.fontSize,
                                  fontWeight: FontWeight.w400,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 2
                                    ..color = const Color(0xFFA5BEB7)),
                        ),
                        Text(
                          widget.text,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                color: Colors.white,
                                fontSize: widget.fontSize,
                                fontWeight: FontWeight.w400,
                              ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.isDelete)
                    Positioned(
                      left: MediaQuery.of(context).size.width * 0.08,
                      top: MediaQuery.of(context).size.height * 0.02,
                      child: SvgPicture.asset("lib/assets/art/trashcan.svg",
                          width: 36.03, height: 36.03),
                    ),

                  // Left-aligned Icon with padding
                  if (widget.icon != null)
                    Positioned(
                      left: MediaQuery.of(context).size.width *
                          0.1, // Increased padding from left
                      top: constraints.maxHeight / 2 - widget.fontSize / 2,
                      child: Stack(
                        children: [
                          Icon(
                            widget.icon,
                            size: widget.fontSize + 2, // 2 px padding on border
                            color: const Color(0xFFA5BEB7),
                          ),
                          Icon(
                            widget.icon,
                            size: widget.fontSize,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
