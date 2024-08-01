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
      FB.FirebaseAuth auth = FB.FirebaseAuth.instance;

      await RoutesService.instance.init();
      logger.i("RoutesService initialized");
      RoutesService routes = RoutesService.instance;

      _instance = AuthService._(auth, routes);
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
  if (currentUser == null) {
    throw Exception("No user is currently signed in.");
  }
  Routes.User user = Routes.User(email: currentUser.email);
  return await _routes.routesClient.getUser(user);
}

  Future<Routes.User> updateUserDBInfo(Routes.User user) async {
    user.email = _auth.currentUser!.email!;
    return await _routes.routesClient.updateUser(user);
  }

  Future<void> updateEmail(String oldEmail, String newEmail, FB.AuthCredential credential) async {
  try {
    await _auth.currentUser?.reauthenticateWithCredential(credential);
    await _auth.currentUser?.verifyBeforeUpdateEmail(newEmail);
    await _auth.currentUser?.reload();
    Routes.User updatedUser = await _routes.routesClient.updateUserEmail(
      Routes.UpdateEmailRequest(oldEmail: oldEmail, newEmail: newEmail)
    );
    print("Email updated successfully to: ${updatedUser.email}");
  } catch (e) {
    print("Error updating email: $e");
    rethrow;
  }
}

  Future<void> deleteUser() async {
    await _auth.currentUser?.delete();
    await _routes.routesClient.deleteUser(Routes.User(email: _auth.currentUser!.email!));
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



  Future<void> updatePassword(String password, credential) async {
    await _auth.currentUser?.reauthenticateWithCredential(credential);
    await _auth.currentUser?.updatePassword(password);
    await _auth.currentUser?.reload();
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

  Future<Routes.FigureInstance> getFigureInstance(
      Routes.FigureInstance figureInstance) async {
    try {
      return await _routes.routesClient.getFigureInstance(figureInstance);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to get figure instance");
    }
  }

  Future<Routes.FigureInstance> updateFigureInstance(
      Routes.FigureInstance figureInstance) async {
    try {
      return await _routes.routesClient.updateFigureInstance(figureInstance);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to update figure instance");
    }
  }

  Future<Routes.FigureInstance> createFigureInstance(
      Routes.FigureInstance figureInstance) async {
    try {
      return await _routes.routesClient.createFigureInstance(figureInstance);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to create figure instance");
    }
  }

  Future<Routes.FigureInstance> deleteFigureInstance(
      Routes.FigureInstance figureInstance) async {
    try {
      return await _routes.routesClient.deleteFigureInstance(figureInstance);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to delete figure instance");
    }
  }

  Future<Routes.MultiFigureInstance> getFigureInstances(
      Routes.User user) async {
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

  Future<Routes.SkinInstance> getSkinInstance(
      Routes.SkinInstance skinInstance) async {
    try {
      return await _routes.routesClient.getSkinInstance(skinInstance);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to get skin instance");
    }
  }

  Future<Routes.SkinInstance> updateSkinInstance(
      Routes.SkinInstance skinInstance) async {
    try {
      return await _routes.routesClient.updateSkinInstance(skinInstance);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to update skin instance");
    }
  }

  Future<Routes.SkinInstance> createSkinInstance(
      Routes.SkinInstance skinInstance) async {
    try {
      return await _routes.routesClient.createSkinInstance(skinInstance);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to create skin instance");
    }
  }

  Future<Routes.SkinInstance> deleteSkinInstance(
      Routes.SkinInstance skinInstance) async {
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
  // BEGIN SURVEY METHODS //
  Future<Routes.SurveyResponse> getSurveyResponse(
      Routes.SurveyResponse surveyResponse) async {
    try {
      return await _routes.routesClient.getSurveyResponse(surveyResponse);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to get survey response");
    }
  }

  Future<Routes.SurveyResponse> updateSurveyResponse(
      Routes.SurveyResponse surveyResponse) async {
    try {
      return await _routes.routesClient.updateSurveyResponse(surveyResponse);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to update survey response");
    }
  }

  Future<Routes.SurveyResponse> createSurveyResponse(
      Routes.SurveyResponse surveyResponse) async {
    try {
      return await _routes.routesClient.createSurveyResponse(surveyResponse);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to create survey response");
    }
  }

  Future<Routes.SurveyResponse> deleteSurveyResponse(
      Routes.SurveyResponse surveyResponse) async {
    try {
      return await _routes.routesClient.deleteSurveyResponse(surveyResponse);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to delete survey response");
    }
  }

  Future<Routes.MultiSurveyResponse> getSurveyResponses(
      Routes.User user) async {
    try {
      return await _routes.routesClient.getSurveyResponses(user);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to get survey responses");
    }
  }

  Future<Routes.MultiSurveyResponse> createSurveyResponseMulti(
      Routes.MultiSurveyResponse multiSurveyResponse) async {
    try {
      return await _routes.routesClient
          .createSurveyResponseMulti(multiSurveyResponse);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to create survey responses");
    }
  }
  // END SURVEY METHODS //

  // BEGIN OFFLINE DATE TIME METHODS //
  Future<Routes.OfflineDateTime> getOfflineDateTime(
      Routes.OfflineDateTime offlineDateTime) async {
    try {
      return await _routes.routesClient.getOfflineDateTime(offlineDateTime);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to get offline date time");
    }
  }

  Future<Routes.OfflineDateTime> updateOfflineDateTime(
      Routes.OfflineDateTime offlineDateTime) async {
    try {
      return await _routes.routesClient.updateOfflineDateTime(offlineDateTime);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to update offline date time");
    }
  }

  Future<Routes.OfflineDateTime> deleteOfflineDateTime(
      Routes.OfflineDateTime offlineDateTime) async {
    try {
      return await _routes.routesClient.deleteOfflineDateTime(offlineDateTime);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to delete offline date time");
    }
  }
  // END OFFLINE DATE TIME METHODS //

  // BEGIN SERVER ACTIONS //
  Future<Routes.GenericStringResponse> figureDecay(
      Routes.FigureInstance figure) async {
    try {
      return await _routes.routesClient.figureDecay(figure);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to decay figure");
    }
  }

  Future<Routes.GenericStringResponse> userReset(Routes.User user) async {
    try {
      return await _routes.routesClient.userWeeklyReset(user);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to reset user");
    }
  }
  // END SERVER ACTIONS //
}
