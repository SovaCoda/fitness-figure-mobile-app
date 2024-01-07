import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
      ),
      onPressed: () {
        signOut();
        context.goNamed('SignIn');
      },
      child: Text('Sign Out'),
    );
  }
}

Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
}
