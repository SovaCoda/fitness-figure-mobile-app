import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_core/firebase_core.dart";
import "package:ffapp/firebase_options.dart";
import 'package:ffapp/routes.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class AuthService {
  final FirebaseAuth _auth; // firebase backend instance
  final RoutesService _routes; // routes service instance
  // both not initialized to begin with, only when AuthService.init() is called

  AuthService._(this._auth, this._routes);

  static AuthService? _instance;

  static Future<AuthService> get instance async {
    if (_instance == null) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      FirebaseAuth _auth = FirebaseAuth.instance;

      await RoutesService.instance.init();
      RoutesService _routes = RoutesService.instance;

      _instance = AuthService._(_auth, _routes);
    }
    return _instance!;
  }

  Future<User?> createUser(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        logger.e("The password provided is too weak.");
      } else if (e.code == "email-already-in-use") {
        logger.e("The account already exists for that email.");
      }
    } catch (e) {
      logger.e(e);
    }
    return null;
  }

  Future<dynamic> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        return "No user found for that email.";
      } else if (e.code == "wrong-password") {
        return "Wrong password provided for that user.";
      }
    } catch (e) {
      return e.toString();
    }
    return null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<User?> getUser() async {
    return _auth.currentUser;
  }

  Future<void> deleteUser() async {
    await _auth.currentUser?.delete();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> updateEmail(String email) async {
    await _auth.currentUser?.updateEmail(email);
  }

  Future<void> updatePassword(String password) async {
    await _auth.currentUser?.updatePassword(password);
  }
}
