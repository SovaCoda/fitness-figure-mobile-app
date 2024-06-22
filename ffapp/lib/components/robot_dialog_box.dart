import 'package:flutter/material.dart';
import "dart:math";

class RobotDialogBox extends StatelessWidget {

  final List<String> dialogOptions;
  final double width;
  final double height;
  final _random = Random();

  RobotDialogBox({
    super.key,
    required this.dialogOptions,
    required this.width,
    required this.height
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      width: width,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      child: Text(dialogOptions[_random.nextInt(dialogOptions.length)],
       style: Theme.of(context).textTheme.labelMedium!.copyWith(
        color: Theme.of(context).colorScheme.onSurface
       ),
       ),
    );
  }
}