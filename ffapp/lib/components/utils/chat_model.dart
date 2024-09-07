import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:ffapp/pages/home/store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/components/utils/history_model.dart';
import 'package:ffapp/pages/home/workout_adder.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
 *  When the program starts, four API calls will be made: 
 *   
 *   This request initializes the assistant
 *   [OpenAI] starting request https://api.openai.com/v1/assistants
 *   [OpenAI] request body :{model: gpt-4, name: Robot Assistant, description: null, instructions: you are robot in an App, you have three statistics that are unique to you. 
 *   1. Charge - this is a percent based stat from 0 - 100% your charge increases when a user works out and increases more based on how consistent the user is in their workout 
 *   schedule 2. evo - this a value that tracks your evolution progress, you have 8 different levels of evolution and the user has to gain enough evo points based on your level 
 *   to increase your level of evolution. the user can generate evo points for you by working out, keeping your charge high, and doing research on the research tab. 
 *   3. Currency - this is a shared stat between you and the user. you generate currency per second based on how high your evolution level is. Here are your current stats: 
 *   Charge = 52%, Evo = 200 out of 1000, Currency = 7,400.  You have personality modules installed that affect your responses. Your current personality is: [strict, stubborn]. 
 *   Do not mention your personality modules in conversation. Your personality cores dictate everything about you and your responses. In your first message to the user, respond 
 *   as if they have just walked through the door, keep your response short but only for the first message., tools: [{type: function, function: {name: get_robot_stats, description: 
 *   Get the current stats of the robot, parameters: {type: object, properties: {charge: {type: number, description: The current charge of the robot (0-100%)}, evo: {type: number, description: 
 *   The current evolution points of the robot}, currency: {type: number, description: The current amount of currency}}, required: [charge, evo, currency]}}}], tool_resources: {code_interpreter: {file_ids: []}}} (currently no files)
 *   [OpenAI] ============= success ==================
 *   
 *   The following request creates a thread for messages:
 *   [OpenAI] starting request https://api.openai.com/v1/threads
 *   [OpenAI] request body :{tool_resources: {code_interpreter: {file_ids: []}}}
 *   [OpenAI] ============= success ==================
 *   
 *   This request sends a welcome message to the user when starting up the app:
 *   [OpenAI] starting request https://api.openai.com/v1/threads/thread_xPnU7AlBdxAXd7C2pRm1UlAq/messages
 *   [OpenAI] request body :{role: user, content: The user has just signed in. Give them a short, warm welcome and encourage them to start exercising.}
 *   [OpenAI] ============= success ==================
 *   
 *   This request uses the code interpreter feature of assistants and creates the response to the user:
 *   [OpenAI] starting request https://api.openai.com/v1/threads/thread_xPnU7AlBdxAXd7C2pRm1UlAq/runs
 *   [OpenAI] request body :{assistant_id: asst_67gMHQEI9HlSQSm2KpUrGkLG, top_p: 1.0}
 *   [OpenAI] ============= success ==================
 *
 *   This is how the log files should look under normal operation of the chat model
 */

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
  String? assistantId;
  String? threadId;
  late BuildContext context;
  SharedPreferences? prefs;

  void setContext(BuildContext context) {
    this.context = context;
  }

  Future<void> init() async {
    await dotenv.load(fileName: ".env");
    prefs = await SharedPreferences.getInstance();
    openAI = OpenAI.instance.build(
        token: dotenv.env['OPENAI_KEY']!,
        baseOption: HttpSetup(
            receiveTimeout: const Duration(seconds: 20),
            connectTimeout: const Duration(seconds: 20)),
        enableLog: true);
    personalityModules = ['strict', 'stubborn'];
    messages.clear();
    instructions =
        "you are robot in an App, you have three statistics that are unique to you. 1. Charge - this is a percent based stat from 0 - 100% your charge increases when a user works out and increases more based on how consistent the user is in their workout schedule 2. evo - this a value that tracks your evolution progress, you have 8 different levels of evolution and the user has to gain enough evo points based on your level to increase your level of evolution. the user can generate evo points for you by working out, keeping your charge high, and doing research on the research tab. 3. Currency - this is a shared stat between you and the user. you generate currency per second based on how high your evolution level is. You have personality modules installed that affect your responses. Your current personality is: ${personalityModules.toString()}. Do not mention your personality modules in conversation. Your personality cores dictate everything about you and your responses. In your first message to the user, respond as if they have just walked through the door, keep your response short but only for the first message.";

    // Create an assistant
    final assistant = Assistant(
      model: Gpt4AModel(),
      name: 'Robot Assistant',
      instructions: instructions,
      tools: [
        {
          "type": "function",
          "function": {
            "name": "get_robot_stats",
            "description": "Get the current stats of the robot",
            "parameters": {
              "type": "object",
              "properties": {
                "charge": {
                  "type": "number",
                  "description": "The current charge of the robot (0-100%)"
                },
                "evo": {
                  "type": "number",
                  "description": "The current evolution points of the robot"
                },
                "currency": {
                  "type": "number",
                  "description": "The current amount of currency"
                }
              },
              "required": ["charge", "evo", "currency"]
            }
          }
        },
        {
          "type": "function",
          "function": {
            "name": "startWorkoutTimer",
            "description": "Start a timer for a workout session",
            "parameters": {"type": "object", "properties": {}, "required": []}
          }
        }
      ],
    );
    final createdAssistant =
        await openAI.assistant.v2.create(assistant: assistant);
    assistantId = createdAssistant.id;

    // Create a thread
    final threadRequest = ThreadRequest();
    final createdThread =
        await openAI.threads.v2.createThread(request: threadRequest);
    threadId = createdThread.id;
    messages.add(ChatMessage(
        "Welcome to Fitness Figure! Let's start an exercise!",
        "system",
        "robot1"));
    notifyListeners();
  }

  Future<Map<String, dynamic>> get_robot_stats() async {
    // currently unused
    final figureModel = Provider.of<FigureModel>(context, listen: false);
    final userModel = Provider.of<UserModel>(context, listen: false);

    int charge = figureModel.figure?.charge ?? 0;
    int evoPoints = figureModel.figure?.evPoints ?? 0;
    int currency = userModel.user?.currency.toInt() ?? 0;

    return {
      "charge": charge,
      "evo": evoPoints,
      "currency": currency,
    };
  }

  Future<String> startWorkoutTimer() async {
    String timerName = "workout_timer";
    DateTime now = DateTime.now();
    await prefs!.setString('$timerName timerStarted', now.toString());
    return "Workout timer started successfully.";
  }

  Future<void> sendMessage(String message, String role) async {
  if (message.trim().isEmpty) {
    throw Exception("Cannot send an empty message");
  }

  messages.add(ChatMessage(message, role, ""));
  notifyListeners();

  try {
    // Create a message in the thread
    final createMessage = CreateMessage(
      role: 'user',
      content: message,
    );
    await openAI.threads.v2.messages.createMessage(
      threadId: threadId!,
      request: createMessage,
    );

    // Run the assistant
    final runRequest = CreateRun(
      assistantId: assistantId!,
      tools: [
        {
          "type": "function",
          "function": {
            "name": "get_robot_stats",
            "description": "Get the current stats of the robot",
            "parameters": {
              "type": "object",
              "properties": {
                "charge": {
                  "type": "number",
                  "description": "The current charge of the robot (0-100%)"
                },
                "evo": {
                  "type": "number",
                  "description": "The current evolution points of the robot"
                },
                "currency": {
                  "type": "number",
                  "description": "The current amount of currency"
                }
              },
              "required": ["charge", "evo", "currency"]
            }
          }
        },
        {
          "type": "function",
          "function": {
            "name": "startWorkoutTimer",
            "description": "Start a timer for a workout session",
            "parameters": {"type": "object", "properties": {}, "required": []}
          }
        }
      ],
    );

    final run = await openAI.threads.runs.createRun(threadId: threadId!, request: runRequest);

    // Wait for the run to complete with proper polling
    String runStatus = run.status;
    int retries = 0;
    const maxRetries = 30; // Adjust as needed
    const pollingInterval = Duration(seconds: 2); // Adjust as needed

    while (runStatus != "completed" && retries < maxRetries) {
      await Future.delayed(pollingInterval);
      final updatedRun = await openAI.threads.runs.retrieveRun(threadId: threadId!, runId: run.id);
      runStatus = updatedRun.status;

      if (runStatus == "requires_action") {
        await handleRequiredAction(updatedRun);
      } else if (runStatus == "failed") {
        logger.e("Run failed: ${updatedRun.lastError.toString()}");
        return;
      }

      retries++;
    }

    if (runStatus != "completed") {
      logger.e("Run did not complete within the maximum number of retries");
      return;
    }

    // Retrieve and process the assistant's response
    await retrieveAndProcessAssistantResponse();

  } catch (e) {
    logger.e("An error occurred: $e");
  }
}

