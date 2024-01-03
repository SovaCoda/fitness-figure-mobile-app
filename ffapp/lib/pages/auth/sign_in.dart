import 'package:ffapp/components/custom_button.dart';
import 'package:ffapp/components/sqaure_tile.dart';
import 'package:ffapp/components/Input_field.dart';
import 'package:ffapp/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late AuthService auth;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    await initAuthService();
    await checkUser();
  }

  Future<void> initAuthService() async {
    auth = await AuthService.init();
    logger.i("AuthService initialized");
  }

  Future<void> checkUser() async {
    logger.i("Checking User Status");
    User? user = await auth.getUser();
    if (user != null) {
      logger.i("User is signed in");
    }
    logger.i("User is not signed in");
  }

  void signIn() async {
    logger.i("signing in");
    auth = await AuthService.init();
    var user = await auth.signIn(
      emailController.text,
      passwordController.text,
    );
    logger.i("user is $user");
    if (user is String) {
      logger.e(user);
    } else if (user is User) {
      logger.i("user is signed in");
    }
  }

  void createAccount() {}

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
                const SizedBox(height: 20),

                SvgPicture.asset(
                  "lib/assets/icons/fflogo.svg",
                  height: 350,
                  width: 350,),

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
                  obscureText: true,
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
                      ),
                    )),

                //spacer
                const SizedBox(height: 15),

                //Sign In
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: CustomButton(onTap: signIn, text: "Sign In") ,
                ),
                

                //spacer
                const SizedBox(height: 15),

                //create account
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: CustomButton(onTap: () => context.goNamed('Register'), text: "Create Account"),
                ),

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
