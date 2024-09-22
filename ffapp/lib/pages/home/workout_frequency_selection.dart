import 'package:ffapp/main.dart';
import 'package:ffapp/services/flutterUser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wheel_slider/wheel_slider.dart';
import 'package:go_router/go_router.dart';
import "package:ffapp/services/routes.pb.dart" as Routes;
import 'package:fixnum/fixnum.dart';

class WorkoutFrequencySelection extends StatefulWidget {
  const WorkoutFrequencySelection({super.key});

  @override
  State<WorkoutFrequencySelection> createState() =>
      _WorkoutFrequencySelectionState();
}

class _WorkoutFrequencySelectionState extends State<WorkoutFrequencySelection> {
  bool _sliderDisplayed = false;
  Int64 _nCurrentValue = Int64(4);
  Int64 _mCurrentValue = Int64(30); // Added variable for minutes selection
  FlutterUser user = FlutterUser();
  String curEmail = "Loading...";

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    await user.initAuthService();
    await user.checkUser();
    curEmail = await user.getEmail();
  }

  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text),
      duration: const Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void displaySlider() {
    setState(() {
      _sliderDisplayed = true;
    });
  }

  void closeSlider() {
    setState(() {
      _sliderDisplayed = false;
    });
  }

  void submitFrequency() {
    if (_mCurrentValue == 0 || _nCurrentValue ==0) {return;}
    Routes.User newUser = Routes.User(
        weekGoal: _nCurrentValue,
        email: curEmail,
        workoutMinTime: _mCurrentValue);
    user.updateUser(newUser); // Updated workoutMinTime value

    Provider.of<UserModel>(context, listen: false).setUser(newUser);
    context.goNamed('Home');
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("Select your weekly workout goal: ",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
              )
          ),

          const SizedBox(height: 30),

          //if slider is displayed the show the slider, else show the selection
          _sliderDisplayed
              ? Column(children: [
                  // TO DO: FIGURE OUT WHY THIS ISNT WORKING... IT LOOKS REALLY GOOD BUT DOESNT SLIDE ON MY DEVICE AT LEAST - REESE
                  WheelSlider.number(
                    allowPointerTappable: true,
                    perspective: 0.01,
                    totalCount: 10,
                    initValue: 4,
                    selectedNumberStyle: TextStyle(
                      fontSize: 28,
                      color: Theme.of(context).colorScheme.onSurface,
                      decoration: TextDecoration.none,
                    ),
                    unSelectedNumberStyle: TextStyle(
                      fontSize: 20.0,
                      color: Theme.of(context).colorScheme.outline,
                      decoration: TextDecoration.none,
                    ),
                    currentIndex: _nCurrentValue.toInt(),
                    onValueChanged: (val) {
                      setState(() {
                        if(_nCurrentValue == 0) {showSnackBar(context, 'Workout weekly goal cannot be zero');}
                        _nCurrentValue = Int64(val.toInt());
                      });
                    },
                    hapticFeedbackType: HapticFeedbackType.heavyImpact,
                  ),
                  const SizedBox(height: 60,),
                  Text("Select your minutes per workout goal: ",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                      )
                  ),
                  const SizedBox(height: 30),
                  WheelSlider.number( // Added another WheelSlider for minutes selection
                    allowPointerTappable: true,
                    perspective: 0.0015,
                    totalCount: 60,
                    initValue: 30,
                    itemSize: 50,
                    interval: 5,
                    selectedNumberStyle: TextStyle(
                      fontSize: 28,
                      color: Theme.of(context).colorScheme.onSurface,
                      decoration: TextDecoration.none,
                    ),
                    unSelectedNumberStyle: TextStyle(
                      fontSize: 20.0,
                      color: Theme.of(context).colorScheme.outline,
                      decoration: TextDecoration.none,
                    ),
                    currentIndex: _mCurrentValue.toInt(),
                    onValueChanged: (val) {
                      setState(() {
                        if(_mCurrentValue == 0) {showSnackBar(context, 'Workout time cannot be zero');}
                        _mCurrentValue = Int64(val.toInt());
                      });
                    },
                    hapticFeedbackType: HapticFeedbackType.heavyImpact,
                  ),
                  const SizedBox(height: 60),
                  ElevatedButton(
                      onPressed: closeSlider, child: const Text("Close Slider"))
                ])
              : Column(children: [
                  SizedBox(
                    height: 100,
                    width: 150,
                    child: ElevatedButton(
                        onPressed: displaySlider,
                        child: Text("$_nCurrentValue days\n$_mCurrentValue mins",
                            style: const TextStyle(fontSize: 22))),
                  ),
                  const SizedBox(height: 60),
                  ElevatedButton(
                      onPressed: submitFrequency,
                      child: const Text("Submit Workout Frequency"))
                ])
        ]),
      )),
    ));
  }
}
