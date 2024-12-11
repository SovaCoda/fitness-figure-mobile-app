import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class ConfettiSuccessWidget extends StatefulWidget {
  final Widget child;

  const ConfettiSuccessWidget({Key? key, required this.child})
      : super(key: key);

  @override
  _ConfettiSuccessWidgetState createState() => _ConfettiSuccessWidgetState();
}

class _ConfettiSuccessWidgetState extends State<ConfettiSuccessWidget> {
  late ConfettiController _controllerCenter;

  @override
  void initState() {
    super.initState();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 3));

    // Trigger confetti animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controllerCenter.play();
    });
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Your existing child widget
        widget.child,

        // Centered confetti
        Positioned(
          top: MediaQuery.of(context).size.height *
              0.1, // Adjust position as needed
          child: ConfettiWidget(
            confettiController: _controllerCenter,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ],
            createParticlePath: (size) => Path()
              ..addOval(
                  Rect.fromCircle(center: Offset.zero, radius: size.width / 2)),
          ),
        ),
      ],
    );
  }
}
