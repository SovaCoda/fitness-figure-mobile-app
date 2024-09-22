import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ffapp/components/utils/chat_model.dart';
import 'package:ffapp/components/message_sender.dart';
import 'package:ffapp/components/robot_response.dart';
import 'package:ffapp/components/user_message.dart';
import 'package:go_router/go_router.dart';
import 'package:ffapp/main.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          leading: IconButton(
            icon: const Icon(Icons.chevron_left, size: 40),
            onPressed: () => context.goNamed('Home'),
          ),
          title: Text('Chat'),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: IconButton(
                icon: const Icon(Icons.psychology, size: 40),
                onPressed: () => context.goNamed('Personality'),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: Consumer<ChatModel>(
                builder: (context, chatModel, child) {
                  WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: chatModel.messages.length + (chatModel.isRobotTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == chatModel.messages.length && chatModel.isRobotTyping) {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Robot is typing...",
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      }
                      final message = chatModel.messages[index];
                      return message.user == 'assistant' || message.user == 'system'
                          ? message.user == 'system' ? null : RobotResponse(
                              text: message.text,
                              figure_url: Provider.of<FigureModel>(context).composeFigureUrl(),
                              datetime: "now",
                            )
                          : UserMessage(
                              text: message.text,
                              datetime: 'now',
                            );
                    },
                  );
                },
              ),
            ),
            const MessageSender(),
          ],
        ),
      ),
    );
  }
}