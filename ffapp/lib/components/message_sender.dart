import 'package:ffapp/components/utils/chat_model.dart';
import 'package:ffapp/pages/home/chat.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MessageSender extends StatefulWidget {
  const MessageSender({Key? key}) : super(key: key);

  @override
  State<MessageSender> createState() => _MessageSenderState();
}

class _MessageSenderState extends State<MessageSender> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.chevron_left,
              size: 40,
            ),
            onPressed: () {
              context.goNamed('Home');
            },
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              Provider.of<ChatModel>(context, listen: false)
                  .sendMessage(_controller.text, "user");
              _controller.clear();
            },
          ),
        ],
      ),
    );
  }
}
