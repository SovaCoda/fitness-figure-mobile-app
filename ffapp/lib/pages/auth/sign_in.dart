import 'package:ffapp/components/custom_button.dart';
import 'package:ffapp/components/sqaure_tile.dart';
import 'package:ffapp/components/Input_field.dart';
import 'package:ffapp/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
    auth = await AuthService.instance;
    logger.i("AuthService initialized");
  }

  Future<void> checkUser() async {
    logger.i("Checking User Status");
    User? user = await auth.getUser();
    if (user != null) {
      logger.i("User is signed in");
      context.goNamed('Home');
    }
    logger.i("User is not signed in");
  }

  void signIn() async {
    logger.i("signing in");
    var user = await auth.signIn(
      emailController.text,
      passwordController.text,
    );
    if (user != null) {
      if (user is String) {
        logger.e(user);
      } else if (user is User) {
        String email = emailController.text;
        logger.i("$email is signed in");
        context.goNamed('LandingPage');
      }
    } else {
      logger.i("Invalid email/password.");
      showSnackBar(context, "Invalid email or password! Please try again.");
    }
  }

  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text),
      duration: Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger auth flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Auth details from request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // After sign in, return UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
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
                  width: 350,
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
                  obscureText: true,
                ),

                //spacer
                const SizedBox(height: 5),

                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                      alignment: Alignment.center,
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
                  child: CustomButton(onTap: signIn, text: "Sign In"),
                ),

                //spacer
                const SizedBox(height: 15),

                //create account
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: CustomButton(
                      onTap: () => context.goNamed('Register'),
                      text: "Create Account"),
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
                      onTap: () {
                        print("Pressed Google!");
                        signInWithGoogle();
                      },
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
