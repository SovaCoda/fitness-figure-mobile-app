import 'package:flutter/material.dart';

class DoubleLineDivider extends StatelessWidget {
  final double spacing;
  const DoubleLineDivider({super.key, required this.spacing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: spacing),
        Column(
          children: [
            Container(
              height: 3,
              width: 3,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.secondaryFixed,
              ),
            ),
            Expanded(
              child: Container(
                width: 1,
                color: Theme.of(context).colorScheme.secondaryFixed,
              ),
            ),
            Container(
              height: 3,
              width: 3,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.secondaryFixed,
              ),
            ),
          ],
        ),
        SizedBox(width: spacing),
      ],
    );
  }
}
