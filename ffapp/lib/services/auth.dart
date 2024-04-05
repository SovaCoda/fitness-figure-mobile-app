import "package:ffapp/services/google/protobuf/empty.pb.dart";
import "package:ffapp/services/routes.pb.dart" as Routes;
import "package:firebase_auth/firebase_auth.dart" as FB;
import "package:firebase_core/firebase_core.dart";
import "package:ffapp/firebase_options.dart";
import 'package:ffapp/routes.dart';
import 'package:logger/logger.dart';
import 'package:fixnum/fixnum.dart';

var logger = Logger();

class AuthService {
  final FB.FirebaseAuth _auth; // firebase backend instance
  final RoutesService _routes; // routes service instance
  // both not initialized to begin with, only when AuthService.init() is called

  AuthService._(this._auth, this._routes);

  static AuthService? _instance;

  static Future<AuthService> get instance async {
    if (_instance == null) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      FB.FirebaseAuth _auth = FB.FirebaseAuth.instance;

      await RoutesService.instance.init();
      logger.i("RoutesService initialized");
      RoutesService _routes = RoutesService.instance;

      _instance = AuthService._(_auth, _routes);
    }
    return _instance!;
  }

  Future<FB.User?> createUser(String email, String password) async {
    try {
      Routes.User user = Routes.User(email: email);
      await _routes.routesClient.createUser(user);

      FB.UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user;
    } on FB.FirebaseAuthException catch (e) {
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
      FB.UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FB.FirebaseAuthException catch (e) {
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

  Future<FB.User?> getUser() async {
    return _auth.currentUser;
  }

  Future<Routes.User?> getUserDBInfo() async {
    FB.User? currentUser = _auth.currentUser;
    Routes.User user = Routes.User(email: currentUser!.email);
    return await _routes.routesClient.getUser(user);
  }

  Future<Routes.User> updateUserDBInfo(Routes.User user) async {
    user.email = _auth.currentUser!.email!;
    return await _routes.routesClient.updateUser(user);
  }

  Future<void> deleteUser() async {
    await _auth.currentUser?.delete();
  }

  Future<Routes.Workout> createWorkout(Routes.Workout workout) async {
    return await _routes.routesClient.createWorkout(workout);
  }

  Future<Routes.Workout> updateWorkout(Routes.Workout workout) async {
    return await _routes.routesClient.updateWorkout(workout);
  }

  Future<void> deleteWorkout(Routes.Workout workout) async {
    await _routes.routesClient.deleteWorkout(workout);
  }

  Future<Routes.MultiWorkout> getWorkouts() async {
    FB.User? currentUser = _auth.currentUser;
    Routes.User user = Routes.User(email: currentUser!.email);
    return await _routes.routesClient.getWorkouts(user);
  }

  Future<Routes.Workout> getWorkout(Routes.Workout workout) async {
    return await _routes.routesClient.getWorkout(workout);
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

  Future<void> updateName(String name) async {
    FB.User? currentUser = _auth.currentUser;
    Routes.User user = Routes.User(email: currentUser!.email);
    user.name = name;
    await _routes.routesClient.updateUser(user);
  }

  Future<void> updateWeeklyGoal(int goal) async {
    FB.User? currentUser = _auth.currentUser;
    Routes.User user = Routes.User(email: currentUser!.email);
    Int64 goal64 = Int64(goal);
    user.weekGoal = goal64;
    await _routes.routesClient.updateUser(user);
  }

  Future<void> updateCurrency(int currency) async {
    FB.User? currentUser = _auth.currentUser;
    Routes.User user = Routes.User(email: currentUser!.email);
    Int64 currency64 = Int64(currency);
    user.currency = currency64;
    await _routes.routesClient.updateUser(user);
  }

  Future<Routes.Figure> getFigure(Routes.Figure figure) async {
    try {
      return await _routes.routesClient.getFigure(figure);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to get figure");
    }
  }

  Future<Routes.Figure> updateFigure(Routes.Figure figure) async {
    try {
      return await _routes.routesClient.updateFigure(figure);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to update figure");
    }
  }

  Future<Routes.Figure> createFigure(Routes.Figure figure) async {
    try {
      return await _routes.routesClient.createFigure(figure);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to create figure");
    }
  }

  Future<Routes.Figure> deleteFigure(Routes.Figure figure) async {
    try {
      return await _routes.routesClient.deleteFigure(figure);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to delete figure");
    }
  }

  Future<Routes.MultiFigure> getFigures() async {
    try {
      return await _routes.routesClient.getFigures(Empty());
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to get figures");
    }
  }
  
  Future<Routes.FigureInstance> getFigureInstance(Routes.FigureInstance figureInstance) async {
    try {
      return await _routes.routesClient.getFigureInstance(figureInstance);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to get figure instance");
    }
  }

  Future<Routes.FigureInstance> updateFigureInstance(Routes.FigureInstance figureInstance) async {
    try {
      return await _routes.routesClient.updateFigureInstance(figureInstance);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to update figure instance");
    }
  }

  Future<Routes.FigureInstance> createFigureInstance(Routes.FigureInstance figureInstance) async {
    try {
      return await _routes.routesClient.createFigureInstance(figureInstance);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to create figure instance");
    }
  }

  Future<Routes.FigureInstance> deleteFigureInstance(Routes.FigureInstance figureInstance) async {
    try {
      return await _routes.routesClient.deleteFigureInstance(figureInstance);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to delete figure instance");
    }
  }

  Future<Routes.MultiFigureInstance> getFigureInstances(Routes.User user) async {
    try {
      return await _routes.routesClient.getFigureInstances(user);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to get figure instances");
    }
  }

  // SKIN METHODS //
  Future<Routes.Skin> getSkin(Routes.Skin skin) async {
    try {
      return await _routes.routesClient.getSkin(skin);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to get skin");
    }
  }

  Future<Routes.MultiSkin> getSkins() async {
    try {
      return await _routes.routesClient.getSkins(Empty());
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to get skins");
    }
  }

  Future<Routes.Skin> updateSkin(Routes.Skin skin) async {
    try {
      return await _routes.routesClient.updateSkin(skin);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to update skin");
    }
  }

  Future<Routes.Skin> createSkin(Routes.Skin skin) async {
    try {
      return await _routes.routesClient.createSkin(skin);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to create skin");
    }
  }

  Future<Routes.Skin> deleteSkin(Routes.Skin skin) async {
    try {
      return await _routes.routesClient.deleteSkin(skin);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to delete skin");
    }
  }

  Future<Routes.SkinInstance> getSkinInstance(Routes.SkinInstance skinInstance) async {
    try {
      return await _routes.routesClient.getSkinInstance(skinInstance);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to get skin instance");
    }
  }

  Future<Routes.SkinInstance> updateSkinInstance(Routes.SkinInstance skinInstance) async {
    try {
      return await _routes.routesClient.updateSkinInstance(skinInstance);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to update skin instance");
    }
  }

  Future<Routes.SkinInstance> createSkinInstance(Routes.SkinInstance skinInstance) async {
    try {
      return await _routes.routesClient.createSkinInstance(skinInstance);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to create skin instance");
    }
  }

  Future<Routes.SkinInstance> deleteSkinInstance(Routes.SkinInstance skinInstance) async {
    try {
      return await _routes.routesClient.deleteSkinInstance(skinInstance);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to delete skin instance");
    }
  }

  Future<Routes.MultiSkinInstance> getSkinInstances(Routes.User user) async {
    try {
      return await _routes.routesClient.getSkinInstances(user);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to get skin instances");
    }
  }
  // END SKIN METHODS //
}
