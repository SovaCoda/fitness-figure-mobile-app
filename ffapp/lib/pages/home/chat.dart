import 'package:dart_openai/dart_openai.dart';
import 'package:ffapp/components/message_sender.dart';
import 'package:ffapp/components/robot_response.dart';
import 'package:ffapp/components/user_message.dart';
import 'package:ffapp/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageProvider extends ChangeNotifier {
  String _message = '';

  String get message => _message;

  OpenAIChatCompletionChoiceMessageModel systemMessage =
      OpenAIChatCompletionChoiceMessageModel(
    content: [
      OpenAIChatCompletionChoiceMessageContentItemModel.text(
        "return any message you are given as JSON. You are a fitness companion in an app called fitness figure respond to the user in a flirtatious way about their health, try and get them to feel bad for a good purpose. Never use the \" character in your responses.",
      ),
    ],
    role: OpenAIChatMessageRole.assistant,
  );

  Map<RobotResponse, UserMessage?> interactions = {
    RobotResponse(
        text: 'Hello!',
        figure_url: "robot1/robot1_skin0_evo0_cropped_happy",
        datetime: '2022-01-01 00:00:00'): null,
  };

  Map<RobotResponse, UserMessage?> getInteractions() {
    return interactions;
  }

  Future<void> sendMessage(String message) async {
    OpenAIChatCompletionChoiceMessageModel userMessage =
        OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
          message,
        ),
      ],
      role: OpenAIChatMessageRole.user,
    );
    List<OpenAIChatCompletionChoiceMessageModel> requestMessages = [
      systemMessage,
      userMessage
    ];

    OpenAIChatCompletionModel chatCompletion =
        await OpenAI.instance.chat.create(
      model: "gpt-3.5-turbo-1106",
      responseFormat: {"type": "json_object"},
      seed: 6,
      messages: requestMessages,
      temperature: 0.2,
      maxTokens: 500,
    );

    String originalString = chatCompletion.choices.first.message.toString();

    // Find the index of the third "
    int startIndex = 0;
    for (int i = 0; i < 3; i++) {
      startIndex = originalString.indexOf('"', startIndex + 1);
    }

    // Find the index of the fourth "
    int endIndex = originalString.indexOf('"', startIndex + 1);

    // Extract the substring
    String trimmedString = chatCompletion.choices.first.message.toString();
    if (startIndex != -1 && endIndex != -1) {
      trimmedString = originalString.substring(startIndex + 1, endIndex);
    }

    interactions[RobotResponse(
            text: trimmedString,
            figure_url: "robot1/robot1_skin0_evo0_cropped_happy",
            datetime: '2022-01-01 00:00:00')] =
        UserMessage(text: message, datetime: '2022-01-01 00:00:00');
    notifyListeners();
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Map<RobotResponse, UserMessage?> interactions =
      MessageProvider().getInteractions();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: ChangeNotifierProvider(
          create: (context) => MessageProvider(),
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
                      child: Consumer<MessageProvider>(
                        builder: (_, interactions, __) {
                          return ListView.builder(
                              shrinkWrap: false,
                              itemCount: interactions.getInteractions().length,
                              itemBuilder: (context, index) {
                                return interactions
                                            .getInteractions()
                                            .values
                                            .elementAt(index) ==
                                        null
                                    ? SizedBox(
                                        width: MediaQuery.sizeOf(context).width,
                                        child: interactions
                                            .getInteractions()
                                            .keys
                                            .elementAt(index))
                                    : Column(
                                        children: [
                                          SizedBox(
                                              width: MediaQuery.sizeOf(context)
                                                  .width,
                                              child: interactions
                                                  .getInteractions()
                                                  .values
                                                  .elementAt(index)),
                                          SizedBox(
                                              width: MediaQuery.sizeOf(context)
                                                  .width,
                                              child: interactions
                                                  .getInteractions()
                                                  .keys
                                                  .elementAt(index)!)
                                        ],
                                      );
                              });
                        },
                      ),
                    ),
                  ),
                  MessageSender(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
