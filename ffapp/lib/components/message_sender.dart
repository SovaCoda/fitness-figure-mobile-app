import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../icons/fitness_icon.dart';
import 'utils/chat_model.dart';

/*
  This class is used to provide the user with a text input and a send icon to send messages
  that will be parsed by the ChatModel, which will send an Assistants API request
*/
class MessageSender extends StatefulWidget {
  const MessageSender({super.key});

  @override
  State<MessageSender> createState() => _MessageSenderState();
}

class _MessageSenderState extends State<MessageSender> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Get the current view insets (padding when the keyboard appears)
    final EdgeInsets viewInsets = MediaQuery.of(context).viewInsets;
    return Padding(
        padding: EdgeInsets.only(
            bottom:
                viewInsets.bottom), // Adjust padding when the keyboard is shown
        // Gradiented Container
        child: Container(
            padding: const EdgeInsets.only(
              left: 20,
              top: 10,
              right: 14,
            ),
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color.fromRGBO(51, 133, 162, 1),
                ),
              ),
              gradient: LinearGradient(
                colors: <Color>[
                  Color.fromRGBO(28, 109, 189, 0.29),
                  Color.fromRGBO(0, 164, 123, 0.29),
                ],
              ),
            ),
            height: MediaQuery.of(context).size.height * 0.072,
            child: Column(children: <Widget>[
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: <Widget>[
                  // Adds padding and bounds the width of the text input
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                    width:
                        MediaQuery.of(context).size.width * 0.6186513994910941,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: const Color(0xFF151515)),
                    // Text input for the user to type their message
                    child: TextField(
                      minLines: 1,
                      maxLines: null,
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Type here...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  // Send icon that creates chat messages
                  GestureDetector(
                    child: FitnessIcon(
                        type: FitnessIconType.send_icon,
                        size: MediaQuery.of(context).size.width * 0.13,
                        height: MediaQuery.of(context).size.height * 0.04),
                    onTap: () {
                      Provider.of<ChatModel>(context, listen: false)
                          .sendMessage(_controller.text, 'user', context);
                      _controller.clear();
                    },
                  ),
                ],
              ),
            ])));
  }
}
