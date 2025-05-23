
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';


// IMPORTANT NOTE: This code is currently not being used in the app in favor of a simpler less graphically intense version, code is saved for future reference

class HoleClipper extends CustomClipper<Path> {
  final Rect holeRect;

  HoleClipper(this.holeRect);

  @override
  Path getClip(Size size) {
    return Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height)) // Add the full rectangle
      ..addRect(holeRect) // Add the hole
      ..fillType = PathFillType.evenOdd; // This makes the inside of the oval the "hole"
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class Fitventures extends StatefulWidget {
  const Fitventures({super.key});
  @override
  FitventuresState createState() => FitventuresState();
}

class Location {
  final String name;
  final Rect rect;
  Location({required this.name, required this.rect});
}

final List<Location> locations = [
  Location(name: 'Janes House', rect: const Rect.fromLTWH(100, 100, 50, 50)),
  Location(name: 'Crothers Residence', rect: const Rect.fromLTWH(200, 200, 50, 50)),
  Location(name: 'Park', rect: const Rect.fromLTWH(300, 300, 50, 50)),
  Location(name: 'Gym', rect: const Rect.fromLTWH(200, 300, 50, 50)),
  Location(name: 'Coffee Shop', rect: const Rect.fromLTWH(100, 100, 50, 50)),
];

class FitventuresState extends State<Fitventures> with TickerProviderStateMixin {
  late Animation<double> figureAnimation;
  late AnimationController figureAnimationController;

  TransformationController mapTransformationController = TransformationController();
  late AnimationController zoomAnimator;
  late Animation<Matrix4> zoomAnimation;
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();

    // figure animations
    figureAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    figureAnimation = Tween<double>(begin: 200, end: 0).animate(figureAnimationController)
    ..addListener(() { 
      setState(() {
      });
    });
    figureAnimationController.forward();
    
    //Map zoom animations
    zoomAnimator = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }



  @override
  void dispose() {
    figureAnimationController.dispose();
    zoomAnimator.dispose();
    super.dispose();
  }

  void animateZoom(Matrix4 targetMatrix){
    zoomAnimation = Matrix4Tween(begin: mapTransformationController.value, end: targetMatrix)
    .animate(CurvedAnimation(parent: zoomAnimator, curve: Curves.easeInOut));

    zoomAnimator.addListener(() {
      mapTransformationController.value = zoomAnimation.value;
    });

    zoomAnimator.forward(from: 0.0);
  }
   
  void zoomToLocation(Location location, TransformationController controller, {double scale = 3}) {
    logger.i('Zooming to ${location.name}');
    final targetMatrix = Matrix4.identity()
      ..translate(-location.rect.center.dx * scale + (location.rect.size.width / 2) + 175, -location.rect.center.dy * scale + (location.rect.size.height / 2) + 175)
      ..scale(scale);
    
    animateZoom(targetMatrix);
  }

  void showFiguresMenu()
  {

  }

  void showMissionsMenu()
  {
    logger.i('Showing Missions');
    final holeRect = Rect.fromCenter(center: const Offset(200, 200), width: 100, height: 100);
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: ClipPath(
            clipper: HoleClipper(holeRect),
            child: Container(
              color: Theme.of(context).secondaryHeaderColor,
              
              height: 400,
              width: 400,
              child: Column(
                children: [
                  const Text('Missions'),
                  ElevatedButton(onPressed: () {Navigator.pop(context);}, child: const Text('Close')),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  // ignore: constant_identifier_names
  static const FIGURE_SIZE_OFFSET = 100.0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: GestureDetector(
            onTapUp: (TapUpDetails details)  {
              for (var location in locations) {
                if (location.rect.contains(details.localPosition)) {
                  logger.i('Tapped on ${location.name}');
                  zoomToLocation(location, mapTransformationController);
                }
              }
            },
            child: InteractiveViewer(
              constrained: true,
              panEnabled: true, // Enable panning
              scaleEnabled: true, // Enable zooming
              minScale: 0.5,
              maxScale: 4.0,
              transformationController: mapTransformationController,
              child: Stack(
                children: [
                  // Background
                  Container(
                    color: Colors.blue[50],
                    width: 400,
                    height: 400,
                  ),
                  // Loop through locations and draw them
                  for (var location in locations)
                    Positioned(
                      left: location.rect.left,
                      top: location.rect.top,
                      child: Container(
                        width: 50,
                        height: 50,
                        color: Colors.green,
                        child: Center(
                          child: Text(location.name),
                        ),
                      ),
                    ),
                  CustomPaint(
                    size: const Size(400, 400),
                    painter: TreasureMapPainter(),
                  ),
                          
                ],
              ),
            ),
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(child: ElevatedButton(onPressed: showFiguresMenu, child: const Text('___Figures___'),)),
            Center(child: ElevatedButton(onPressed: showMissionsMenu, child: const Text('___Missions___'))),
          ],
        ),
      ]
    );
  }
}

class TreasureMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.brown
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();


    double startX = 100;
    double startY = 100;
    int stride = 10;
    // Draw tick marks along the path
    for (int i = 0; i <= 250; i = i + stride) {
        path.moveTo(startX + i, startY + i);
        path.lineTo(startX + i + stride - 5, startY  + i + stride - 5);
    }
    canvas.drawPath(path, paint);
  }

  void drawTickMark(Canvas canvas, Offset position, Paint paint) {
    const tickLength = 10.0;
    final tickPath = Path();
    tickPath.moveTo(position.dx - tickLength / 2, position.dy - tickLength / 2);
    tickPath.lineTo(position.dx + tickLength / 2, position.dy + tickLength / 2);
    canvas.drawPath(tickPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}