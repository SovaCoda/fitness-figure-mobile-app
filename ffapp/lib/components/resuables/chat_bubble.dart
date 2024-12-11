import 'package:ffapp/components/resuables/gradiented_container.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return GradientedContainer(
        padding: EdgeInsets.all(4),
        child: Text(
          message,
          style: Theme.of(context).textTheme.displaySmall,
        ));
  }
}
