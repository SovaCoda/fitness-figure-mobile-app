import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  void emptyFunction() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Profile",
          style: TextStyle(
              fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        SettingsBar(
          name: "User Name",
          onTapFunction: emptyFunction,
        ),
        SettingsBar(
          onTapFunction: emptyFunction,
          name: "Email",
        ),
        SettingsBar(
          onTapFunction: emptyFunction,
          name: "Password",
        ),
        SettingsBar(
          onTapFunction: emptyFunction,
          name: "Change Workout Goal",
        ),
        SettingsBar(
          onTapFunction: emptyFunction,
          name: "Manage Subscription",
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
  });

  final Function onTapFunction;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      InkWell(
        //when this setting bar is clicked callback the function given as an input to the class
        onTap: () {
          onTapFunction();
        },
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.black),
                top: BorderSide(color: Colors.black),
              )),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black87),
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.edit,
              color: Colors.black,
            )
          ]),
        ),
      ),
      const SizedBox(height: 5)
    ]);
  }
}

Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
}
