import 'package:flutter/material.dart';

class DoubleLineDivider extends StatelessWidget {

  const DoubleLineDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 10),
        VerticalDivider(
          color: Colors.grey[300],
          width: 4,
          thickness: 1,
        ),
        VerticalDivider(
          color: Colors.grey[300],
          width: 4,
          thickness: 1,
        ),
        SizedBox(width: 10),
    ],);
  }
}