import 'package:ffapp/components/custom_button.dart';
import 'package:ffapp/components/sqaure_tile.dart';
import 'package:ffapp/components/Input_field.dart';
import 'package:ffapp/services/auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function()? onTap;
  const SignIn({super.key, required this.onTap});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService auth = AuthService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signIn() async {}

  void createAccount(){

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
                  Icons.lock_person,
                  size: 150,
                ),

                //spacer
                const SizedBox(height: 25),

                InputField(
                  controller: emailController,
                  hintText: 'Username or email',
                  obscureText: false,
                ),

                //spacer
                const SizedBox(height: 15),

                //password
                InputField(
                  controller: passwordController,
                  hintText: 'password',
                  obscureText: false,
                ),

                //spacer
                const SizedBox(height: 5),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                    'Get help logging in.',
                    style: TextStyle(
                      color: Colors.blue.shade900,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ) ,
                  )  
                  
                ),

                //spacer
                const SizedBox(height: 15),

                //Sign In
                CustomButton(onTap: signIn, text: "Sign In"),

                //spacer
                const SizedBox(height: 15),

                //create account
                CustomButton(onTap: widget.onTap, text: "Create Account"),

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
