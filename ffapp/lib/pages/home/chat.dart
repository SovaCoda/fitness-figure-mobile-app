import 'package:dart_openai/dart_openai.dart';
import 'package:ffapp/components/message_sender.dart';
import 'package:ffapp/components/robot_response.dart';
import 'package:ffapp/components/user_message.dart';
import 'package:ffapp/components/utils/chat_model.dart';
import 'package:ffapp/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Map<RobotResponse, UserMessage?> interactions = {};

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Consumer<FigureModel>(
          builder: (context, figure, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Container(
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height,
                        minHeight: MediaQuery.of(context).size.height - 500),
                    width: MediaQuery.of(context).size.width,
                    child: Consumer<ChatModel>(
                      builder: (_, chat, __) {
                        return ListView.builder(
                            shrinkWrap: false,
                            itemCount: chat.messages.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.sizeOf(context).width,
                                    child: (chat.messages[index].user ==
                                                'assistant' ||
                                            chat.messages[index].user ==
                                                'system')
                                        ? chat.messages[index].user == 'assistant'
                                            ? RobotResponse(
                                                text: chat.messages[index].text,
                                                figure_url:
                                                    figure.composeFigureUrl(),
                                                datetime: "now")
                                            : Container()
                                        : UserMessage(
                                            text: chat.messages[index].text,
                                            datetime: 'now',
                                          ),
                                  ),
                                ],
                              );
                            });
                      },
                    ),
                  ),
                ),
                const MessageSender(),
              ],
            );
          },
        ),
      ),
    );
  }
}
