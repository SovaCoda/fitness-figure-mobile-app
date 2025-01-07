import 'package:ffapp/components/message_sender.dart';
import 'package:ffapp/components/robot_response.dart';
import 'package:ffapp/components/user_message.dart';
import 'package:ffapp/components/utils/chat_model.dart';
import 'package:ffapp/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ffapp/components/ff_app_button.dart';

import '../../icons/fitness_icon.dart';
import '../../services/providers.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

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

  // Widget to display premium-only message
  Widget _buildPremiumMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.lock,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'Premium Members Only',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'This feature is available exclusively to premium members.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FFAppButton(
              onPressed: () => context.goNamed('Subscribe'),
              text: 'Upgrade to Premium',
              size: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.08),
        ],
      ),
    );
  }

  // Widget to display chat content
  Widget _buildChatContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        Container(
          width: MediaQuery.of(context).size.width * 0.5,
          margin: EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                child: const FitnessIcon(
                    type: FitnessIconType.double_back_arrow, size: 20),
                onTap: () => Provider.of<HomeIndexProvider>(context, listen: false).setIndex(0) // go back to dashboard
              ),
              const Text("CHAT",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400))
            ],
          ),
        ),
        Expanded(
          child: Consumer<ChatModel>(
            builder:
                (BuildContext context, ChatModel chatModel, Widget? child) {
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => _scrollToBottom());
              return ListView.builder(
                controller: _scrollController,
                itemCount: chatModel.messages.length +
                    (chatModel.isRobotTyping ? 1 : 0),
                itemBuilder: (BuildContext context, int index) {
                  if (index == chatModel.messages.length &&
                      chatModel.isRobotTyping) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Robot is typing...',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }
                  final ChatMessage message = chatModel.messages[index];
                  return message.user == 'assistant' || message.user == 'system'
                      ? message.user == 'system'
                          ? null
                          : RobotResponse(
                              text: message.text,
                              datetime: 'now',
                              figureName: Provider.of<FigureModel>(context)
                                  .figure!
                                  .figureName)
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
    );
  }

  Widget _buildMaxMessagesContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.lock,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'Max messages reached',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'You have reached the maximum amount of messages today. Come back tomorrow.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FFAppButton(
              onPressed: () => Provider.of<HomeIndexProvider>(context, listen: false).setIndex(0),
              text: 'Come back tomorrow',
              size: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.08),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(
      builder: (BuildContext context, UserModel userModel, Widget? child) {
        final bool isPremium = userModel.isPremium();
        return isPremium ? userModel.user!.dailyChatMessages <= 1 ? _buildChatContent() : _buildMaxMessagesContent() : _buildPremiumMessage();
      },
    );
  }
  //       } catch (e) {
  //         // Handle any errors that occur while checking premium status
  //         return Center(
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: <Widget>[
  //               const Icon(Icons.error_outline, size: 48, color: Colors.red),
  //               const SizedBox(height: 16),
  //               Text('Error: Unable to verify premium status\n$e'),
  //               const SizedBox(height: 16),
  //               FFAppButton(
  //                   onPressed: () => context.goNamed('Home'),
  //                   text: 'Return to Home',
  //                   size: MediaQuery.of(context).size.width * 0.8,
  //                   height: MediaQuery.of(context).size.height * 0.08),
  //             ],
  //           ),
  //         );
  //       }
  //     },
  //   );
  // }
}
