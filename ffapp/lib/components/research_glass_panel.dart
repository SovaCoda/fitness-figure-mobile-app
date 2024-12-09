import 'package:flutter/material.dart';

class ResearchGlassPanel extends StatelessWidget {
  final Widget child;

  const ResearchGlassPanel({required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(853, 495),
      painter: SvgPainter(),
      child: child,
    );
  }
}

// easier for me to just paint it
class SvgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // draw the gradient rectangle
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    const gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF1C6DBD), Color(0xFF00A47B)],
      stops: [0.0, 0.846666],
    );
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..color = Colors.white.withOpacity(0.29);

    canvas.drawRect(rect, paint);

    // draw the overlay rectangle
    final overlayPaint = Paint()..color = Color(0xFF3385A2);
    final overlayRect = Rect.fromLTRB(0, 4, size.width, -4);

    // apply mask
    canvas.saveLayer(rect, Paint());
    canvas.clipRect(rect);

    canvas.drawRect(overlayRect, overlayPaint);

    canvas.restore();
  }

  // it's a static image so no repaint
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
