import 'package:ffapp/pages/wapper.dart';
import 'package:ffapp/routes.dart';
import 'package:ffapp/services/routes.pbgrpc.dart' as routes;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  RoutesService.instance.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAuth auth = FirebaseAuth.instance;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Wrapper(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void initState() {
    super.initState();
    
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        print('User is currently signed out');
      } else {
        print('User is signed in');
      }
    });
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  var test = "defualt";
  var email = "null";
  var pass = "null";

  Future<void> GetUser() async {
    try {
      routes.User user = routes.User(email: "Buford@BDBusiness.com");

      var response = await RoutesService.instance.routesClient.getUser(user);
      setState(() {
        test = response.email;
      });
    } on GrpcError catch (e) {
      print('Caught error: $e');
    } catch (e) {
      print('Caught error: $e');
    }
  }

  Future<void> CreateUser(String email, String pass) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: 'chb263@msstate.edu', password: 'bananacrisis23');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
              ),
              onChanged: (value) {
                // Store the email input value
                email = value;
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              onChanged: (value) {
                // Store the password input value
                pass = value;
              },
            ),
            ElevatedButton(
              onPressed: () {
                CreateUser(email, pass);
                print("User created with creds: $email, $pass");
                // Perform account creation logic using the stored email and password values
              },
              child: Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}
