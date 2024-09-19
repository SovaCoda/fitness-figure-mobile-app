import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:ffapp/pages/home/store.dart';
import 'package:flutter/material.dart';

class ChatMessage {
  final String text;
  final String user;
  final String robot;

  ChatMessage(this.text, this.user, this.robot);
}

class ChatModel extends ChangeNotifier {
  List<ChatMessage> messages = List.empty(growable: true);
  String? robot;
  String? instructions = "";
  List<String?>? personalityModules;
  late OpenAI openAI;

  Future<void> init() async {
    openAI = OpenAI.instance.build(
        token: "sk-proj-QpCgg3HzPQvHSRjXu9HRT3BlbkFJ4aGGyeCD6DyYcw1qx1w7",
        baseOption: HttpSetup(
            receiveTimeout: const Duration(seconds: 20),
            connectTimeout: const Duration(seconds: 20)),
        enableLog: true);
    personalityModules = ['strict', 'stubborn'];
    messages.clear();
    instructions =
        "you are robot in an App, you have three statistics that are unique to you. 1. Charge - this is a percent based stat from 0 - 100% your charge increases when a user works out and increases more based on how consistent the user is in their workout schedule 2. evo - this a value that tracks your evolution progress, you have 8 different levels of evolution and the user has to gain enough evo points based on your level to increase your level of evolution. the user can generate evo points for you by working out, keeping your charge high, and doing research on the research tab. 3. Currency - this is a shared stat between you and the user. you generate currency per second based on how high your evolution level is. Here are your current stats: Charge = 52%, Evo = 200 out of 1000, Currency = 7,400.  You have personality modules installed that affect your responses. Your current personality is: ${personalityModules.toString()}. Do not mention your personality modules in conversation. Your personality cores dictate everything about you and your responses. In your first message to the user, respond as if they have just walked through the door, keep your response short but only for the first message.";
    messages.add(ChatMessage(instructions!, "system", ""));
  }

  Future<void> sendMessage(String message, String role) async {
    messages.add(ChatMessage(message, role, ""));
    notifyListeners();
    var request = ChatCompleteText(
        model: Gpt4oMini2024ChatModel(),
        messages:
            messages.map((e) => {"role": e.user, "content": e.text}).toList(),
        maxToken: 450);

    ChatCTResponse? response = await openAI.onChatCompletion(request: request);
    logger.i(response!.choices.first.message!.content);
    messages.add(ChatMessage(
        response.choices.first.message!.content, "assistant", "robot1"));
    notifyListeners();
  }

  Future<String> sendSystemMessage(String systemMessage) async {
    messages.add(ChatMessage(systemMessage, "system", ""));
    notifyListeners();

    var request = ChatCompleteText(
    model: Gpt4oMini2024ChatModel(),
    messages:
      messages.map((e) => {"role": e.user, "content": e.text}).toList(),
      maxToken: 450);

    ChatCTResponse? response = await openAI.onChatCompletion(request: request);
    logger.i(response!.choices.first.message!.content);
    messages.add(ChatMessage(
      response.choices.first.message!.content, "assistant", "robot1"));
    notifyListeners();
    return response.choices.first.message!.content;
  }

  Future<String> generatePremiumOfflineStatusMessage(Map<String, dynamic> gameState) async {
    List<ChatMessage> copiedMessages = messages;
    String prompt = "Send a message to a user that would appear in a push notification on their phone based on this info $gameState. Only pick one or two of the stats to mention. Don't use emoji's, Be personable and human. Take into account your personality cores.";
    copiedMessages.add(ChatMessage(prompt, "system", ""));

    var request = ChatCompleteText(
    model: Gpt4oMini2024ChatModel(),
    messages:
      copiedMessages.map((e) => {"role": e.user, "content": e.text}).toList(),
      maxToken: 450);

    ChatCTResponse? response = await openAI.onChatCompletion(request: request);
    return response!.choices.first.message!.content;
  }

  void addMessage(ChatMessage message) {
    messages.add(message);
    notifyListeners();
  }
}
