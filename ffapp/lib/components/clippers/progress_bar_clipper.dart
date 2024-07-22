import 'package:flutter/material.dart';

class ProgressBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 5); // Move to the starting point of the cut
    path.lineTo(size.width - 65, 5);
    path.lineTo(size.width - 60, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - 5);
    path.lineTo(size.width - 60, size.height - 5);
    path.lineTo(size.width - 65, size.height);
    path.lineTo(0, size.height);
    path.close(); //
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