Future<void> handleRequiredAction(CreateRunResponse updatedRun) async {
  final toolCalls = updatedRun.requiredAction?['submit_tool_outputs']?['tool_calls'] ?? [];
  List<Map<String, dynamic>> toolOutputs = [];

  for (var toolCall in toolCalls) {
    if (toolCall['function']['name'] == "startWorkoutTimer") {
      final result = await startWorkoutTimer();
      toolOutputs.add({
        'tool_call_id': toolCall['id'],
        'output': result,
      });
    } else if (toolCall['function']['name'] == "get_robot_stats") {
      final stats = await get_robot_stats();
      toolOutputs.add({
        'tool_call_id': toolCall['id'],
        'output': jsonEncode(stats),
      });
    }
  }

  if (toolOutputs.isNotEmpty) {
    await openAI.threads.runs.submitToolOutputsToRun(
      threadId: threadId!,
      runId: updatedRun.id,
      toolOutputs: toolOutputs,
    );
  }
}

Future<void> retrieveAndProcessAssistantResponse() async {
  final messagesResponse = await openAI.threads.v2.messages.listMessage(threadId: threadId!);
  if (messagesResponse.data.isNotEmpty) {
    final assistantMessage = messagesResponse.data.first;
    if (assistantMessage.content.isNotEmpty) {
      messages.add(ChatMessage(assistantMessage.content.first.text.value, "assistant", "robot1"));
      notifyListeners();
    } else {
      logger.i("Received an empty message from the assistant");
    }
  } else {
    logger.i("No messages received from the assistant");
  }
}

  Future<void> _sendWelcomeMessage() async {
    try {
      // Create a message in the thread
      final createMessage = CreateMessage(
        role: 'user',
        content:
            "The user has just signed in. Give them a short, warm welcome and encourage them to start exercising.",
      );
      await openAI.threads.v2.messages.createMessage(
        threadId: threadId!,
        request: createMessage,
      );

      // Run the assistant
      final runRequest = CreateRun(assistantId: assistantId!);
      final run = await openAI.threads.runs
          .createRun(threadId: threadId!, request: runRequest);

      // Wait for the run to complete
      String runStatus = run.status;
      while (runStatus != "completed") {
        await Future.delayed(const Duration(seconds: 1));
        final updatedRun = await openAI.threads.runs
            .retrieveRun(threadId: threadId!, runId: run.id);
        runStatus = updatedRun.status;

        if (runStatus == "failed") {
          logger.e("Run failed: ${updatedRun.lastError.toString()}");
          return;
        }
      }

      // Retrieve the messages
      final messagesResponse =
          await openAI.threads.v2.messages.listMessage(threadId: threadId!);
      if (messagesResponse.data.isNotEmpty) {
        final assistantMessage = messagesResponse.data.first;
        if (assistantMessage.content.isNotEmpty) {
          logger.i(assistantMessage.content.first.text.value);
          messages.add(ChatMessage(assistantMessage.content.first.text.value,
              "assistant", "robot1"));
          notifyListeners();
        } else {
          logger.i("Received an empty message from the assistant");
        }
      } else {
        logger.i("No messages received from the assistant");
      }
    } catch (e) {
      logger.e("An error occurred while sending welcome message: $e");
    }
  }
}
