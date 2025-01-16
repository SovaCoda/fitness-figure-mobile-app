import 'dart:async';
import 'dart:isolate';

import "package:ffapp/firebase_options.dart";
import 'package:ffapp/routes.dart';
import "package:ffapp/services/google/protobuf/empty.pb.dart";
import "package:ffapp/services/routes.pb.dart" as Routes;
import "package:firebase_auth/firebase_auth.dart" as FB;
import "package:firebase_core/firebase_core.dart";
import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';
import 'package:logger/logger.dart';

import 'routes.pbgrpc.dart';

Logger logger = Logger();

// EXPERIMENTATION OF ISOLATES
// class DBInfo {
//   String userEmail;
//   RoutesService routes;

//   DBInfo({required this.userEmail, required this.routes});
// }

// getUserDBInfoIsolate(DBInfo dbInfo) async {
//   final Routes.User user = Routes.User(email: dbInfo.userEmail);
//   return await dbInfo.routes.routesClient.getUser(user);
// }

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
      final FB.FirebaseAuth auth = FB.FirebaseAuth.instance;

      await RoutesService.instance.init();
      final RoutesService routes = RoutesService.instance;

      _instance = AuthService._(auth, routes);
    }
    return _instance!;
  }

  Future<FB.User?> createUser(String email, String password) async {
    try {
      final Routes.User user = Routes.User(email: email);
      await _routes.routesClient.createUser(user);

      final FB.UserCredential userCredential =
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
      final FB.UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
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
    // Gets the current user signed in on Firebase
    final FB.User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      return null;
    }
    final Routes.User user = Routes.User(email: currentUser.email);
    return await _routes.routesClient.getUser(user);
  }

  /// Isolate-safe version of getUserDBInfo that gets the user by the [email] parameter
  ///
  /// Returns a [Routes.User] that has the [email] in the database
  /// throws [GrpcError.notFound] if no user was found
  Future<Routes.User?> getUserDBInfoByEmail(String email) async {
    if (email.isNotEmpty) {
      final user = Routes.User(email: email);
      return await _routes.routesClient.getUser(user);
    }
    return null;
  }

  Future<Routes.UserInfo> initializeUserInfo(String email) async {
    return await _routes.routesClient.initializeUser(GenericStringResponse(message: email));
  }

  Future<Routes.User> updateUserDBInfo(Routes.User user) async {
    return await _routes.routesClient.updateUser(user);
  }

  Future<Routes.User> resetUserStreak(Routes.User user) async {
    return await _routes.routesClient.resetUserStreak(user);
  }

  Future<Routes.User> resetUserWeekComplete(Routes.User user) async {
    return await _routes.routesClient.resetUserWeekComplete(user);
  }

  /* 
  *   Old implementation for changing user email in case we still need it
  */

//   Future<String> updateEmail(String oldEmail, String newEmail, FB.AuthCredential credential) async {
//   try {
//     await _auth.currentUser?.reauthenticateWithCredential(credential);
//     await _auth.currentUser?.verifyBeforeUpdateEmail(newEmail);
//     startEmailVerificationListener(oldEmail, newEmail);
//     // listenToAuthChanges();
//     return "Verification email sent to: $newEmail";
//   } catch (e) {
//     logger.e("Error sending verification email: $e");
//     rethrow;
//   }
// }

//   // Checks every 5 seconds if the user is verified, and, if so, updates the database
//   void startEmailVerificationListener(String oldEmail, String newEmail) {

//     Timer.periodic(const Duration(seconds: 5), (timer) async {
//       try {
//       await _auth.currentUser?.reload();
//       } catch(e) { // if this errors out, it means there was an update to the account
//         completeEmailUpdate(oldEmail, newEmail);
//       }
//       if (_auth.currentUser?.email == newEmail && _auth.currentUser?.emailVerified == true) {
//         timer.cancel();
//         await completeEmailUpdate(oldEmail, newEmail);
//       }
//     });
// }

// This doesn't work as far as I know
// void listenToAuthChanges() {
//   FB.FirebaseAuth.instance.authStateChanges().listen((FB.User? user) {
//     if (user != null) {
//       String? updatedEmail = user.email;

//       completeEmailUpdate(user.email!, updatedEmail!);
//     }
//   });
// }

