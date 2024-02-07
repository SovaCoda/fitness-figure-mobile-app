import 'package:ffapp/services/flutterUser.dart';
import 'package:flutter/material.dart';
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
    //TO DO: SEND FREQUENCY TO BACKEND AND REDIRECT TO HOME
    user.updateUser(Routes.User(weekGoal: _nCurrentValue, email: curEmail));
    context.goNamed('Home');
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text("Select your weekly workout goal: ",
              style: TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),

          const SizedBox(height: 60),

          //if slider is displayed the show the slider, else show the selection
          _sliderDisplayed
              ? Column(children: [
                  // TO DO: FIGURE OUT WHY THIS ISNT WORKING... IT LOOKS REALLY GOOD BUT DOESNT SLIDE ON MY DEVICE AT LEAST - REESE
                  WheelSlider.number(
                    allowPointerTappable: true,
                    perspective: 0.01,
                    totalCount: 10,
                    initValue: 4,
                    selectedNumberStyle: const TextStyle(
                      fontSize: 28,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                    unSelectedNumberStyle: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.grey,
                      decoration: TextDecoration.none,
                    ),
                    currentIndex: _nCurrentValue.toInt(),
                    onValueChanged: (val) {
                      setState(() {
                        _nCurrentValue = Int64(val.toInt());
                      });
                    },
                    hapticFeedbackType: HapticFeedbackType.heavyImpact,
                  ),
                  const SizedBox(height: 60),
                  ElevatedButton(
                      onPressed: closeSlider, child: const Text("Close Slider"))
                ])
              : Column(children: [
                  Container(
                    height: 45,
                    width: 90,
                    child: ElevatedButton(
                        onPressed: displaySlider,
                        child: Text(_nCurrentValue.toString(),
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
