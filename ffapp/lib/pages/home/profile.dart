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
              style: TextStyle(fontSize: 35))),
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
    int safeWeeklyGoal = weeklyGoal.clamp(1, 12); // prevents errors from user input
    BottomPicker(
      items: List.generate(
          12,
          (index) => Text("${(index + 1) * 15} minutes",
              style: TextStyle(fontSize: 35))),
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
            SnackBar(content: Text("Email updated successfully!")),
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
          SnackBar(content: Text("Success! Please sign back in.")),
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
        SnackBar(content: Text("Success! Please sign back in.")),
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
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text("Profile", style: Theme.of(context).textTheme.displayLarge!.copyWith(color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildProfileSection(),
              SizedBox(height: 24),
              _buildGoalsSection(),
              SizedBox(height: 24),
              _buildSubscriptionSection(),
              SizedBox(height: 32),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Card(
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Personal Information', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            _buildProfileItem(Icons.person, 'Name', name, () => _showEditDialog("Name", name, updateName)),
            _buildProfileItem(Icons.email, 'Email', email, () => _showEditDialog("Email", email, (newEmail) async {
              final userPassword = await _showPasswordConfirmDialog();
              if (userPassword != null) {
                updateEmail(email, userPassword, newEmail);
              }
            })),
            _buildProfileItem(Icons.lock, 'Password', '********', _showPasswordChangeDialog),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, String value, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, color: Colors.blue),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: Colors.grey[400])),
                  Text(value, style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            Icon(Icons.edit, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalsSection() {
    return Card(
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Workout Goals', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            _buildGoalItem('Weekly Workout Goal', '$weeklyGoal ${weeklyGoal == 1 ? "day" : "days"}', _showWeeklyGoalPicker),
            _buildGoalItem('Minimum Workout Time', '$minExerciseGoal ${minExerciseGoal == 1 ? "minute" : "minutes"}', _showMinGoalPicker),
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
              Text(title, style: TextStyle(color: Colors.grey[400], fontSize: 20)),
              Text(value, style: TextStyle(color: Colors.white, fontSize: 28)),
            ],
          ),
          ElevatedButton(
            onPressed: onTap,
            child: Text("Change"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionSection() {
    return Card(
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: manageSub == "Regular User" ? const FitnessIcon(type: FitnessIconType.regular_badge, size: 40) : const FitnessIcon(type: FitnessIconType.premium, size: 40),
        title: const Text("Subscription", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(manageSub, style: TextStyle(color: Colors.grey[400])),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () => _showSignOutConfirmation(),
          icon: Icon(Icons.logout, color: Colors.white),
          label: Text('Sign Out'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        SizedBox(height: 16),
        TextButton.icon(
          onPressed: () => _showDeleteAccountConfirmation(),
          icon: Icon(Icons.delete_forever, color: Colors.red[300]),
          label: Text('Delete Account', style: TextStyle(color: Colors.red[300])),
          style: TextButton.styleFrom(
            backgroundColor: Colors.red.withOpacity(0.1),
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
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
        title: Text('Delete Account'),
        content: Text('Are you sure you want to delete your account? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              // TODO: FIGURE OUT HOW TO DELETE ACCOUNT
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
            child: Text('Delete'),
          ),
        ],
      );
    },
  );
}

  Widget _buildProfileCard({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
        trailing: Icon(Icons.edit),
        onTap: onTap,
      ),
    );
  }

  Widget _buildWeeklyGoalCard() {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Weekly Workout Goal',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: MediaQuery.of(context).size.width*0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("$weeklyGoal ${weeklyGoal == 1 ? "day" : "days"}"),
                ElevatedButton(
                  onPressed: _showWeeklyGoalPicker,
                  child: Text("Change"),
                ),
              ],
            ),
          ],
        ),
      ),
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
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Save"),
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
          title: Text("Confirm Password"),
          content: TextField(
            obscureText: true,
            onChanged: (value) {
              password = value;
            },
            decoration:
                InputDecoration(hintText: "Enter your current password"),
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Confirm"),
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
          title: Text("Change Password"),
          content: TextField(
            obscureText: true,
            onChanged: (value) {
              newPassword = value;
            },
            decoration: InputDecoration(hintText: "Enter new password"),
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Change"),
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
          title: Text("Sign Out"),
          content: Text("Are you sure you want to sign out?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Sign Out"),
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
