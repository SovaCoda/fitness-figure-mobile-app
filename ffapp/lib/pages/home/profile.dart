import 'dart:async';

import 'package:ffapp/icons/fitness_icon.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ffapp/services/auth.dart';
import 'package:ffapp/services/flutterUser.dart';
import 'package:ffapp/services/routes.pb.dart' as Routes;
import 'package:ffapp/main.dart';
import 'package:fixnum/fixnum.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ffapp/components/resuables/gradiented_container.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late AuthService auth;
  FlutterUser user = FlutterUser();
  late String name = "Loading...";
  late String email = "Loading...";
  late String password = "Loading...";
  late int weeklyGoal = 4; // default values
  late int minExerciseGoal = 30;
  late String manageSub = "Loading...";
  late SharedPreferences prefs;
  late Timer _timer = Timer(Duration.zero, () {});

  @override
  void initState() {
    super.initState();
    auth = Provider.of<AuthService>(context, listen: false);
    initialize();
  }

  void initialize() async {
    try {
      Routes.User? databaseUser = await auth.getUserDBInfo();
      prefs = await SharedPreferences.getInstance();
      if (mounted) {
        Provider.of<UserModel>(context, listen: false).setUser(databaseUser!);
        if (prefs.getString("isVerified") == "false" &&
            prefs.getString("oldEmail") ==
                databaseUser
                    .email) // make sure our listener doesn't mistrigger from potential alt accounts
        {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    "You have still not verified your new email at ${prefs.getString("newEmail")}. Please check your inbox.")),
          );
          auth.startEmailVerificationListener(
              databaseUser.email, prefs.getString("newEmail")!);
          checkEmailVerification(prefs.getString("newEmail")!);
        }
        String curName = databaseUser.name;
        String curEmail = databaseUser.email;
        int curGoal = databaseUser.weekGoal.toInt();
        int minExerciseTime = databaseUser.workoutMinTime.toInt();
        bool premiumStatus =
            Provider.of<UserModel>(context, listen: false).isPremium();

        setState(() {
          name = curName;
          email = curEmail;
          password = "*******";
          weeklyGoal = curGoal;
          minExerciseGoal = minExerciseTime;
          manageSub = premiumStatus ? "Subscription Tier 1" : "Regular User";
        });
      }
    } catch (e) {
      logger.e(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  void _showWeeklyGoalPicker() {
    int safeWeeklyGoal = weeklyGoal.clamp(1, 7);
    BottomPicker(
      items: List.generate(
          7,
          (index) => Text("${index + 1} ${index == 0 ? "day" : "days"}",
              style: const TextStyle(fontSize: 35))),
      pickerTitle: const Text(
        "Select Weekly Workout Goal",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      titleAlignment: Alignment.center,
      pickerTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontWeight: FontWeight.bold,
      ),
      height: MediaQuery.of(context).size.height * 0.5,
      backgroundColor: Theme.of(context).colorScheme.surface,
      selectedItemIndex: safeWeeklyGoal - 1,
      itemExtent: 38,
      dismissable: true,
      onSubmit: (index) {
        setState(() {
          weeklyGoal = index + 1;
        });
        updateWeeklyGoal(weeklyGoal);
      },
      buttonAlignment: MainAxisAlignment.center,
      displayCloseIcon: false,
      buttonWidth: MediaQuery.of(context).size.width * 0.5,
      buttonContent: Text("Confirm",
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary, fontSize: 16),
          textAlign: TextAlign.center),
      buttonStyle: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.all(Radius.circular(13)),
      ),
      buttonSingleColor: Theme.of(context).colorScheme.primary,
    ).show(context);
  }

  void _showMinGoalPicker() {
    int safeWeeklyGoal =
        weeklyGoal.clamp(1, 12); // prevents errors from user input
    BottomPicker(
      items: List.generate(
          12,
          (index) => Text("${(index + 1) * 15} minutes",
              style: const TextStyle(fontSize: 35))),
      pickerTitle: const Text(
        "Select Weekly Workout Goal",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      titleAlignment: Alignment.center,
      pickerTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontWeight: FontWeight.bold,
      ),
      height: MediaQuery.of(context).size.height * 0.5,
      backgroundColor: Theme.of(context).colorScheme.surface,
      selectedItemIndex: safeWeeklyGoal - 1,
      itemExtent: 38,
      dismissable: true,
      onSubmit: (index) {
        setState(() {
          minExerciseGoal = (index + 1) * 15;
        });
        updateMinWorkoutTime(minExerciseGoal);
      },
      buttonAlignment: MainAxisAlignment.center,
      displayCloseIcon: false,
      buttonWidth: MediaQuery.of(context).size.width * 0.5,
      buttonContent: Text("Confirm",
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary, fontSize: 16),
          textAlign: TextAlign.center),
      buttonStyle: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.all(Radius.circular(13)),
      ),
      buttonSingleColor: Theme.of(context).colorScheme.primary,
    ).show(context);
  }

  void updateName(String newName) async {
    await auth.updateName(newName);
    setState(() {
      name = newName;
    });
  }

  Future updateEmail(
      String userEmail, String userPassword, String newEmail) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(
          email: userEmail, password: userPassword);
      String result = await auth.updateEmail(userEmail, newEmail, credential);
      prefs.setString("oldEmail", userEmail);
      prefs.setString("newEmail", newEmail);
      prefs.setString("isVerified", "false");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );

      // Don't sign out or navigate away, wait for verification
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void checkEmailVerification(String newEmail) {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        await user?.reload();
        if (user?.email == newEmail && user?.emailVerified == true) {
          timer.cancel();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Email updated successfully!")),
          );
        }
      } on FirebaseAuthException {
        // setState(() {
        //   email = newEmail;
        // });
        prefs.setString("isVerified", "true");
        prefs.setString("newEmail", "");
        signOut(context);
        GoRouter.of(context).go("/");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Success! Please sign back in.")),
        );
      }
    });
  }

  Future<void> updatePassword(
      String userEmail, String userPassword, String newPassword) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(
          email: userEmail, password: userPassword);
      await auth.updatePassword(newPassword, credential);
      signOut(context);
      GoRouter.of(context).go("/");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Success! Please sign back in.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void updateWeeklyGoal(int goal) async {
    await auth.updateWeeklyGoal(goal);
    Provider.of<UserModel>(context, listen: false).setUserWeekGoal(Int64(goal));
  }

  void updateMinWorkoutTime(int time) async {
    await auth.updateUserDBInfo(
        Routes.User(email: email, workoutMinTime: Int64(time)));
    Provider.of<UserModel>(context, listen: false)
        .setWorkoutMinTime(Int64(time));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image
        Positioned.fill(
          child: Image.asset(
            'lib/assets/art/profile_background.png', // Make sure this image exists in your assets
            fit: BoxFit.cover,
          ),
        ),
        // Existing content
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('PROFILE',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center),
                const SizedBox(height: 24),
                _buildProfileSection(),
                const SizedBox(height: 24),
                _buildGoalsSection(),
                const SizedBox(height: 24),
                _buildSubscriptionSection(),
                const SizedBox(height: 32),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSection() {
    return GradientedContainer(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('PERSONAL INFORMATION',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400)),
            const SizedBox(height: 16),
            _buildProfileItem(Icons.person, 'Name', name,
                () => _showEditDialog("Name", name, updateName)),
            _buildProfileItem(
                Icons.email,
                'Email',
                email,
                () => _showEditDialog("Email", email, (newEmail) async {
                      final userPassword = await _showPasswordConfirmDialog();
                      if (userPassword != null) {
                        updateEmail(email, userPassword, newEmail);
                      }
                    })),
            _buildProfileItem(
                Icons.lock, 'Password', '********', _showPasswordChangeDialog),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(
      IconData icon, String title, String value, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            icon == Icons.person
                ? const FitnessIcon(type: FitnessIconType.logo_white, size: 24)
                : Icon(icon, color: Colors.white),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Roboto')),
                  Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        color: Color.fromARGB(255, 145, 145, 145)),
                  ),
                ],
              ),
            ),
            // Icon(Icons.edit, color: Colors.grey), removed according to the design
          ],
        ),
      ),
    );
  }

  Widget _buildGoalsSection() {
    return GradientedContainer(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('WORKOUT GOALS',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400)),
            const SizedBox(height: 16),
            _buildGoalItem(
                'Weekly Workout Goal',
                '$weeklyGoal ${weeklyGoal == 1 ? "day" : "days"}',
                _showWeeklyGoalPicker),
            _buildGoalItem(
                'Minimum Workout Time',
                '$minExerciseGoal ${minExerciseGoal == 1 ? "minute" : "minutes"}',
                _showMinGoalPicker),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalItem(String title, String value, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Roboto')),
              Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    color: Color.fromARGB(255, 145, 145, 145)),
              ),
            ],
          ),
          GestureDetector(
            onTap: onTap,
            child: const Icon(Icons.edit, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionSection() {
    return GradientedContainer(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
          const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("SUBSCRIPTION",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 18))),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [
                manageSub == "Regular User"
                    ? const FitnessIcon(
                        type: FitnessIconType.regular_badge, size: 50)
                    : const FitnessIcon(
                        type: FitnessIconType.premium, size: 50),
                const SizedBox(width: 8),
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(manageSub == "Regular User" ? "REGULAR" : "PREMIUM",
                          style: const TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500)),
                      GestureDetector(
                          onTap: () {}, // TODO: Implement purchase premium page
                          child: const Text(
                            "Tap To Purchase Premium",
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                color: Color.fromARGB(255, 145, 145, 145),
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ))
                    ])
              ])),
        ]));
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () => _showSignOutConfirmation(),
          icon: const Icon(Icons.logout, color: Colors.white),
          label: const Text('Sign Out'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: () => _showDeleteAccountConfirmation(),
          icon: Icon(Icons.delete_forever, color: Colors.red[300]),
          label:
              Text('Delete Account', style: TextStyle(color: Colors.red[300])),
          style: TextButton.styleFrom(
            backgroundColor: Colors.red.withOpacity(0.1),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.red[300]!, width: 1),
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteAccountConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
              'Are you sure you want to delete your account? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // current issue: auth.deleteUser() requires user reauthorization
                final userPassword = await _showPasswordConfirmDialog();
                if (userPassword != null) {
                  AuthCredential credential = EmailAuthProvider.credential(
                      email: email, password: userPassword);
                  await auth.deleteUser(credential);
                  signOut(context);
                  GoRouter.of(context).go("/");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(
      String title, String currentValue, Function(String) onSave) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newValue = currentValue;
        return AlertDialog(
          title: Text("Edit $title"),
          content: TextField(
            autofocus: true,
            onChanged: (value) {
              newValue = value;
            },
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Save"),
              onPressed: () async {
                // In the _showEditDialog method, replace the existing email update logic with:
                if (title == "Email") {
                  final userPassword = await _showPasswordConfirmDialog();
                  if (userPassword != null) {
                    await updateEmail(currentValue, userPassword, newValue);
                    checkEmailVerification(newValue);
                  }
                } else {
                  onSave(newValue);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<String?> _showPasswordConfirmDialog() async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String password = '';
        return AlertDialog(
          title: const Text("Confirm Password"),
          content: TextField(
            obscureText: true,
            onChanged: (value) {
              password = value;
            },
            decoration:
                const InputDecoration(hintText: "Enter your current password"),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Confirm"),
              onPressed: () => Navigator.of(context).pop(password),
            ),
          ],
        );
      },
    );
  }

  void _showPasswordChangeDialog() async {
    String? currentPassword = await _showPasswordConfirmDialog();
    if (currentPassword == null) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newPassword = '';
        return AlertDialog(
          title: const Text("Change Password"),
          content: TextField(
            obscureText: true,
            onChanged: (value) {
              newPassword = value;
            },
            decoration: const InputDecoration(hintText: "Enter new password"),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Change"),
              onPressed: () {
                updatePassword(email, currentPassword, newPassword);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSignOutConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Sign Out"),
          content: const Text("Are you sure you want to sign out?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Sign Out"),
              onPressed: () {
                signOut(context);
                GoRouter.of(context).go("/");
              },
            ),
          ],
        );
      },
    );
  }
}

class InvalidEmailException implements Exception {
  String cause;
  InvalidEmailException(this.cause);
}

Future<void> signOut(BuildContext context) async {
  Provider.of<UserModel>(context, listen: false).setUser(Routes.User());
  await FirebaseAuth.instance.signOut();
}
