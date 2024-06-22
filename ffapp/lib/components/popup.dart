import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PopupWidget extends StatelessWidget {
  final String message;

  const PopupWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Survey'),
      content: Text(message),
      actions: [
        TextButton(
          child: const Text('Sure!'),
          onPressed: () {
            context.goNamed('Survey');
          },
        ),
        TextButton(
          child: const Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class GenericPopupWidget extends StatelessWidget {
  final String message;
  final String title;

  const GenericPopupWidget({super.key, required this.message, required this.title});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          child: const Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}