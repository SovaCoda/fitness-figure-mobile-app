import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ffapp/components/utils/chat_model.dart';

import '../icons/fitness_icon.dart';

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
            // doWeBinkTheBorder: false,
            // radius: 0,
            child: Column(children: <Widget>[
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Centers the row horizontally
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                      width: MediaQuery.of(context).size.width *
                          0.6186513994910941,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: const Color(0xFF151515)),
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
                    GestureDetector(
                      child: FitnessIcon(type: FitnessIconType.send_icon, size: MediaQuery.of(context).size.width *
                          0.13, height: MediaQuery.of(context).size.height *0.04 ),
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
