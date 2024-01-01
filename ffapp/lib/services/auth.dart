import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_core/firebase_core.dart";
import "package:ffapp/firebase_options.dart";
import 'package:ffapp/routes.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance; // access to our firebase backend
  final RoutesService _routes = RoutesService.instance; // access to our mysql backend

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseAuth auth = FirebaseAuth.instance;
  }

}
