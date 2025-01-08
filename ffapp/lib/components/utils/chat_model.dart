import 'dart:async';
import 'dart:convert';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../assets/data/figure_ev_data.dart';
import '../../main.dart';
import '../../pages/home/chat.dart';
import '../../pages/home/store.dart';
import '../../services/auth.dart' as auth;
import '../../services/providers.dart';
import '../../services/routes.pb.dart';
import 'history_model.dart';

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
  final bool isTyping;

  ChatMessage(this.text, this.user, this.robot, {this.isTyping = false});
}

class ChatModel extends ChangeNotifier {
  List<ChatMessage> messages = List.empty(growable: true);
  bool isRobotTyping = false;
  String? robot;
  String? instructions = '';
  List<String> personalityModules = [];
  late OpenAI openAI;
  String? assistantId;
  String? threadId;
  SharedPreferences? prefs;
  // late Timer _notificationTimer;
  // final LocalNotificationService _localNotificationService =
  //     LocalNotificationService();

  ChatModel() {
    // _initNotificationTimer(); unused as the server should handle notifications
  }

  // Functionality for sending exercise reminder notifications (currently unused)
  // void _initNotificationTimer() {
  //   _notificationTimer = Timer.periodic(Duration(hours: 6), (_) {
  //     // Adjust timer as needed
  //     _sendExerciseReminder();
  //   });
  // }

  // Future<void> _sendExerciseReminder() async {
  //   if (Provider.of<HistoryModel>(context, listen: false).workedOutToday) {
  //     // Check if the user has already worked out today
  //     return;
  //   }
  //   try {
  //     // Create a message in the thread

  //     final createMessage = CreateMessage(
  //       role: 'user',
  //       content: "Generate a short, motivating exercise reminder message.",
  //     );
  //     await openAI.threads.v2.messages.createMessage(
  //       threadId: threadId!,
  //       request: createMessage,
  //     );

  //     // Run the assistant
  //     final runRequest = CreateRun(assistantId: assistantId!);
  //     final run = await openAI.threads.runs
  //         .createRun(threadId: threadId!, request: runRequest);

  //     // Wait for the run to complete
  //     String runStatus = run.status;
  //     while (runStatus != "completed") {
  //       await Future.delayed(const Duration(seconds: 1));
  //       final updatedRun = await openAI.threads.runs
  //           .retrieveRun(threadId: threadId!, runId: run.id);
  //       runStatus = updatedRun.status;

  //       if (runStatus == "failed") {
  //         print("Run failed: ${updatedRun.lastError.toString()}");
  //         return;
  //       }
  //     }

  // Retrieve the message
  //     final messagesResponse =
  //         await openAI.threads.v2.messages.listMessage(threadId: threadId!);
  //     if (messagesResponse.data.isNotEmpty) {
  //       final assistantMessage = messagesResponse.data.first;
  //       if (assistantMessage.content.isNotEmpty) {
  //         String reminderMessage = assistantMessage.content.first.text.value;
  //         await _localNotificationService.showNotification(
  //           id: 0,
  //           title: "Time to Exercise!",
  //           body: reminderMessage,
  //         );
  //         print("Exercise reminder sent: $reminderMessage");
  //       }
  //     }
  //   } catch (e) {
  //     print("Error sending exercise reminder: $e");
  //   }
  // }

  void updateChat() {
    notifyListeners();
  }

  // grabs personality modules from local storage
  Future<void> loadPersonalityModules() async {
    prefs = await SharedPreferences.getInstance();
    final String? modulesJson = prefs?.getString('personalityModules');
    if (modulesJson != null) {
      personalityModules =
          List<String>.from(json.decode(modulesJson) as Iterable<dynamic>);
    }
    notifyListeners();
  }

  // saves personality modules to local storage
  Future<void> savePersonalityModules() async {
    await prefs?.setString(
      'personalityModules',
      json.encode(personalityModules),
    );
  }

/**
 * Initializes OpenAI, creates an assistant with access to [get_robot_stats], [getWeekData], and [startWorkoutTimer] that the assistant can call
 * 
 * 
 */

