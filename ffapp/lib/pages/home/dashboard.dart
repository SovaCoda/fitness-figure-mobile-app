import 'package:flutter/material.dart';



class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  @override
  Widget build(BuildContext context) {           

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200.0,
              height: 200.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.red,
                  width: 2.0,
                ),
              ),
              child: Image.asset(
                "lib/assets/icons/robot1_skin0_cropped.gif",
                height: 200.0,
                width: 200.0,
              ),
            ),
        ], 
        )
      ),
    ),
    );
  }
}

class Painter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    double radius = 100.0;
    canvas.translate(size.width/2, size.height/2); 
    Offset center = Offset(0.0, 0.0);
    // draw shadow first
    Path oval = Path()
        ..addOval(Rect.fromCircle(center: center, radius: radius+10));
    Paint shadowPaint = Paint() 
        ..color = Colors.black.withOpacity(0.3)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 50);
    canvas.drawPath(oval, shadowPaint);
    // draw circle
    Paint thumbPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, thumbPaint);
  }

  @override
  bool shouldRepaint(Painter oldDelegate) {
    return false;
  }
}