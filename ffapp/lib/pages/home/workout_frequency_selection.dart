import 'package:bottom_picker/bottom_picker.dart';
import 'package:ffapp/components/robot_image_holder.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/services/auth.dart';
import 'package:ffapp/services/flutterUser.dart';
import "package:ffapp/services/routes.pb.dart" as routes;
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class WorkoutFrequencySelection extends StatefulWidget {
  const WorkoutFrequencySelection({super.key});

  @override
  State<WorkoutFrequencySelection> createState() =>
      _WorkoutFrequencySelectionState();
}

class _WorkoutFrequencySelectionState extends State<WorkoutFrequencySelection> {
  Int64 _nCurrentValue = Int64(4);
  Int64 _mCurrentValue = Int64(30);
  FlutterUser user = FlutterUser();
  String curEmail = "Loading...";
  late AuthService auth;
  int weeklyGoal = 4;
  int minExerciseGoal = 30;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    await user.initAuthService();
    await user.checkUser();
    if (mounted) {
      auth = Provider.of<AuthService>(context, listen: false);
    }

    curEmail = await user.getEmail();
  }

  void showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showWeeklyGoalPicker() {
    final int safeWeeklyGoal = weeklyGoal.clamp(1, 7);
    BottomPicker(
      items: List.generate(
        7,
        (index) => Text(
          "${index + 1} ${index == 0 ? "day" : "days"}",
          style: const TextStyle(fontSize: 35),
        ),
      ),
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
      onSubmit: (dynamic value) {
        if (value is int) {
          setState(() {
            weeklyGoal = value + 1;
          });
          updateWeeklyGoal(weeklyGoal);
        }
      },
      displayCloseIcon: false,
      buttonWidth: MediaQuery.of(context).size.width * 0.5,
      buttonContent: Text(
        "Confirm",
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
      buttonStyle: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.all(Radius.circular(13)),
      ),
      buttonSingleColor: Theme.of(context).colorScheme.primary,
    ).show(context);
  }

  Future<void> updateWeeklyGoal(int goal) async {
    // await auth.updateWeeklyGoal(goal);
    Provider.of<UserModel>(context, listen: false).setUserWeekGoal(Int64(goal));
    setState(() {
      _nCurrentValue = Int64(goal);
    });
  }

  void _showMinGoalPicker() {
    final int safeWeeklyGoal = weeklyGoal.clamp(1, 4);
    BottomPicker(
      items: List.generate(
        4,
        (index) => Text(
          "${(index + 1) * 15} minutes",
          style: const TextStyle(fontSize: 35),
        ),
      ),
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
          if (index is int) {
            minExerciseGoal = (index + 1) * 15;
          }
        });
        updateMinWorkoutTime(minExerciseGoal);
      },
      displayCloseIcon: false,
      buttonWidth: MediaQuery.of(context).size.width * 0.5,
      buttonContent: Text(
        "Confirm",
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
      buttonStyle: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.all(Radius.circular(13)),
      ),
      buttonSingleColor: Theme.of(context).colorScheme.primary,
    ).show(context);
  }

  Future<void> updateMinWorkoutTime(int time) async {
    // await auth.updateUserDBInfo(
    //     Routes.User(email: curEmail, workoutMinTime: Int64(time)));
    Provider.of<UserModel>(context, listen: false)
        .setWorkoutMinTime(Int64(time));
    setState(() {
      _mCurrentValue = Int64(time);
    });
  }

  void submitFrequency() {
    if (_mCurrentValue == 0 || _nCurrentValue == 0) {
      return;
    }
    final routes.User newUser = routes.User(
      weekGoal: _nCurrentValue,
      email: curEmail,
      workoutMinTime: _mCurrentValue,
    );
    user.updateUser(newUser); // Updated workoutMinTime value

    Provider.of<UserModel>(context, listen: false).setUser(newUser);
    context.goNamed('Home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey[900]!, Theme.of(context).colorScheme.surface],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ListView(
              children: [
                const SizedBox(height: 40),
                Center(
                  child: Text(
                    "Set Your Workout Goals",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                Consumer<FigureModel>(
                  builder: (context, figure, _) {
                    return Center(
                      child: RobotImageHolder(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.height * 0.3,
                        url:
                            "${figure.figure!.figureName}/${figure.figure!.figureName}_skin0_evo0_cropped_happy",
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),
                _buildWeeklyGoalCard(),
                const SizedBox(height: 40),
                _buildWorkoutGoalCard(),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: submitFrequency,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    "Activate Workout Mode",
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeeklyGoalCard() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weekly Workout Goal',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("$weeklyGoal ${weeklyGoal == 1 ? "day" : "days"}"),
                ElevatedButton(
                  onPressed: _showWeeklyGoalPicker,
                  child: const Text("Change"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutGoalCard() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Minimum Workout Time',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$minExerciseGoal ${minExerciseGoal == 1 ? "minute" : "minutes"}",
                ),
                ElevatedButton(
                  onPressed: _showMinGoalPicker,
                  child: const Text("Change"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
