import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/providers.dart';

class BinaryGlowChatBubble extends StatefulWidget {
  const BinaryGlowChatBubble({
    super.key,
    required this.width,
    this.chatMore = false,
    this.message = '',
    this.margin,
  });
  
  final double width;
  final String message;
  final bool chatMore;
  final EdgeInsets? margin;

  @override
  State<BinaryGlowChatBubble> createState() => _BinaryGlowChatBubbleState();
}

class _BinaryGlowChatBubbleState extends State<BinaryGlowChatBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<BinaryNumber> _binaryNumbers = <BinaryNumber>[];
  final Random random = Random();
  static const int rowHeight = 25;
  final GlobalKey _containerKey = GlobalKey();
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // We'll generate binary numbers after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateBinaryNumbers();
    });
  }

  String _generateBinaryString() {
    return List.generate(16, (int index) => random.nextInt(2).toString()).join();
  }

  void _generateBinaryNumbers() {
    // Get the actual rendered height of the container
    final RenderBox? renderBox = _containerKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    
    final double actualHeight = renderBox.size.height;
    final int numberOfRows = (actualHeight / rowHeight).floor();
    
    // Clear existing numbers
    _binaryNumbers.clear();
    
    // Generate new numbers based on actual height
    for (int i = 0; i < numberOfRows; i++) {
      _binaryNumbers.add(
        BinaryNumber(
          x: -random.nextDouble() * widget.width,
          y: i * rowHeight + 5,
          value: _generateBinaryString(),
          speed: 0.5 + random.nextDouble() * 1,
        ),
      );
    }
    // Force a rebuild to show the new binary numbers
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double availableWidth = constraints.maxWidth;

        return Container(
          key: _containerKey,
          margin: widget.margin,
          width: widget.width,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 25, 34, 57),
            borderRadius: BorderRadius.circular(20),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.blue.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 15,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  width: availableWidth,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (BuildContext context, Widget? child) {
                      for (final BinaryNumber binary in _binaryNumbers) {
                        binary.x += binary.speed;
                        if (binary.x > widget.width) {
                          binary.x = -200;
                          binary.value = _generateBinaryString();
                        }
                      }

                      return CustomPaint(
                        painter: BinaryPainter(
                          binaryNumbers: _binaryNumbers,
                          glowColor: const Color.fromARGB(255, 41, 61, 111),
                        ),
                      );
                    },
                  ),
                ),
                if (widget.message.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                      child: Text(
                        widget.message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Roboto',
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                if (widget.chatMore)
                  GestureDetector(
                    onTap: () {
                      Provider.of<HomeIndexProvider>(context, listen: false).setIndex(7);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'CHAT MORE >>',
                        style: TextStyle(
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
      },
    );
  }
}

class BinaryNumber {

  BinaryNumber({
    required this.x,
    required this.y,
    required this.value,
    required this.speed,
  });
  double x;
  double y;
  String value;
  double speed;
}

class BinaryPainter extends CustomPainter {

  BinaryPainter({
    required this.binaryNumbers,
    required this.glowColor,
  });
  final List<BinaryNumber> binaryNumbers;
  final Color glowColor;

  @override
  void paint(Canvas canvas, Size size) {
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (final BinaryNumber binary in binaryNumbers) {
      textPainter.text = TextSpan(
        text: binary.value,
        style: const TextStyle(
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
