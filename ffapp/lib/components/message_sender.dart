import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ffapp/components/utils/chat_model.dart';

class MessageSender extends StatefulWidget {
  const MessageSender({Key? key}) : super(key: key);

  @override
  State<MessageSender> createState() => _MessageSenderState();
}

class _MessageSenderState extends State<MessageSender> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Get the current view insets (padding when the keyboard appears)
    final viewInsets = MediaQuery.of(context).viewInsets;

    return Padding(
      padding: EdgeInsets.only(
          bottom:
              viewInsets.bottom), // Adjust padding when the keyboard is shown
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.grey[900],
                ),
                child: TextField(
                  minLines: 1,
                  maxLines: null,
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                Provider.of<ChatModel>(context, listen: false)
                    .sendMessage(_controller.text, "user", context);
                _controller.clear();
              },
            ),
          ],
        ),
      ),
    );
  }
}
