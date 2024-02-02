import 'package:ffapp/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:ffapp/services/routes.pb.dart" as Routes;

/*
This serves as a combined user class for use in the frontend
it accesses the firebase and sql through the auth.dart
this might not be necessary but i added it cause the flutter compoenents
were getting bloated with stuff but theres probably a better solution.
It's better than having to manually define all these async functions inside the
components. If you check out dashboard.dart you can see how im using it rn.
*/

class FlutterUser {
  late AuthService auth;

  Future<void> initAuthService() async {
    auth = await AuthService.instance;
    logger.i("AuthService initialized");
  }

  Future<void> checkUser() async {
    logger.i("Checking User Status");
    User? user = await auth.getUser();
    if (user != null) {
      logger.i("User is signed in");
      return;
    }
    logger.i("User is not signed in");
    //figure out how to redirect from this class
  }

  Future<String> getEmail() async {
    logger.i("getting user");
    return auth.getUser().then((value) => value!.email.toString());
  }

  Future<int> getWorkoutGoal() async {
    logger.i("getting user workout goal from MySQL");
    return auth.getUserDBInfo().then((value) => value!.weekGoal.toInt());
  }

  Future<int> getWeeklyCompleted() async {
    logger.i("getting user weekly completed from MySQL");
    return auth.getUserDBInfo().then((value) => value!.weekComplete.toInt());
  }

  Future<String> getCurrentFigure() async {
    logger.i("getting user current figure from MySQL");
    return auth.getUserDBInfo().then((value) => value!.curFigure.toString());
  }

  Future<Routes.User> updateUser(Routes.User user) async {
    logger.i("updating user in MySQL");
    return await auth.updateUserDBInfo(user);
  }

  void logoutUser() {
    auth.signOut();
    //redirect from this class
  }
}
