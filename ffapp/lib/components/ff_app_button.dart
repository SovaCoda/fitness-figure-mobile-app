import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FFAppButton extends StatefulWidget {
  final double? size;
  final double? height;
  final String text;
  final Color? color;
  final double fontSize;
  final double iconSize;
  final VoidCallback? onPressed;
  final bool isShiny; // do this now, optimize later
  final bool isBack;
  final bool isDelete;
  final bool isStore;
  final bool isSignOut;
  final bool isNoThanks;
  final IconData? icon;
  final double iconPadding;
  const FFAppButton({
    super.key,
    required this.text,
    this.size,
    this.height,
    this.color,
    this.fontSize = 30,
    this.iconSize = 30,
    this.onPressed,
    this.isShiny = false,
    this.isBack = false,
    this.isDelete = false,
    this.isStore = false,
    this.isSignOut = false,
    this.isNoThanks = false,
    this.icon,
    this.iconPadding = 50,
  });

  @override
  FFAppButtonState createState() => FFAppButtonState();
}

class FFAppButtonState extends State<FFAppButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: SizedBox(
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
                            : widget.isNoThanks ? "lib/assets/art/button_grey.png" : "lib/assets/art/button_base.png"
                            ,
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
            LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    // Centered Text
                    Center(
                      child: Padding(
                        padding: widget.icon != null ||
                                widget.isBack ||
                                widget.isDelete ||
                                widget.isStore
                            ? const EdgeInsets.only(left: 20)
                            : EdgeInsets.zero,
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
                                      ..color = const Color(0xFF1C6E6A),
                                  ),
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
                    ),
                    if (widget.isDelete)
                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.1,
                        top: constraints.maxHeight / 2 -
                            MediaQuery.of(context).size.width *
                                0.09167938931297709923664122137405 /
                                2,
                        child: SvgPicture.asset(
                          "lib/assets/art/trashcan.svg",
                          width: MediaQuery.of(context).size.width *
                              0.09167938931297709923664122137405,
                          height: MediaQuery.of(context).size.width *
                              0.09167938931297709923664122137405,
                        ),
                      ),

                    if (widget.isStore)
                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.1,
                        top: MediaQuery.of(context).size.height * 0.02,
                        child: SvgPicture.asset(
                          "lib/assets/art/store.svg",
                          width: MediaQuery.of(context).size.width *
                              0.11959287531806615776081424936387,
                          height: MediaQuery.of(context).size.height *
                              0.0434272300469483568075117370892,
                        ),
                      ),
                    if (widget.isSignOut)
                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.11,
                        top: constraints.maxHeight / 2 -
                            MediaQuery.of(context).size.width *
                              0.07167938931297709923664122137405 /
                                2,
                        child: SvgPicture.asset(
                          "lib/assets/icons/sign_out.svg",
                          width: MediaQuery.of(context).size.width *
                              0.07167938931297709923664122137405,
                          height: MediaQuery.of(context).size.width *
                              0.07167938931297709923664122137405,
                        ),
                      ),
                    // Left-aligned Icon with padding
                    if (widget.icon != null)
                      Positioned(
                        left: widget.iconPadding, // Increased padding from left
                        top: constraints.maxHeight / 2 - widget.iconSize / 2,
                        child: Stack(
                          children: [
                            Icon(
                              widget.icon,
                              size:
                                  widget.iconSize + 2, // 2 px padding on border
                              color: const Color(0xFFA5BEB7),
                            ),
                            Icon(
                              widget.icon,
                              size: widget.iconSize,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
