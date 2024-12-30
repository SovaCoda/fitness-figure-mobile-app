import "package:flutter/material.dart";

class RobotLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF59FF00)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    Offset startPoint = Offset(size.width * 0.6, size.height * 0.45);
    Offset endPoint = Offset(size.width * 0.90, size.height * 0.45);

    // Draw three lines
    for (int i = 0; i < 3; i++) {
      final double yOffset = (i - 1) * 40;
      canvas.drawLine(
        startPoint.translate(0, yOffset),
        endPoint.translate(0, yOffset),
        paint,
      );
    }
    startPoint = Offset(size.width * 0.896, size.height * 0.45);
    endPoint = Offset(size.width * 1.02, size.height * 0.40);

    canvas.drawLine(
      startPoint.translate(0, 40),
      endPoint.translate(0, 40),
      paint,
    );
    startPoint = Offset(size.width * 0.896, size.height * 0.45);
    endPoint = Offset(size.width * 1.02, size.height * 0.45);
    canvas.drawLine(
      startPoint.translate(0, 0),
      endPoint.translate(0, 0),
      paint,
    );

    startPoint = Offset(size.width * 0.899, size.height * 0.45);
    endPoint = Offset(size.width * 1.055, size.height * 0.50);
    canvas.drawLine(
      startPoint.translate(0, -40),
      endPoint.translate(0, -40),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
