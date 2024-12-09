import 'package:flutter/material.dart';
import 'dart:math' show max;

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

class FfButtonProgressable extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color textColor;
  final Color backgroundColor;
  final Color disabledColor;
  final VoidCallback onPressed;
  final double height;
  final double width;
  final double iconSize;
  final double progress;
  final bool disabled;
  final TextStyle textStyle;

  const FfButtonProgressable({
    super.key,
    required this.text,
    this.icon,
    this.textStyle = const TextStyle(),
    required this.textColor,
    required this.backgroundColor,
    required this.onPressed,
    this.progress = 0,
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
          gradient: LinearGradient(colors: [
            progress == 1 ? backgroundColor : backgroundColor.withAlpha(155),
            progress == 1 ? backgroundColor : backgroundColor.withAlpha(155),
            disabledColor,
            disabledColor
          ], stops: [
            0,
            progress - (progress == 1 ? 0.0 : 0.05),
            progress,
            1
          ])),
      child: ElevatedButton(
        style: ButtonStyle(
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(horizontal: 0), // remove default padding
          ),
          shape: WidgetStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
          ),
          backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
        ),
        onPressed: disabled
            ? null
            : progress == 1
                ? onPressed
                : null,
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

class FlowingProgressBar extends StatefulWidget {
  final String text;
  final IconData? icon;
  final Color textColor;
  final VoidCallback onPressed;
  final double height;
  final double width;
  final double iconSize;
  final double progress;
  final bool disabled;
  final TextStyle textStyle;

  const FlowingProgressBar({
    Key? key,
    required this.text,
    this.icon,
    required this.textStyle,
    required this.textColor,
    required this.onPressed,
    required this.progress,
    this.disabled = false,
    this.width = 176.31,
    this.height = 39.09,
    this.iconSize = 20,
  }) : super(key: key);

  @override
  State<FlowingProgressBar> createState() => _FlowingProgressBarState();
}

class _FlowingProgressBarState extends State<FlowingProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _flowController;

  @override
  void initState() {
    super.initState();
    _flowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _flowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Stack(
        children: [
          // Base purple layer
          Positioned.fill(
            child: Container(
              decoration: ShapeDecoration(
                color: const Color(0xFF5F41B9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.39),
                ),
              ),
            ),
          ),
          // Dark overlay
          Positioned.fill(
            child: Container(
              decoration: ShapeDecoration(
                color: const Color(0xFF2A1D53),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1.06,
                    strokeAlign: BorderSide.strokeAlignOutside,
                    color: Color(0xFF733FBC),
                  ),
                  borderRadius: BorderRadius.circular(6.39),
                ),
              ),
            ),
          ),
          // Progress with flowing animation
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6.39),
              child: Row(
                children: [
                  Expanded(
                    flex: widget.progress <= 0
                        ? 1
                        : (widget.progress.clamp(0.0, 1.0) * 100).round(),
                    child: Stack(
                      children: [
                        // Base linear gradient
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFF5B3EB1),
                                Color(0xFF7F5EE2),
                                Color(0xFFA791EA),
                                Color(0xFF7F5EE2),
                                Color(0xFF5B3EB1),
                              ],
                              stops: [-0.0259, 0.2579, 0.4887, 0.7196, 1.0],
                            ),
                          ),
                        ),
                        // Radial gradient overlay
                        Container(
                          decoration: const BoxDecoration(
                            gradient: RadialGradient(
                              center: Alignment(0, 1),
                              radius: 0.7211,
                              colors: [
                                Color(0x38A587FF),
                                Color(0x382B1D54),
                              ],
                              stops: [0.0, 1.0],
                            ),
                          ),
                        ),
                        // Flowing animation
                        AnimatedBuilder(
                          animation: _flowController,
                          builder: (context, child) {
                            double availableWidth = max(1.0,
                                widget.width * widget.progress.clamp(0.0, 1.0));
                            return Transform.translate(
                              offset: Offset(
                                -availableWidth +
                                    (_flowController.value *
                                        availableWidth *
                                        2),
                                0,
                              ),
                              child: Container(
                                width: max(1.0, availableWidth * 0.3),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0),
                                      Colors.white.withOpacity(0.2),
                                      Colors.white.withOpacity(0),
                                    ],
                                    stops: const [0.0, 0.5, 1.0],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: widget.progress <= 0
                        ? 99
                        : (100 - (widget.progress.clamp(0.0, 1.0) * 100))
                            .round(),
                    child: Container(
                      color: const Color(0xFF1B2F6F),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Border overlay
          Positioned.fill(
            child: Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1.06,
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: Color(0xFFCDA9FF),
                  ),
                  borderRadius: BorderRadius.circular(6.39),
                ),
              ),
            ),
          ),
          // Button content with text and icon
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.disabled
                    ? null
                    : widget.progress == 1
                        ? widget.onPressed
                        : null,
                borderRadius: BorderRadius.circular(6.39),
                child: Center(
                  child: widget.icon != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(widget.icon,
                                color: widget.textColor, size: widget.iconSize),
                            const SizedBox(width: 8),
                            Text(widget.text,
                                style: widget.textStyle
                                    .copyWith(color: widget.textColor)),
                          ],
                        )
                      : Text(widget.text,
                          style: widget.textStyle
                              .copyWith(color: widget.textColor)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// flex: 100 - (progress * 100 == double.infinity ? 0 : progress * 100).toInt(),