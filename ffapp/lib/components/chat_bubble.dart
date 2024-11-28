import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:go_router/go_router.dart';

class BinaryGlowChatBubble extends StatefulWidget {
  final double width;
  final double height;
  final String message;
  final bool chatMore;

  const BinaryGlowChatBubble({
    Key? key,
    required this.width,
    required this.height,
    this.chatMore = false,
    this.message = "",
  }) : super(key: key);

  @override
  State<BinaryGlowChatBubble> createState() => _BinaryGlowChatBubbleState();
}

class _BinaryGlowChatBubbleState extends State<BinaryGlowChatBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<BinaryNumber> _binaryNumbers = [];
  final Random random = Random();
  static const int rowHeight = 25; // Height for each row of binary numbers

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Generate initial binary numbers
    _generateBinaryNumbers();
  }

  String _generateBinaryString() {
    return List.generate(16, (index) => random.nextInt(2).toString()).join();
  }

  void _generateBinaryNumbers() {
    // Calculate number of rows that can fit in the height
    int numberOfRows = (widget.height / rowHeight).floor(); // Leave space for the message
    
    // Generate one binary number for each row
    for (int i = 0; i < numberOfRows; i++) {
      _binaryNumbers.add(
        BinaryNumber(
          x: -random.nextDouble() * widget.width, // Start at different positions off-screen
          y: i * rowHeight + 5, // Add small padding
          value: _generateBinaryString(),
          speed: 0.5 + random.nextDouble() * 1, // Reduced speed range
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  return Container(
    width: widget.width,
    height: widget.height,
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 25,34,57),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.blue.withOpacity(0.5),
          spreadRadius: 5,
          blurRadius: 15,
          offset: const Offset(0, 0),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              // Update binary numbers position
              for (var binary in _binaryNumbers) {
                binary.x += binary.speed;
                if (binary.x > widget.width) {
                  binary.x = -200; // Start further off-screen
                  binary.value = _generateBinaryString(); // Generate new binary string
                }
              }

              return CustomPaint(
                painter: BinaryPainter(
                  binaryNumbers: _binaryNumbers,
                  glowColor: Color.fromARGB(255, 41, 61, 111)
                ),
              );
            },
          ),
          if (widget.message.isNotEmpty)
            Positioned(
              top: 10,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                  child: Column(
                    children: [
                      Text(
                        widget.message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Roboto',
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (widget.chatMore)
          Positioned(
            bottom: 10,
            right: 10,
            child: GestureDetector(
              onTap: () {
                GoRouter.of(context).go('/chat');
              },
              child: const Text(
              'CHAT MORE >>',
              style: const TextStyle(
                color: Color.fromARGB(255, 4, 174, 124),
                fontSize: 16,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ),
        ],
      ),
    ),
  );
}
    }

class BinaryNumber {
  double x;
  double y;
  String value;
  double speed;

  BinaryNumber({
    required this.x,
    required this.y,
    required this.value,
    required this.speed,
  });
}

class BinaryPainter extends CustomPainter {
  final List<BinaryNumber> binaryNumbers;
  final Color glowColor;

  BinaryPainter({
    required this.binaryNumbers,
    required this.glowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (var binary in binaryNumbers) {
      textPainter.text = TextSpan(
        text: binary.value,
        style: TextStyle(
          color: Color.fromARGB(255, 41, 61, 111),
          fontSize: 16,
          letterSpacing: 2, // Add spacing between characters
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(binary.x, binary.y));
    }
  }

  @override
  bool shouldRepaint(BinaryPainter oldDelegate) => true;
}


// Usage Example:
class ExampleUsage extends StatelessWidget {
  const ExampleUsage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: BinaryGlowChatBubble(width: 300, height: 200, message: "Looks like we are short of our workout goal... if we want to make progress we need to train hard!"),
      ),
    );
  }
}