//   Future completeEmailUpdate(String oldEmail, String newEmail) async {
//   try {
//     await _auth.currentUser?.reload();
//       final Routes.User updatedUser = await _routes.routesClient.updateUserEmail(
//         Routes.UpdateEmailRequest(oldEmail: oldEmail, newEmail: newEmail),
//       );
//       logger.i("Email updated successfully in database to: ${updatedUser.email}");
//       return updatedUser;
//   } catch (e) {
//     logger.e("Error updating email in database: $e");
//     rethrow;
//   }
// }

  Future<void> deleteUser(FB.AuthCredential credential) async {
    // I'll opt for the braindead solution for now
    // get everything from db
    final Future<List<Routes.SkinInstance>> skinInstances =
        getSkinInstances(Routes.User(email: _auth.currentUser!.email))
            .then((value) => value.skinInstances);
    final Future<List<Routes.SurveyResponse>> surveyResponses =
        getSurveyResponses(Routes.User(email: _auth.currentUser!.email))
            .then((value) => value.surveyResponses);
    final Future<List<Routes.Workout>> workouts =
        getWorkouts().then((value) => value.workouts);
    final Future<List<Routes.DailySnapshot>> dailySnapshot = getDailySnapshots(
            Routes.DailySnapshot(userEmail: _auth.currentUser!.email))
        .then((value) => value.dailySnapshots);
    final Future<Routes.OfflineDateTime> offlineDateTime = getOfflineDateTime(
        Routes.OfflineDateTime(email: _auth.currentUser!.email));

    // don't need anymore since figure_instances table utilizes a foreign key and ON DELETE CASCADE
    // for(final Routes.FigureInstance figureInstance in await figureInstances) {
    //   deleteFigureInstance(figureInstance);
    // }
    for (final Routes.SkinInstance skinInstance in await skinInstances) {
      deleteSkinInstance(skinInstance);
    }
    for (final Routes.Workout workout in await workouts) {
      deleteWorkout(workout);
    }
    for (final Routes.SurveyResponse surveyResponse in await surveyResponses) {
      deleteSurveyResponse(surveyResponse);
    }
    for (final Routes.DailySnapshot snapshot in await dailySnapshot) {
      deleteDailySnapshot(snapshot);
    }
    await deleteOfflineDateTime(await offlineDateTime);
    _routes.routesClient
        .deleteUser(Routes.User(email: _auth.currentUser!.email));
    await _auth.currentUser?.reauthenticateWithCredential(credential);
    _auth.currentUser?.delete();
  }

  Future<Routes.MultiDailySnapshot> getDailySnapshots(
    Routes.DailySnapshot dailySnapshot,
  ) async {
    try {
      return await _routes.routesClient.getDailySnapshots(dailySnapshot);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to get daily snapshots");
    }
  }

  Future<Routes.DailySnapshot> getDailySnapshot(
    Routes.DailySnapshot dailySnapshot,
  ) async {
    try {
      return await _routes.routesClient.getDailySnapshot(dailySnapshot);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to get daily snapshot");
    }
  }

  Future<Routes.DailySnapshot> createDailySnapshot(
    Routes.DailySnapshot dailySnapshot,
  ) async {
    try {
      return await _routes.routesClient.createDailySnapshot(dailySnapshot);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to create daily snapshot");
    }
  }

  Future<Routes.DailySnapshot> updateDailySnapshot(
    Routes.DailySnapshot dailySnapshot,
  ) async {
    try {
      return await _routes.routesClient.updateDailySnapshot(dailySnapshot);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to update daily snapshot");
    }
  }

  Future<Routes.DailySnapshot> deleteDailySnapshot(
    Routes.DailySnapshot dailySnapshot,
  ) async {
    try {
      return await _routes.routesClient.deleteDailySnapshot(dailySnapshot);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to delete daily snapshot");
    }
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
    final FB.User? currentUser = _auth.currentUser;
    final Routes.User user = Routes.User(email: currentUser!.email);
    return await _routes.routesClient.getWorkouts(user);
  }

  Future<Routes.Workout> getWorkout(Routes.Workout workout) async {
    return await _routes.routesClient.getWorkout(workout);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> updatePassword(
      String password, FB.AuthCredential credential) async {
    await _auth.currentUser?.reauthenticateWithCredential(credential);
    await _auth.currentUser?.updatePassword(password);
    await _auth.currentUser?.reload();
  }

  Future<void> updateName(String name) async {
    final FB.User? currentUser = _auth.currentUser;
    final Routes.User user = Routes.User(email: currentUser!.email);
    user.name = name;
    await _routes.routesClient.updateUser(user);
  }

  Future<void> updateWeeklyGoal(int goal) async {
    final FB.User? currentUser = _auth.currentUser;
    final Routes.User user = Routes.User(email: currentUser!.email);
    final Int64 goal64 = Int64(goal);
    user.weekGoal = goal64;
    await _routes.routesClient.updateUser(user);
  }

  Future<void> updateCurrency(int currency) async {
    final FB.User? currentUser = _auth.currentUser;
    final Routes.User user = Routes.User(
      email: currentUser?.email,
    ); // Caused crash if user logged out when using !
    if (currentUser == null) return;
    final Int64 currency64 = Int64(currency);
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
    Routes.FigureInstance figureInstance,
  ) async {
    try {
      return await _routes.routesClient.getFigureInstance(figureInstance);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to get figure instance");
    }
  }

  Future<Routes.FigureInstance> updateFigureInstance(
    Routes.FigureInstance figureInstance,
  ) async {
    try {
      return await _routes.routesClient.updateFigureInstance(figureInstance);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to update figure instance");
    }
  }

  Future<Routes.FigureInstance> createFigureInstance(
    Routes.FigureInstance figureInstance,
  ) async {
    try {
      return await _routes.routesClient.createFigureInstance(figureInstance);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to create figure instance");
    }
  }

  Future<Routes.FigureInstance> deleteFigureInstance(
    Routes.FigureInstance figureInstance,
  ) async {
    try {
      return await _routes.routesClient.deleteFigureInstance(figureInstance);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to delete figure instance");
    }
  }

  Future<Routes.MultiFigureInstance> getFigureInstances(
    Routes.User user,
  ) async {
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
    Routes.SkinInstance skinInstance,
  ) async {
    try {
      return await _routes.routesClient.getSkinInstance(skinInstance);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to get skin instance");
    }
  }

  Future<Routes.SkinInstance> updateSkinInstance(
    Routes.SkinInstance skinInstance,
  ) async {
    try {
      return await _routes.routesClient.updateSkinInstance(skinInstance);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to update skin instance");
    }
  }

  Future<Routes.SkinInstance> createSkinInstance(
    Routes.SkinInstance skinInstance,
  ) async {
    try {
      return await _routes.routesClient.createSkinInstance(skinInstance);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to create skin instance");
    }
  }

  Future<Routes.SkinInstance> deleteSkinInstance(
    Routes.SkinInstance skinInstance,
  ) async {
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

  // BEGIN SUBSCRIPTION METHODS //

  Future<Routes.SubscriptionTimeStamp> createSubscriptionTimeStamp(
    Routes.SubscriptionTimeStamp subscriptionTimeStamp,
  ) async {
    try {
      return await _routes.routesClient
          .createSubscriptionTimeStamp(subscriptionTimeStamp);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to create subscription timestamp");
    }
  }

  Future<Routes.SubscriptionTimeStamp> getSubscriptionTimeStamp(
    Routes.SubscriptionTimeStamp subscriptionTimeStamp,
  ) async {
    try {
      return await _routes.routesClient
          .getSubscriptionTimeStamp(subscriptionTimeStamp);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to get subscription timestamp");
    }
  }

  Future<Routes.SubscriptionTimeStamp> updateSubscriptionTimeStamp(
    Routes.SubscriptionTimeStamp subscriptionTimeStamp,
  ) async {
    try {
      return await _routes.routesClient
          .updateSubscriptionTimeStamp(subscriptionTimeStamp);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to update subscription timestamp");
    }
  }

  Future<Routes.SubscriptionTimeStamp> deleteSubscriptionTimeStamp(
    Routes.SubscriptionTimeStamp subscriptionTimeStamp,
  ) async {
    try {
      return await _routes.routesClient
          .deleteSubscriptionTimeStamp(subscriptionTimeStamp);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to delete subscription timestamp");
    }
  }

  // END SUBSCRIPTION METHODS //

  // BEGIN SURVEY METHODS //
  Future<Routes.SurveyResponse> getSurveyResponse(
    Routes.SurveyResponse surveyResponse,
  ) async {
    try {
      return await _routes.routesClient.getSurveyResponse(surveyResponse);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to get survey response");
    }
  }

  Future<Routes.SurveyResponse> updateSurveyResponse(
    Routes.SurveyResponse surveyResponse,
  ) async {
    try {
      return await _routes.routesClient.updateSurveyResponse(surveyResponse);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to update survey response");
    }
  }

  Future<Routes.SurveyResponse> createSurveyResponse(
    Routes.SurveyResponse surveyResponse,
  ) async {
    try {
      return await _routes.routesClient.createSurveyResponse(surveyResponse);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to create survey response");
    }
  }

  Future<Routes.SurveyResponse> deleteSurveyResponse(
    Routes.SurveyResponse surveyResponse,
  ) async {
    try {
      return await _routes.routesClient.deleteSurveyResponse(surveyResponse);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to delete survey response");
    }
  }

  Future<Routes.MultiSurveyResponse> getSurveyResponses(
    Routes.User user,
  ) async {
    try {
      return await _routes.routesClient.getSurveyResponses(user);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to get survey responses");
    }
  }

  Future<Routes.MultiSurveyResponse> createSurveyResponseMulti(
    Routes.MultiSurveyResponse multiSurveyResponse,
  ) async {
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
    Routes.OfflineDateTime offlineDateTime,
  ) async {
    try {
      return await _routes.routesClient.getOfflineDateTime(offlineDateTime);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to get offline date time");
    }
  }

  Future<Routes.OfflineDateTime> updateOfflineDateTime(
    Routes.OfflineDateTime offlineDateTime,
  ) async {
    try {
      return await _routes.routesClient.updateOfflineDateTime(offlineDateTime);
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to update offline date time");
    }
  }

  Future<Routes.OfflineDateTime> deleteOfflineDateTime(
    Routes.OfflineDateTime offlineDateTime,
  ) async {
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
    Routes.FigureInstance figure,
  ) async {
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
