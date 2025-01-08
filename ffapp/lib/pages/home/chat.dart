import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../components/ff_app_button.dart';
import '../../components/message_sender.dart';
import '../../components/robot_response.dart';
import '../../components/user_message.dart';
import '../../components/utils/chat_model.dart';
import '../../icons/fitness_icon.dart';
import '../../main.dart';
import '../../services/providers.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});
  static const MAX_CHATGPT_MESSAGES = 20;

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

  // Widget to display chat content
  Widget _buildChatContent() {
    return GestureDetector(
        // TODO: Test for iOS Support -- unfocuses keyboard when scrolling up or down
        onPanDown: (DragDownDetails _) =>
            FocusManager.instance.primaryFocus?.unfocus(),
        // TODO: Test for iOS Support -- unfocuses keyboard when tapping outside text area
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            // Title bar
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              margin: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Double back arrow icon that sends user to dashboard
                  GestureDetector(
                      child: const FitnessIcon(
                          type: FitnessIconType.double_back_arrow, size: 20),
                      onTap: () => {
                            // unfocus the keyboard if it exists
                            FocusManager.instance.primaryFocus?.unfocus(),
                            Provider.of<HomeIndexProvider>(context,
                                    listen: false)
                                .setIndex(0)
                          }),
                  // Title text
                  const Text('CHAT',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w400))
                ],
              ),
            ),
            // Main chat section
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
                      // Put 'robot is typing' after the last message that robot is typing if chatmodel sets it to true
                      if (index == chatModel.messages.length &&
                          chatModel.isRobotTyping) {
                        // display that robot is typing
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
                      // Determines which message bubble to show
                      switch (message.user) {
                        case 'system':
                          return null;
                        case 'assistant':
                          return RobotResponse(
                              text: message.text,
                              figureName: Provider.of<FigureModel>(context)
                                  .figure!
                                  .figureName,
                              datetime: 'now');
                        case 'user':
                          return UserMessage(
                              text: message.text, datetime: 'now');
                        default:
                          throw UnimplementedError(
                              'This user type was not implemented');
                      }
                    },
                  );
                },
              ),
            ),
            // Text entry and send button container
            const MessageSender(),
          ],
        ));
  }

  // Widget for when the user reaches max chatGPT messages
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
          // Title text
          Text(
            'Max messages reached',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          // Subtext
          const Text(
            'You have reached the maximum amount of messages today. Come back tomorrow.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // button that sends user back to dashboard
          FFAppButton(
              onPressed: () => {
                    setState(() {
                      Provider.of<HomeIndexProvider>(context, listen: false)
                          .setIndex(0);
                    })
                  },
              text: 'Come back tomorrow',
              size: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.08),
        ],
      ),
    );
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
          // Title text
          Text(
            'Premium Members Only',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          // Subtext
          const Text(
            'This feature is available exclusively to premium members.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // button that sends user to subscribe page
          FFAppButton(
              onPressed: () => context.goNamed('Subscribe'),
              text: 'Upgrade to Premium',
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
        if (isPremium) {
          // check if user exceeded chatGPT messages limit
          if (userModel.user!.dailyChatMessages <=
              ChatPage.MAX_CHATGPT_MESSAGES) {
            return _buildChatContent();
          } else {
            return _buildMaxMessagesContent();
          }
        } else {
          return _buildPremiumMessage();
        }
      },
    );
  }
}
