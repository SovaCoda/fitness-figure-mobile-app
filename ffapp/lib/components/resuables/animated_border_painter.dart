import 'dart:math';
import 'package:flutter/material.dart';

// Custom painter for the animated border
class AnimatedBorderPainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;

  AnimatedBorderPainter({required this.animation, required this.color})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..shader = SweepGradient(
        colors: [
          color.withOpacity(0.1),
          Colors.black,
          color,
        ],
        stops: const [0.0, 0.3, 1.0],
        // Rotate the gradient based on the animation value
        // Subtract pi/2 to start the gradient at the top
        transform: GradientRotation(2 * pi * animation.value - pi / 2),
      ).createShader(rect);

    final path = Path()
      ..addArc(
        rect,
        -pi / 2 + (2 * pi * animation.value),
        pi / 2,
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(AnimatedBorderPainter oldDelegate) => true;
}

// Animated container widget
class AnimatedBorderContainer extends StatefulWidget {
  final Widget child;
  final Color borderColor;

  const AnimatedBorderContainer({
    super.key,
    required this.child,
    required this.borderColor,
  });

  @override
  State<AnimatedBorderContainer> createState() =>
      _AnimatedBorderContainerState();
}

class _AnimatedBorderContainerState extends State<AnimatedBorderContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: AnimatedBorderPainter(
        animation: _controller,
        color: widget.borderColor,
      ),
      child: widget.child,
    );
  }
}
