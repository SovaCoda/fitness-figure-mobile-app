import 'package:flutter/material.dart';

class EvBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 0); // Move to the starting point of the cut
    path.lineTo(size.width, 0); // Define the cut line
    path.lineTo(size.width - 20, size.height);
    path.lineTo(0, size.height);
    path.close(); //
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
