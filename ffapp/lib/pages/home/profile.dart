import 'package:ffapp/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:ffapp/services/flutterUser.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  void emptyFunction() {}

  late AuthService auth;

  Future<void> initAuthService() async {
    auth = await AuthService.instance;
    logger.i("AuthService initialized");
  }

  FlutterUser user = FlutterUser();
  late String name = "Loading...";
  late String email = "Loading...";
  late String password = "Loading...";
  late int weeklyGoal = 0;
  late String manageSub = "Loading...";

  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    await initAuthService();
    await user.initAuthService();
    await user.checkUser();
    String usrName = await user.getName();
    int usrGoal = await user.getWorkoutGoal();
    setState(() {
      name = usrName;
      password = "*******";
      weeklyGoal = usrGoal;
      manageSub = "Subscription Tier 1";
    });
  }

  void updateName(String name) async {
    await auth.updateName(name);
  }

  void updateEmail(String email) async {
    await auth.updateEmail(email);
  }

  void updateWeeklyGoal(int goal) async {
    await auth.updateWeeklyGoal(goal);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Profile",
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              )
        ),
        const SizedBox(height: 20),
        SettingsBar(
          name: "Name: $name",
          onTapFunction: emptyFunction,
          onInputChange: (newName) {
            setState(() {
              name = newName;
            });
            logger.i("Changing user name to $name");
            updateName(name);
          },
        ),
        SettingsBar(
          onTapFunction: emptyFunction,
          name: "Email: $email",
          onInputChange: (newEmail) {
            setState(() {
              email = newEmail;
            });
            logger.i("Changing user name to $email");
            updateEmail(email);
          },
        ),
        SettingsBar(
          onTapFunction: emptyFunction,
          name: "Password: $password",
        ),
        SettingsBar(
          onTapFunction: emptyFunction,
          name: "Workout Goal: $weeklyGoal",
          onInputChange: (newGoal) {
            setState(() {
              weeklyGoal = int.parse(newGoal);
            });
            logger.i("Changing user name to $weeklyGoal");
            updateWeeklyGoal(weeklyGoal);
          },
        ),
        SettingsBar(
          onTapFunction: emptyFunction,
          name: "Subscription: $manageSub",
        ),
        TextButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          ),
          onPressed: () {
            signOut();
            context.goNamed('SignIn');
          },
          child: Text('Sign Out'),
        ),
      ],
    );
  }
}

class SettingsBar extends StatelessWidget {
  const SettingsBar({
    super.key,
    required this.onTapFunction,
    required this.name,
    this.onInputChange,
  });

  final Function onTapFunction;
  final String name;
  final Function(String)? onInputChange;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      InkWell(
        //when this setting bar is clicked callback the function given as an input to the class
        onTap: () async {
          if (onInputChange != null) {
            final result = await showDialog<String>(
              context: context,
              builder: (BuildContext context) {
                return InputDialog();
              },
            );
            if (result != null) {
              onInputChange!(result);
            }
          } else {
            onTapFunction();
          }
        },
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              border: Border(
                bottom: BorderSide(color: Colors.black),
                top: BorderSide(color: Colors.black),
              )),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant
              ),
            ),
            const SizedBox(width: 10),
            Icon(
              Icons.edit,
              color: Theme.of(context).colorScheme.primary,
            )
          ]),
        ),
      ),
      const SizedBox(height: 5)
    ]);
  }
}

// When tapped, opens a dialogue box to allow user to input text

class InputDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController();

    return AlertDialog(
      title: Text('Enter New Value'),
      content: TextField(
        autofocus: true,
        controller: _controller,
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Save'),
          onPressed: () {
            Navigator.of(context).pop(_controller.text);
          },
        ),
      ],
    );
  }
}

Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
}
