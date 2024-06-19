import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PopupWidget extends StatelessWidget {
  final String message;

  PopupWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Survey'),
      content: Text(message),
      actions: [
        TextButton(
          child: Text('Sure!'),
          onPressed: () {
            context.goNamed('Survey');
          },
        ),
        TextButton(
          child: Text('Close'),
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

  GenericPopupWidget({required this.message, required this.title});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}