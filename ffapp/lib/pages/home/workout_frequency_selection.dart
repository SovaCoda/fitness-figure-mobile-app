import 'dart:ui';

import 'package:bottom_picker/bottom_picker.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../components/ff_app_button.dart';
import '../../components/resuables/gradiented_container.dart';
import '../../components/robot_image_holder.dart';
import '../../main.dart';
import '../../services/auth.dart';
import '../../services/flutterUser.dart';
import '../../services/routes.pb.dart' as routes;

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
  String curEmail = 'Loading...';
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
    showModalBottomSheet(
      context: context,
      enableDrag: false,
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
                            updateWeeklyGoal(weeklyGoal);
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

  Future<void> updateWeeklyGoal(int goal) async {
    // await auth.updateWeeklyGoal(goal);
    Provider.of<UserModel>(context, listen: false).setUserWeekGoal(Int64(goal));
    setState(() {
      _nCurrentValue = Int64(goal);
    });
  }

  Future<void> updateMinWorkoutTime(int time) async {
    Provider.of<UserModel>(context, listen: false)
        .setWorkoutMinTime(Int64(time));
    setState(() {
      _mCurrentValue = Int64(time);
    });
  }

  void _showMinGoalPicker() {
    final int safeWeeklyGoal = weeklyGoal.clamp(1, 12);
    showModalBottomSheet(
        context: context,
        enableDrag: false,
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
                        updateMinWorkoutTime(minExerciseGoal);
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
    return Stack(children: [
      OverflowBox(
          maxWidth: MediaQuery.sizeOf(context).width,
          maxHeight: MediaQuery.sizeOf(context).height,
          child: Image.asset(
            'lib/assets/art/ff_background.png',
            width: MediaQuery.sizeOf(context).width + 200,
            height: MediaQuery.sizeOf(context).height,
          )),
      Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ListView(children: [
              const SizedBox(height: 40),
              Center(
                child: Text(
                  'Set Your Workout Goals',
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
                          '${figure.figure!.figureName}/${figure.figure!.figureName}_skin0_evo0_cropped_happy',
                    ),
                  );
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              GradientedContainer(
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
                      _buildWeeklyGoalCard(),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                      _buildWorkoutGoalCard(),
                      const SizedBox(height: 40),
                      FFAppButton(
                        onPressed: submitFrequency,
                        text: 'Activate Workout Mode',
                        size: MediaQuery.of(context).size.width * 1,
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ]),
          )))
    ]);
  }

  Widget _buildWeeklyGoalCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '$weeklyGoal ${weeklyGoal == 1 ? "day" : "days"}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Roboto',
                ),
              ),
              const Text(
                'Weekly Workout Goal',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  color: Color.fromARGB(255, 145, 145, 145),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: _showWeeklyGoalPicker,
            child: const Icon(Icons.edit, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutGoalCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '$minExerciseGoal ${minExerciseGoal == 1 ? "minute" : "minutes"}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Roboto',
                ),
              ),
              const Text(
                'Minimum Workout Time',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  color: Color.fromARGB(255, 145, 145, 145),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: _showMinGoalPicker,
            child: const Icon(Icons.edit, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