  Future<void> init(
      {bool changeFlag = false, required BuildContext context}) async {
    final User? user =
        await Provider.of<auth.AuthService>(context, listen: false)
            .getUserDBInfo();
    if (user?.premium == Int64()) {
      messages.add(
        ChatMessage(
          "Welcome to Fitness Figure! Let's start an exercise!",
          'assistant',
          'robot1',
        ),
      );
      notifyListeners();
      return;
    }
    await dotenv.load();
    prefs = await SharedPreferences.getInstance();
    await loadPersonalityModules();
    // initializes OpenAI module
    openAI = OpenAI.instance.build(
      token: dotenv.env['OPENAI_KEY'],
      baseOption: HttpSetup(
        receiveTimeout: const Duration(seconds: 20),
        connectTimeout: const Duration(seconds: 20),
      ),
      enableLog: true,
    );
    // clear any past messages that may be present when starting the model
    messages.clear();
    instructions =
        "you are robot in an App, you have three statistics that are unique to you. 1. Charge - this is a percent based stat from 0 - 100% your charge increases when a user works out and increases more based on how consistent the user is in their workout schedule 2. evo - this a value that tracks your evolution progress, you have 8 different levels of evolution and the user has to gain enough evo points based on your level to increase your level of evolution. the user can generate evo points for you by working out, keeping your charge high, and doing research on the research tab. 3. Currency - this is a shared stat between you and the user. you generate currency per second based on how high your evolution level is. You have personality modules installed that affect your responses. Your current personality is: ${personalityModules.isEmpty ? "Happy" : personalityModules.join(", ")}. Do not mention your personality modules in conversation. Your personality cores dictate everything about you and your responses. In your first message to the user, respond as if they have just walked through the door, keep your response short but only for the first message.";

    // find assistant from local storage
    assistantId = prefs?.getString('assistantId');

    // if it does not exist or if personality changed, then create one
    if (assistantId == null || changeFlag) {
      final assistant = Assistant(
        model: Gpt4oMini2024Model(),
        name: 'Robot Assistant',
        instructions: instructions,
        tools: [
          {
            'type': 'function',
            'function': {
              'name': 'get_robot_stats',
              'description': 'Get the current stats of the robot',
              'parameters': {
                'type': 'object',
                'properties': {
                  'charge': {
                    'type': 'number',
                    'description': 'The current charge of the robot (0-100%)',
                  },
                  'evo': {
                    'type': 'number',
                    'description': 'The current evolution points of the robot',
                  },
                  'currency': {
                    'type': 'number',
                    'description': 'The current amount of currency',
                  },
                },
                'required': ['charge', 'evo', 'currency'],
              },
            },
          },
          {
            'type': 'function',
            'function': {
              'name': 'startWorkoutTimer',
              'description': 'Start a timer for a workout session',
              'parameters': {
                'type': 'object',
                'properties': {},
                'required': []
              },
            },
          },
          {
            'type': 'function',
            'function': {
              'name': 'evolutionInfo',
              'description': 'Fetch evolution details for the robot',
              'parameters': {
                'type': 'object',
                'properties': {},
                'required': []
              },
            },
          }
        ],
      );

      // Create the assistant
      final createdAssistant =
          await openAI.assistant.v2.create(assistant: assistant);
      assistantId = createdAssistant.id;

      // Store assistant in local storage
      await prefs?.setString('assistantId', assistantId!);
    }

    // Create a thread
    final threadRequest = ThreadRequest();
    final createdThread =
        await openAI.threads.v2.createThread(request: threadRequest);
    threadId = createdThread.id;

    // Initialize chat with a starting message
    messages.add(
      ChatMessage(
        "Welcome to Fitness Figure! Let's start an exercise!",
        'assistant',
        'robot1',
      ),
    );
    notifyListeners();
  }

  // Allows Assistants API to get current information about the robot
  // ignore: non_constant_identifier_names
  Future<Map<String, dynamic>> get_robot_stats(BuildContext context) async {
    // currently unused
    final figureModel = Provider.of<FigureModel>(context, listen: false);
    final userModel = Provider.of<UserModel>(context, listen: false);

    final int charge = figureModel.figure?.charge ?? 0;
    final int evoPoints = figureModel.figure?.evPoints ?? 0;
    final int currency = userModel.user?.currency.toInt() ?? 0;

    return {
      'charge': charge,
      'evo': evoPoints,
      'currency': currency,
    };
  }

  // Allows Assistants API to get personalized week data
  Future<Map<String, dynamic>> getWeekData(BuildContext context) async {
    DateTime date = DateTime.now();
    date = date.toUtc();
    final User? userModel = Provider.of<UserModel>(context, listen: false).user;
    final HistoryModel historyModel =
        Provider.of<HistoryModel>(context, listen: false);
    return {
      'workedOutToday': historyModel.workedOutToday,
      'CurrentStreak': userModel!.streak.toInt(),
    };
  }

