import 'dart:async';
import 'dart:ui';

import 'package:bottom_picker/bottom_picker.dart';
import 'package:ffapp/components/ff_app_premium_badge.dart';
import 'package:ffapp/components/ff_app_button.dart';
import 'package:ffapp/components/ff_alert_dialog.dart';
import 'package:ffapp/components/resuables/gradiented_container.dart';
import 'package:ffapp/icons/fitness_icon.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/services/auth.dart';
import 'package:ffapp/services/routes.pb.dart' as routes;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late AuthService auth;
  int weeklyGoal = 5;
  int minExerciseGoal = 45;

  @override
  void initState() {
    super.initState();
    auth = Provider.of<AuthService>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showWeeklyGoalPicker() {
    final int safeWeeklyGoal = weeklyGoal.clamp(1, 7);
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 5),
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.5, // 0.295
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Color.fromRGBO(51, 133, 162, 1),
                    ),
                  ),
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color.fromRGBO(28, 109, 189, 0.29),
                      Color.fromRGBO(0, 164, 123, 0.29),
                    ],
                  ),
                ),
                child: BottomSheet(
                  backgroundColor: Colors.transparent,
                  enableDrag: false,
                  onClosing: () {},
                  builder: (BuildContext context) {
                    return BottomPicker(
                        items: List.generate(
                          7,
                          (int index) => Text(
                            "${index + 1} ${index == 0 ? "day" : "days"}",
                            style: const TextStyle(fontSize: 35),
                          ),
                        ),
                        pickerTitle: const Text(
                          'Select Weekly Workout Goal',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                        titleAlignment: Alignment.center,
                        pickerTextStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                        height: MediaQuery.of(context).size.height * 0.5,
                        backgroundColor: Colors.transparent,
                        selectedItemIndex: safeWeeklyGoal - 1,
                        buttonStyle: const BoxDecoration(),
                        itemExtent: 38,
                        buttonWidth: MediaQuery.of(context).size.width * 0.77,
                        onChange: (dynamic index) {
                          setState(() {
                            final int indexInt = index as int;
                            weeklyGoal = indexInt + 1;
                          });
                        },
                        onClose: (dynamic index) {
                          updateWeeklyGoal(weeklyGoal);
                        },
                        onSubmit: (dynamic index) {
                          updateWeeklyGoal(weeklyGoal);
                        },
                        displayCloseIcon: false,
                        buttonContent: FFAppButton(
                            text: 'Confirm',
                            size: MediaQuery.of(context).size.width * 0.77,
                            height: MediaQuery.of(context).size.height * 0.07,
                            onPressed: () =>
                                {updateWeeklyGoal(weeklyGoal), context.pop()}));
                  },
                )));
      },
    );
  }

  void _showMinGoalPicker() {
    final int safeWeeklyGoal = weeklyGoal.clamp(1, 12);
    showModalBottomSheet(
        context: context,
        enableDrag: false,
        isDismissible: false,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 5),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.5, // 0.295
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Color.fromRGBO(51, 133, 162, 1),
                      ),
                    ),
                    gradient: LinearGradient(
                      colors: <Color>[
                        Color.fromRGBO(28, 109, 189, 0.29),
                        Color.fromRGBO(0, 164, 123, 0.29),
                      ],
                    ),
                  ),
                  child: BottomPicker(
                    items: List.generate(
                      12,
                      (int index) => Text(
                        '${(index + 1) * 15} minutes',
                        style: const TextStyle(fontSize: 35),
                      ),
                    ),
                    pickerTitle: const Text(
                      'Select Weekly Workout Goal',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    titleAlignment: Alignment.center,
                    pickerTextStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                    buttonStyle: const BoxDecoration(),
                    buttonWidth: MediaQuery.of(context).size.width * 0.77,
                    height: MediaQuery.of(context).size.height * 0.5,
                    backgroundColor: Colors.transparent,
                    selectedItemIndex: safeWeeklyGoal - 1,
                    itemExtent: 38,
                    onChange: (dynamic index) {
                      setState(() {
                        final int indexInt = index as int;
                        minExerciseGoal = (indexInt + 1) * 15;
                      });
                    },
                    onSubmit: (dynamic index) {
                      updateMinWorkoutTime(minExerciseGoal);
                    },
                    displayCloseIcon: false,
                    onClose: (dynamic index) {
                      updateMinWorkoutTime(minExerciseGoal);
                    },
                    buttonContent: FFAppButton(
                        text: 'Confirm',
                        size: MediaQuery.of(context).size.width * 0.77,
                        height: MediaQuery.of(context).size.height * 0.07,
                        onPressed: () {
                          updateMinWorkoutTime(minExerciseGoal);
                          context.pop();
                        }),
                  )));
        });
  }

  Future<void> updateName(String newName) async {
    // update database
    await auth.updateName(newName);

    // update local state
    Provider.of<UserModel>(context, listen: false).setUserName(newName);
  }

  /// 
  Future<void> updatePassword(
    String userEmail,
    String userPassword,
    String newPassword,
  ) async {
    try {
      // Firebase requires user credentials to update the user's password
      final AuthCredential credential = EmailAuthProvider.credential(
        email: userEmail,
        password: userPassword,
      );

      // Update the password on firebase
      await auth.updatePassword(newPassword, credential);

      // Sign the user out and bring to sign in page on success
      if (mounted) {
        signOut(context);
        GoRouter.of(context).go('/');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Success! Please sign back in.')),
        );
      }
    } 
    // Exception typically occurs if the user enters the incorrect password
    // However, it is also possible that firebase could be down
    catch (e) {
      if (mounted) {
        // ! print the error to the user (risky)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  Future<void> updateWeeklyGoal(int goal) async {
    setState(() {
      weeklyGoal = goal;
    });
    await auth.updateWeeklyGoal(goal);
    if (mounted) {
      Provider.of<UserModel>(context, listen: false)
          .setUserWeekGoal(Int64(goal));
    }
  }

  Future<void> updateMinWorkoutTime(int time) async {
    // update state of page
    setState(() {
      minExerciseGoal = time;
    });

    // update database
    final String email =
        Provider.of<UserModel>(context, listen: false).user!.email;
    await auth.updateUserDBInfo(
      routes.User(email: email, workoutMinTime: Int64(time)),
    );

    // update state of entire app
    if (mounted) {
      Provider.of<UserModel>(context, listen: false)
          .setWorkoutMinTime(Int64(time));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(builder: (context, userModel, _) {
      return Stack(
        children: <Widget>[
          // Background image
          Positioned.fill(
            child: Image.asset(
              'lib/assets/art/profile_background.png', // Make sure this image exists in your assets
              fit: BoxFit.cover,
            ),
          ),
          // Existing content
          SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics().applyTo(
              const BouncingScrollPhysics(),
            ), // quick fix for this https://github.com/flutter/flutter/issues/138940
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text(
                    'PROFILE',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  _buildProfileSection(userModel),
                  const SizedBox(height: 24),
                  _buildGoalsSection(userModel),
                  const SizedBox(height: 24),
                  _buildSubscriptionSection(userModel),
                  const SizedBox(height: 32),
                  _buildActionButtons(userModel),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildProfileSection(UserModel userModel) {
    return GradientedContainer(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'PERSONAL INFORMATION',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 16),
            _buildProfileItem(
              Icons.person,
              'Name',
              userModel.user!.name,
              () => _showEditDialog('Name', userModel.user!.name, updateName),
            ),
            _buildProfileItem(
                Icons.email,
                'Email',
                userModel.user!.email,
                // () => _showEditDialog("Email", email, (newEmail) async {
                //   final userPassword = await _showPasswordConfirmDialog();
                //   if (userPassword != null) {
                //     updateEmail(email, userPassword, newEmail);
                //   }
                // }),
                () {} // don't allow updating email bc too much of a pain
                ),
            _buildProfileItem(
              Icons.lock,
              'Password',
              '********',
              _showPasswordChangeDialog,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(
    IconData icon,
    String title,
    String value,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: <Widget>[
            if (icon == Icons.person)
              const FitnessIcon(type: FitnessIconType.logo_white, size: 24)
            else
              Icon(icon, color: Colors.white),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      color: Color.fromARGB(255, 145, 145, 145),
                    ),
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

  Widget _buildGoalsSection(UserModel userModel) {
    return GradientedContainer(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'WORKOUT GOALS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 16),
            _buildGoalItem(
              'Weekly Workout Goal',
              '${userModel.user!.weekGoal} ${userModel.user!.weekGoal == 1 ? "day" : "days"}',
              _showWeeklyGoalPicker,
            ),
            _buildGoalItem(
              'Minimum Workout Time',
              '${userModel.user!.workoutMinTime} ${userModel.user!.workoutMinTime == 1 ? "minute" : "minutes"}',
              _showMinGoalPicker,
            ),
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
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Roboto',
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  color: Color.fromARGB(255, 145, 145, 145),
                ),
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

  Widget _buildSubscriptionSection(UserModel userModel) {
    return GradientedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'SUBSCRIPTION',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                if (!userModel.isPremium())
                  const FitnessIcon(
                    type: FitnessIconType.regular_badge,
                    size: 50,
                  )
                else
                  const AnimatedPremiumBadge(size: 50),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      !userModel.isPremium() ? 'REGULAR' : 'PREMIUM',
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (!userModel.isPremium())
                      GestureDetector(
                        onTap: () {}, // TODO: Implement purchase premium page
                        child: const Text(
                          'Tap To Purchase Premium',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            color: Color.fromARGB(255, 145, 145, 145),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(UserModel userModel) {
    return Column(
      children: <Widget>[
        FFAppButton(
          onPressed: () => _showSignOutConfirmation(),
          text: 'SIGN OUT',
          isSignOut: true,
          fontSize: 24,
          size: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.08,
        ),
        const SizedBox(height: 16),
        FFAppButton(
          onPressed: () =>
              _showDeleteAccountConfirmation(userModel.user!.email),
          text: 'DELETE ACCOUNT',
          fontSize: 20,
          isDelete: true,
          size: MediaQuery.of(context).size.width *
              0.79389312977099236641221374045802,
          height: MediaQuery.of(context).size.height *
              0.08098591549295774647887323943662,
        ),
      ],
    );
  }

  void _showDeleteAccountConfirmation(String email) {
    showFFDialogBinary(
      'Delete Account',
      'Are you sure you want to delete your account? This action cannot be undone.',
      true,
      context,
      FFAppButton(
        text: 'Delete Account',
        size: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.10,
        isDelete: true,
        onPressed: () async {
          // current issue: auth.deleteUser() requires user reauthorization
          final String? userPassword = await _showPasswordConfirmDialog();
          if (userPassword != null) {
            final AuthCredential credential = EmailAuthProvider.credential(
              email: email,
              password: userPassword,
            );
            await auth.deleteUser(credential);
            if (mounted) {
              signOut(context);
              GoRouter.of(context).go('/');
            }
          }
        },
      ),
      FFAppButton(
        text: 'Cancel',
        size: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.10,
        isNoThanks: true,
        onPressed: () {
          if (mounted) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
    //     return GradientedContainer(
    //     child: AlertDialog(
    //       content: const GradientedContainer(
    //         height: 300,
    //         width: 200,
    //         showTopRectangle: true,
    //         title: "Delete Account",
    //         child: Text('Are you sure you want to delete your account? This action cannot be undone.')),
    //       actions: [
    //         TextButton(
    //           onPressed: () {
    //             if (mounted) {
    //               Navigator.of(context).pop();
    //             }
    //           },
    //           child: const Text('Cancel'),
    //         ),
    //         ElevatedButton(
    //           onPressed: () async {
    //             // current issue: auth.deleteUser() requires user reauthorization
    //             final userPassword = await _showPasswordConfirmDialog();
    //             if (userPassword != null) {
    //               AuthCredential credential = EmailAuthProvider.credential(
    //                   email: email, password: userPassword);
    //               await auth.deleteUser(credential);
    //               signOut(context);
    //               GoRouter.of(context).go("/");
    //             }
    //           },
    //           style: ElevatedButton.styleFrom(
    //             backgroundColor: Theme.of(context).colorScheme.error,
    //             foregroundColor: Theme.of(context).colorScheme.onError,
    //           ),
    //           child: const Text('Delete'),
    //         ),
    //       ],
    //     )
    //     );
    //   },
    // );
  }

  void _showEditDialog(
    String title,
    String currentValue,
    Function(String) onSave,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newValue = currentValue;
        return AlertDialog(
          title: Text('Edit $title'),
          content: TextField(
            autofocus: true,
            onChanged: (String value) {
              newValue = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                // In the _showEditDialog method, replace the existing email update logic with:
                onSave(newValue);

                if (mounted) {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                }
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
          title: const Text('Confirm Password'),
          content: TextField(
            obscureText: true,
            onChanged: (String value) {
              password = value;
            },
            decoration:
                const InputDecoration(hintText: 'Enter your current password'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () => Navigator.of(context).pop(password),
            ),
          ],
        );
      },
    );
  }

  /// Opens a popup that prompts the user to enter their current password
  /// and then a new password to update their current password
  /// 
  /// Calls [updatePassword] with the info to update the password in firebase
  Future<void> _showPasswordChangeDialog() async {
    final String? currentPassword = await _showPasswordConfirmDialog();
    if (currentPassword == null || !mounted) {
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newPassword = '';
        return AlertDialog(
          title: const Text('Change Password'),
          content: TextField(
            obscureText: true,
            onChanged: (String value) {
              newPassword = value;
            },
            decoration: const InputDecoration(hintText: 'Enter new password'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Change'),
              onPressed: () {
                final String email =
                    Provider.of<UserModel>(context, listen: false).user!.email;
                updatePassword(email, currentPassword, newPassword);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// Shows a popup confirmation for the user to sign out or cancel
  void _showSignOutConfirmation() {
    showFFDialogBinary(
      'Sign out',
      'Are you sure you want to sign out?',
      true,
      context,
      FFAppButton(
        text: 'SIGN OUT',
        size: MediaQuery.of(context).size.width * 0.75,
        height: MediaQuery.of(context).size.height * 0.07,
        fontSize: 20,
        isSignOut: true,
        onPressed: () {
          signOut(context);
          GoRouter.of(context).go('/');
        },
      ),
      FFAppButton(
        text: 'CANCEL',
        isNoThanks: true,
        fontSize: 20,
        size: MediaQuery.of(context).size.width * 0.75,
        height: MediaQuery.of(context).size.height * 0.07,
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}

/// Sets the user provider to an empty user and removes the user's firebase instance
Future<void> signOut(BuildContext context) async {
  Provider.of<UserModel>(context, listen: false).setUser(routes.User());
  await FirebaseAuth.instance.signOut();
}

  // Update Email function (scrapped)
  // Future updateEmail(
  //   String userEmail,
  //   String userPassword,
  //   String newEmail,
  // ) async {
  //   try {
  //     final AuthCredential credential = EmailAuthProvider.credential(
  //       email: userEmail,
  //       password: userPassword,
  //     );
  //     final String result =
  //         await auth.updateEmail(userEmail, newEmail, credential);
  //     prefs.setString("oldEmail", userEmail);
  //     prefs.setString("newEmail", newEmail);
  //     prefs.setString("isVerified", "false");

  //     if (mounted) {
  //       if (mounted) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text(result)),
  //         );
  //       }
  //     }

  //     // Don't sign out or navigate away, wait for verification
  //   } catch (e) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text(e.toString())),
  //       );
  //     }
  //   }
  // }

  // void checkEmailVerification(String newEmail) {
  //   _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
  //     try {
  //       final User? user = FirebaseAuth.instance.currentUser;
  //       await user?.reload();
  //       if (user?.email == newEmail && user?.emailVerified == true) {
  //         timer.cancel();
  //         if (mounted) {
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             const SnackBar(content: Text("Email updated successfully!")),
  //           );
  //         }
  //       }
  //     } on FirebaseAuthException {
  //       // setState(() {
  //       //   email = newEmail;
  //       // });
  //       prefs.setString("isVerified", "true");
  //       prefs.setString("newEmail", "");
  //       if (mounted) {
  //         signOut(context);
  //         GoRouter.of(context).go("/");
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text("Success! Please sign back in.")),
  //         );
  //       }
  //     }
  //   });
  // }