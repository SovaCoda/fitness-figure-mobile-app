import 'package:ffapp/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:ffapp/services/flutterUser.dart';
import 'package:provider/provider.dart';
import 'package:ffapp/services/routes.pb.dart' as Routes;
import 'package:ffapp/main.dart';
import "package:firebase_auth/firebase_auth.dart" as FB;
import 'package:fixnum/fixnum.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  void emptyFunction() {}

  late AuthService auth;
/*
  Future<void> initAuthService() async {
    auth = await AuthService.instance;
    logger.i("AuthService initialized");
  }
*/
  FlutterUser user = FlutterUser();
  late String name = "Loading...";
  late String email = "Loading...";
  late String password = "Loading...";
  late int weeklyGoal = 0;
  late String manageSub = "Loading...";

  @override
  void initState() {
    super.initState();
    auth = Provider.of<AuthService>(context, listen: false);
    initialize();
  }

  void initialize() async {
    Routes.User? databaseUser = await auth.getUserDBInfo();
    if (mounted) {
      Provider.of<UserModel>(context, listen: false).setUser(databaseUser!);
    }
    String curName = databaseUser?.name ?? "Loading...";
    if (curName == "") {
      curName = "No name given";
    }
    String curEmail = databaseUser?.email ?? "Loading...";
    int curGoal = databaseUser?.weekGoal.toInt() ?? 0;
//  Remove comment when premium is added
//  bool premiumStatus = databaseUser?.premium ?? false;
    setState(() {
      name = curName;
      email = curEmail;
      password = "*******";
      weeklyGoal = curGoal;
      manageSub = "Subscription Tier 1";
//    Remove comment when premium is added
//    manageSub = premiumStatus ? "Subscription Tier 1" : "Regular User"
    });
  }

  void updateName(String name) async {
    await auth.updateName(name);
  }

Future<void> updateEmail(String userEmail, String userPassword, String newEmail) async {
  try {
    // Create credential because updateEmail requires recent authorization
    AuthCredential credential = EmailAuthProvider.credential(email: userEmail, password: userPassword);
    await auth.updateEmail(userEmail, newEmail, credential); // sends email to the new email to verify the change in email

    signOut(context);
    GoRouter.of(context).go("/");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Success! Please sign back in.")),
    );

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
  }
}

Future<void> updatePassword(String userEmail, String userPassword, String newPassword) async {
  // Create credential because updatePassword requires recent authorization
  try {
  AuthCredential credential = EmailAuthProvider.credential(email: userEmail, password: userPassword); 
  await auth.updatePassword(newPassword, credential);
  signOut(context);
  GoRouter.of(context).go("/");
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Success! Please sign back in.")),
    );
  }
  catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
  }
}



  void updateWeeklyGoal(int goal) async {
    await auth.updateWeeklyGoal(goal);
    Provider.of<UserModel>(context, listen: false).setUserWeekGoal(Int64(goal));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Profile",
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(255),
                )),
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
          onInputChange: (newEmail) async {
            final userPassword = await showDialog<String>(
              context: context,
              builder: (BuildContext context) {
                return const getUserCredentials();
              },
            );
            logger.i("Changing user name to $newEmail");
            updateEmail(email, userPassword!, newEmail);
            setState(() {
              email = newEmail;
            });
          },
        ),
        SettingsBar(
          onTapFunction: emptyFunction,
          name: "Password: $password",
          onInputChange: (newPassword) async {
            final userPassword = await showDialog<String>(
              context: context,
              builder: (BuildContext context) {
                return const getUserCredentials();
              },
            );
            updatePassword(email, userPassword!, newPassword);
          }
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
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 50,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: const Border(
                bottom: BorderSide(color: Colors.black),
                top: BorderSide(color: Colors.black),
              )),
          child: Center(
            child: Text(
              "Subscription: $manageSub",
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: Theme.of(context).colorScheme.onError),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // SettingsBar(
        //   onTapFunction: emptyFunction,
        //   name: "Subscription: $manageSub",
        // ),
        GestureDetector(
          onTap: () {
            signOut(context);
            GoRouter.of(context).go("/");
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 50,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: const Border(
                  bottom: BorderSide(color: Colors.black),
                  top: BorderSide(color: Colors.black),
                )),
            child: Center(
              child: Text(
                'Sign Out',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: Theme.of(context).colorScheme.onError),
              ),
            ),
          ),
        )
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
                return const InputDialog();
              },
            );
            if (result != null) {
              onInputChange!(result);
            }
          } else {
            onTapFunction();
          }
        },
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 50,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: const Border(
                  bottom: BorderSide(color: Colors.black),
                  top: BorderSide(color: Colors.black),
                )),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                name,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: Theme.of(context).colorScheme.onError),
              ),
              const SizedBox(width: 10),
              Icon(
                Icons.edit,
                color: Theme.of(context).colorScheme.primary,
              )
            ]),
          ),
        ),
      ),
      const SizedBox(height: 5)
    ]);
  }
}

// When tapped, opens a dialogue box to allow user to input text

class InputDialog extends StatelessWidget {
  const InputDialog({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return AlertDialog(
      title: const Text('Enter New Value'),
      content: TextField(
        autofocus: true,
        controller: controller,
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Save'),
          onPressed: () {
            Navigator.of(context).pop(controller.text);
          },
        ),
      ],
    );
  }
}

class getUserCredentials extends StatelessWidget {
  const getUserCredentials({super.key});


  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();


  return AlertDialog(
    title: const Text('This requires extra authentication. Please enter your password.'),
    content: TextField(
      autofocus: true,
      controller: controller,
    ),
    actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Continue'),
          onPressed: () {
            Navigator.of(context).pop(controller.text);
          },
        ),
      ],
  );
  }
}

Future<void> signOut(BuildContext context) async {
  Provider.of<UserModel>(context, listen: false).setUser(Routes.User());
  await FirebaseAuth.instance.signOut();
}
