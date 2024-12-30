import 'package:flutter/material.dart';
import 'dart:math';

class WorkoutProgressBar extends StatefulWidget {
  final String? text;
  final IconData? icon;
  final double progress;
  final bool disabled;
  final VoidCallback? onPressed;
  final double height;
  final double width;
  final double iconSize;
  final bool showText;

  const WorkoutProgressBar({
    super.key,
    this.text,
    this.icon,
    required this.progress,
    this.disabled = false,
    this.onPressed,
    this.height = 39.09,
    this.width = 176.31,
    this.iconSize = 20,
    this.showText = true,
  });

  @override
  State<WorkoutProgressBar> createState() => _WorkoutProgressBarState();
}

class _WorkoutProgressBarState extends State<WorkoutProgressBar>
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
          // Outer border container
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color.fromRGBO(16, 117, 165, 1),
                width: 1.85,
              ),
            ),
          ),
          // Base background
          Padding(
            padding: const EdgeInsets.all(1.85),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: const Color.fromRGBO(0, 73, 90, 1),
              ),
            ),
          ),
          // Progress with flowing animation
          Padding(
            padding: const EdgeInsets.all(1.85),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Row(
                children: [
                  Expanded(
                    flex: (widget.progress.clamp(0.0, 1.0) * 100).round(),
                    child: ClipRect(
                      child: Stack(
                        children: [
                          // Base gradient
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromRGBO(0, 91, 123, 1),
                                  Color.fromRGBO(0, 167, 225, 1),
                                  Color.fromRGBO(64, 178, 250, 1),
                                  Color.fromRGBO(0, 167, 225, 1),
                                  Color.fromRGBO(0, 91, 123, 1),
                                ],
                                stops: [0, 0.2, 0.4, 0.6, 1],
                              ),
                            ),
                          ),
                          // Inner shadow and highlight effects
                          Container(
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(255, 255, 255, 0.11),
                                  blurRadius: 3,
                                  spreadRadius: 1,
                                  blurStyle: BlurStyle.inner,
                                ),
                                BoxShadow(
                                  color: Color.fromRGBO(255, 255, 255, 0.11),
                                  blurRadius: 0,
                                  spreadRadius: 2,
                                  blurStyle: BlurStyle.inner,
                                ),
                              ],
                              backgroundBlendMode: BlendMode.plus,
                              gradient: RadialGradient(
                                colors: [
                                  Color.fromRGBO(119, 196, 255, 0.22),
                                  Color.fromRGBO(5, 45, 70, 0.22),
                                ],
                                stops: [0, 1],
                              ),
                            ),
                          ),
                          // Progress edge highlight
                          Positioned(
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: Container(
                              width: 1.85,
                              color: const Color.fromRGBO(51, 157, 195, 1),
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
                  ),
                  Expanded(
                    flex: 100 - (widget.progress.clamp(0.0, 1.0) * 100).round(),
                    child: Container(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}