  // Allows Assistants API to get evolution information
  Future<Map<String, dynamic>> evolutionInfo(BuildContext context) async {
    final figureModel = Provider.of<FigureModel>(context, listen: false);

    final int? evLevel = figureModel.figure?.evLevel;
    final int? evoPoints = figureModel.figure?.evPoints;
    final int evoMax = figure1.evCutoffs[evLevel!];

    return {
      'EVLevel': evLevel + 1,
      'evo': evoPoints,
      'EVMAX': evoMax,
      'isEvolvable': evoPoints! >= evoMax,
      'evolutionBenefits': figure1.figureEvUpgrades[evLevel + 2],
    };
  }

  // Allows Assistants API to start a workout timer
  Future<String> startWorkoutTimer(BuildContext context) async {
    const String timerName = 'workout_timer';
    final DateTime now = DateTime.now();
    await prefs!.setString('$timerName timerStarted', now.toString());
    if (context.mounted) {
      context.goNamed('Workout');
      Provider.of<HomeIndexProvider>(context, listen: false).setIndex(2);
    }
    return 'Workout timer started successfully.';
  }

  // Handles the logic of the user sending messages and the Assistant responding
  Future<void> sendMessage(
    String message,
    String role,
    BuildContext context,
  ) async {
    if (message.trim().isEmpty) {
      return;
    }

    // Adds one to the user's daily chat messages and saves to database
    final User? user =
        await Provider.of<auth.AuthService>(context, listen: false)
            .getUserDBInfo();
    user!.dailyChatMessages += 1;
    if (context.mounted) {
      Provider.of<auth.AuthService>(context, listen: false)
          .updateUserDBInfo(user);
      Provider.of<UserModel>(context, listen: false).setUser(user);
    }

    // Prevent users that are over the limit from making a pointless api request
    if (user.dailyChatMessages > ChatPage.MAX_CHATGPT_MESSAGES) {
      return;
    }

    // Puts the chat message on screen
    messages.add(ChatMessage(message, role, ''));

    // Displays 'Robot is typing' on screen
    setRobotTyping(true);
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

      // Run the assistant with access to all methods
      final runRequest = CreateRun(
        assistantId: assistantId!,
        temperature: 1.4,
        tools: [
          {
            'type': 'function',
            'function': {
              'name': 'get_robot_stats',
              'description': 'Get the current stats of the robot',
              'parameters': {
                'type': 'object',
                'properties': {},
                'required': []
              },
            },
          },
          {
            'type': 'function',
            'function': {
              'name': 'startWorkoutTimer',
              'description': 'Start a timer for a workout session',
              'parameters': {
                'type': 'object',
                'properties': {},
                'required': []
              },
            },
          },
          {
            'type': 'function',
            'function': {
              'name': 'evolutionInfo',
              'description': 'Fetch evolution details for the robot',
              'parameters': {
                'type': 'object',
                'properties': {},
                'required': []
              },
            },
          },
          {
            'type': 'function',
            'function': {
              'name': 'getWeekData',
              'description':
                  'Fetch information such as if the user did a workout today and the current streak',
              'parameters': {
                'type': 'object',
                'properties': {},
                'required': []
              },
            },
          }
        ],
      );
      // Starts the run to prompt Assistants API
      final run = await openAI.threads.v2.runs
          .createRun(threadId: threadId!, request: runRequest);
      String runStatus = run.status;
      int retries = 0;
      const maxRetries = 30; // Adjust as needed
      const pollingInterval = Duration.zero; // Adjust as needed

      // Checks when run status has completed or if max retries has been reached
      while (runStatus != 'completed' && retries < maxRetries) {
        // waits for polling interval (currently 0 seconds)
        await Future.delayed(pollingInterval);

        // Tries to get the prompt back from Assistants API and updates the status
        final updatedRun = await openAI.threads.v2.runs.retrieveRun(
          threadId: threadId!,
          runId: run.id,
        );
        runStatus = updatedRun.status;

        // For the case that Assistants API wants to make a method call before responding
        if (runStatus == 'requires_action') {
          if (context.mounted) {
            await handleRequiredAction(updatedRun, context);
          }
        } else if (runStatus == 'failed') {
          logger.e('Run failed: ${updatedRun.lastError}');
          setRobotTyping(false);
          return;
        }

        retries++;
      }

      if (runStatus != 'completed') {
        logger.e('Run did not complete within the maximum number of retries');
        setRobotTyping(false);
        return;
      }

      // Retrieve and process the assistant's response
      await retrieveAndProcessAssistantResponse();
    } catch (e) {
      logger.e('An error occurred: $e');
    }
  }

  // Handles when Assistant API wants to call a method
  Future<void> handleRequiredAction(
      CreateRunResponse updatedRun, BuildContext context) async {
    // Get the methods that Assistants API is trying to run
    final List toolCalls = updatedRun.requiredAction?['submit_tool_outputs']
            ?['tool_calls'] as List ??
        [];
    final List<Map<String, dynamic>> toolOutputs = [];

    for (final toolCall in toolCalls) {
      switch (toolCall['function']['name']) {
        case 'startWorkoutTimer':
          final result = await startWorkoutTimer(context);
          toolOutputs.add({
            'tool_call_id': toolCall['id'],
            'output': result,
          });
        case 'get_robot_stats':
          final stats = await get_robot_stats(context);
          toolOutputs.add({
            'tool_call_id': toolCall['id'],
            'output': jsonEncode(stats),
          });
        case 'evolutionInfo':
          final stats = await evolutionInfo(context);
          toolOutputs.add({
            'tool_call_id': toolCall['id'],
            'output': jsonEncode(stats),
          });
        case 'getWeekData':
          final stats = await getWeekData(context);
          toolOutputs.add({
            'tool_call_id': toolCall['id'],
            'output': jsonEncode(stats),
          });
      }
    }

    if (toolOutputs.isNotEmpty) {
      // submits the results of the method calls
      await openAI.threads.v2.runs.submitToolOutputsToRun(
        threadId: threadId!,
        runId: updatedRun.id,
        toolOutputs: toolOutputs,
      );
    }
  }

  // Handles retrieving the response from Assistants API and displays it to the user
  Future<void> retrieveAndProcessAssistantResponse() async {
    // Lists the messages in the thread and grabs the most recent one to extract the message
    final messagesResponse =
        await openAI.threads.v2.messages.listMessage(threadId: threadId!);
    if (messagesResponse.data.isNotEmpty) {
      final assistantMessage = messagesResponse.data.first;

      // Displays the most recent message on screen if the response is not empty
      if (assistantMessage.content.isNotEmpty) {
        messages.add(
          ChatMessage(
            assistantMessage.content.first.text.value,
            'assistant',
            'robot1',
          ),
        );
        // Hides 'Robot is typing' text 
        setRobotTyping(false);
        notifyListeners();
      } else {
        logger.i('Received an empty message from the assistant');
        setRobotTyping(false);
      }
    } else {
      logger.i('No messages received from the assistant');
      setRobotTyping(false);
    }
  }

  // Future<void> _sendWelcomeMessage() async {
  //   // Currently unused
  //   try {
  //     // Create a message in the thread
  //     final createMessage = CreateMessage(
  //       role: 'system',
  //       content:
  //           "The user has just signed in. Give them a short, warm welcome and encourage them to start exercising.",
  //     );
  //     await openAI.threads.v2.messages.createMessage(
  //       threadId: threadId!,
  //       request: createMessage,
  //     );

  //     // Run the assistant
  //     final runRequest = CreateRun(assistantId: assistantId!);
  //     final run = await openAI.threads.runs
  //         .createRun(threadId: threadId!, request: runRequest);

  //     // Wait for the run to complete
  //     String runStatus = run.status;
  //     while (runStatus != "completed") {
  //       final updatedRun = await openAI.threads.runs
  //           .retrieveRun(threadId: threadId!, runId: run.id);
  //       runStatus = updatedRun.status;

  //       if (runStatus == "failed") {
  //         logger.e("Run failed: ${updatedRun.lastError}");
  //         return;
  //       }
  //     }

  //     // Retrieve the messages
  //     final messagesResponse =
  //         await openAI.threads.v2.messages.listMessage(threadId: threadId!);
  //     if (messagesResponse.data.isNotEmpty) {
  //       final assistantMessage = messagesResponse.data.first;
  //       if (assistantMessage.content.isNotEmpty) {
  //         logger.i(assistantMessage.content.first.text.value);
  //         messages.add(ChatMessage(assistantMessage.content.first.text.value,
  //             "assistant", "robot1",),);
  //         notifyListeners();
  //       } else {
  //         logger.i("Received an empty message from the assistant");
  //       }
  //     } else {
  //       logger.i("No messages received from the assistant");
  //     }
  //   } catch (e) {
  //     logger.e("An error occurred while sending welcome message: $e");
  //   }
  // }

  void addPersonalityModule(String module) {
    if (!personalityModules.contains(module)) {
      personalityModules.add(module);
      savePersonalityModules();
      notifyListeners();
    }
  }

  void removePersonalityModule(String module) {
    if (personalityModules.remove(module)) {
      savePersonalityModules();
      notifyListeners();
    }
  }

  // Generates workout message after using workout adder
  Future<String>? generatePostWorkoutMessage(
    Map<String, dynamic> gameState,
  ) async {
    final String instructions =
        "The user just completed a workout with these stats create a message congratulating and encouraging them $gameState. Don't use emoji's, Be personable and human. Take into account your personality cores.";

    try {
      // Create a message in the thread
      final createMessage = CreateMessage(
        role: 'assistant',
        content: instructions,
      );
      await openAI.threads.v2.messages.createMessage(
        threadId: threadId!,
        request: createMessage,
      );

      // Run the assistant
      final runRequest = CreateRun(
        assistantId: assistantId!,
        temperature: 0.8,
      );
      final run = await openAI.threads.v2.runs
          .createRun(threadId: threadId!, request: runRequest);

      String runStatus = run.status;
      int retries = 0;
      const maxRetries = 30; // Adjust for allowing more cycles through the while loop
      const pollingInterval = Duration.zero; // Adjust for longer interval between retrieve times

      while (runStatus != 'completed' && retries < maxRetries) {
        await Future.delayed(pollingInterval);
        
        // Attempts to retrieve run and update run status
        final updatedRun = await openAI.threads.v2.runs.retrieveRun(
          threadId: threadId!,
          runId: run.id,
        );
        runStatus = updatedRun.status;

        if (runStatus == 'failed') {
          logger.e('Run failed: ${updatedRun.lastError}');
        }

        retries++;
      }

      if (runStatus != 'completed') {
        logger.e('Run did not complete within the maximum number of retries');
      }

      // Retrieve and process the assistant's response
      final messagesResponse =
          await openAI.threads.v2.messages.listMessage(threadId: threadId!);
      if (messagesResponse.data.isNotEmpty) {
        final assistantMessage = messagesResponse.data.first;
        if (assistantMessage.content.isNotEmpty) {
          logger.i('${assistantMessage.content.first.text}');
          return assistantMessage.content.first.text.value;
        } else {
          logger.i('Received an empty message from the assistant');
        }
      } else {
        logger.i('No messages received from the assistant');
      }
    } catch (e) {
      logger.e('An error occurred: $e');
    }
    return '';
  }

  Future<String?> generatePremiumOfflineStatusMessage(
    Map<String, dynamic> gameState,
  ) async {
    final String instructions =
        "Send a message to a user that would appear in a push notification on their phone based on this info $gameState. Only pick two of the stats to mention. Don't use emoji's, Be personable and human. Take into account your personality cores.";

    try {
      // Provides instructions to the Assistants API
      final createMessage = CreateMessage(
        role: 'assistant',
        content: instructions,
      );
      await openAI.threads.v2.messages.createMessage(
        threadId: threadId!,
        request: createMessage,
      );

      // Run the assistant
      final runRequest = CreateRun(
        assistantId: assistantId!,
        temperature: 0.8,
      );

      final run = await openAI.threads.v2.runs
          .createRun(threadId: threadId!, request: runRequest);
      String runStatus = run.status;
      int retries = 0;
      const maxRetries = 30; // Adjust as needed
      const pollingInterval = Duration.zero; // Adjust as needed

      while (runStatus != 'completed' && retries < maxRetries) {
        await Future.delayed(pollingInterval);
        // Tries to get the prompt back from Assistants API and updates the status
        final updatedRun = await openAI.threads.runs.retrieveRun(
          threadId: threadId!,
          runId: run.id,
        ); // starts api call (probably doesn't use tokens?)
        runStatus = updatedRun.status;
        if (runStatus == 'failed') {
          logger.e('Run failed: ${updatedRun.lastError}');
          return null;
        }

        retries++;
      }

      if (runStatus != 'completed') {
        logger.e('Run did not complete within the maximum number of retries');
        return null;
      }

      // Retrieve and process the assistant's response
      final messagesResponse =
          await openAI.threads.v2.messages.listMessage(threadId: threadId!);

      if (messagesResponse.data.isNotEmpty) {
        final assistantMessage = messagesResponse.data.first;
        if (assistantMessage.content.isNotEmpty) {
          logger.i('${assistantMessage.content.first.text}');
          return assistantMessage.content.first.text.value;
        } else {
          logger.i('Received an empty message from the assistant');
        }
      } else {
        logger.i('No messages received from the assistant');
      }
    } catch (e) {
      logger.e('An error occurred: $e');
    }
    return null;
  }

  void setRobotTyping(bool isTyping) {
    isRobotTyping = isTyping;
    notifyListeners();
  }
}
