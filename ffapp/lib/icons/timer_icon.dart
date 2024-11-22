import 'package:flutter/material.dart';

class TimerIcon extends StatelessWidget {
  final double size;
  final Color color;

  const TimerIcon({
    super.key,
    this.size = 24.0,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: color,
          width: size * 0.08, // Proportional border width
        ),
      ),
      child: Center(
        child: CustomPaint(
          size: Size(size * 0.6, size * 0.6), // Clock hands are 60% of container
          painter: ClockHandsPainter(color: color),
        ),
      ),
    );
  }
}

class ClockHandsPainter extends CustomPainter {
  final Color color;

  ClockHandsPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.width * 0.15
      ..strokeCap = StrokeCap.round;

    // Minute hand (pointing to 12 o'clock position)
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.5),
      Offset(size.width * 0.5, size.height * 0.1),
      paint,
    );
    // Hour hand (pointing to 4 o'clock position)
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.5),
      Offset(size.width * 0.5 + size.width * 0.25, size.height * 0.5 + size.height * 0.25),
      paint,
    );
  }
  // this is the one time I will be able to use this optimization
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}