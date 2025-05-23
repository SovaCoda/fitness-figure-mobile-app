import 'package:ffapp/components/utils/chat_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PersonalityModule {
  final String name;
  final IconData icon;

  PersonalityModule({required this.name, required this.icon});
}

class EditPersonalityPage extends StatefulWidget {
  const EditPersonalityPage({super.key});

  @override
  EditPersonalityPageState createState() => EditPersonalityPageState();
}

class EditPersonalityPageState extends State<EditPersonalityPage> {
  final List<PersonalityModule> modules = [
    PersonalityModule(name: 'Happy', icon: Icons.sentiment_very_satisfied),
    PersonalityModule(name: 'Sad', icon: Icons.sentiment_very_dissatisfied),
    PersonalityModule(name: 'Angry', icon: Icons.mood_bad),
    PersonalityModule(name: 'Excited', icon: Icons.celebration),
    PersonalityModule(name: 'Calm', icon: Icons.spa),
    PersonalityModule(name: 'Curious', icon: Icons.psychology),
    PersonalityModule(name: 'Shy', icon: Icons.face),
    PersonalityModule(name: 'Confident', icon: Icons.self_improvement),
    PersonalityModule(name: 'Playful', icon: Icons.toys),
    PersonalityModule(name: 'Serious', icon: Icons.work),
    PersonalityModule(name: 'Empathetic', icon: Icons.favorite),
    PersonalityModule(name: 'Analytical', icon: Icons.analytics),
  ];

  late List<String> initialPersonalityModules;

  @override
  void initState() {
    super.initState();
    final chatModel = Provider.of<ChatModel>(context, listen: false);
    initialPersonalityModules = List.from(chatModel.personalityModules);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Personality Modules'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              final chatModel = Provider.of<ChatModel>(context, listen: false);
              await chatModel.savePersonalityModules(); // Save before navigating
              if(context.mounted) context.go('/chat');
              if(!listEquals(initialPersonalityModules, chatModel.personalityModules)) {
                if(context.mounted) chatModel.init(changeFlag: true, context: context);
              }
              
            },
          ),
        ],
      ),
      body: Consumer<ChatModel>(
        builder: (context, chatModel, child) {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: modules.length,
            itemBuilder: (context, index) {
              final module = modules[index];
              final isSelected = chatModel.personalityModules.contains(module.name);
              return InkWell(
                onTap: () {
                  if (isSelected) {
                    chatModel.removePersonalityModule(module.name);
                  } else {
                    chatModel.addPersonalityModule(module.name);
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isSelected ? Theme.of(context).primaryColor : null,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: isSelected ? const Offset(0, 2) : Offset.zero,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        module.icon,
                        size: 48,
                        color: isSelected ? Colors.white : null,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        module.name,
                        style: TextStyle(
                          fontSize: 20,
                          color: isSelected ? Colors.white : null,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
