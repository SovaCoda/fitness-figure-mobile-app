import 'package:ffapp/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:ffapp/components/custom_button.dart';
import 'package:ffapp/components/sqaure_tile.dart';
import 'package:ffapp/components/Input_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late AuthService auth;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final password2Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    await initAuthService();
  }

  Future<void> initAuthService() async {
    auth = await AuthService.instance;
    logger.i("AuthService initialized");
  }

  void createUser() async {
    logger.i("signing up");

    bool passwordMatch = passwordController.text == password2Controller.text;
    if (!passwordMatch) {
      logger.e("passwords do not match");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Passwords do not match! Please try again.")));
      passwordController.clear();
      password2Controller.clear();
      return;
    }

    var user = await auth.createUser(
      emailController.text,
      passwordController.text,
    );
    logger.i("user is $user");
    if (user is String) {
      logger.e(user);
    } else if (user is User) {
      logger.i("user is created");
      context.goNamed('SignIn');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("An account already exists with this email.")));
    }
  }

  void reroute() {
    context.goNamed('SignIn');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                //spacer
                const SizedBox(height: 50),

                //logo
                const Icon(
                  Icons.lock,
                  size: 150,
                ),

                //spacer
                const SizedBox(height: 25),

                InputField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                //spacer
                const SizedBox(height: 15),

                //password
                InputField(
                  controller: passwordController,
                  hintText: 'password',
                  obscureText: true,
                ),

                //spacer
                const SizedBox(height: 15),

                InputField(
                  controller: password2Controller,
                  hintText: 'comfirm password',
                  obscureText: true,
                ),

                //spacer
                const SizedBox(height: 15),

                //Sign In
                CustomButton(onTap: createUser, text: "Create Account"),

                //Spacer
                const SizedBox(height: 20),

                //back to login
                CustomButton(onTap: reroute, text: "Back to Login"),

                //spacer
                const SizedBox(
                  height: 10,
                ),

                // OR
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Text(
                          'OR',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),

                //spacer
                const SizedBox(height: 40),

                // Google or Apple
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //google buttom
                    SquareTile(
                      onTap: () {},
                      imagePath: 'lib/assets/icons/google.svg',
                      height: 90,
                    ),

                    const SizedBox(width: 20),
                    // apple buttom
                    SquareTile(
                      onTap: () {},
                      imagePath: 'lib/assets/icons/apple.svg',
                      height: 60,
                    ),
                  ],
                ),
              ])),
        ),
      ),
    );
  }
}
