import 'package:flutter/material.dart';

class DoubleLineDivider extends StatelessWidget {
  const DoubleLineDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 60),
        VerticalDivider(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          width: 4,
          thickness: 1,
        ),
        VerticalDivider(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          width: 4,
          thickness: 1,
        ),
        const SizedBox(width: 60),
      ],
    );
  }
}
