import 'package:flutter/material.dart';

class WorkoutAdder extends StatefulWidget {
  const WorkoutAdder({super.key});

  @override
  State<WorkoutAdder> createState() => _WorkoutAdderState();
}

class _WorkoutAdderState extends State<WorkoutAdder> {

  bool _logging = false;
  //TO DO: SET A TIME PASSED AND UPDATE IT ON THE UI

  void startLogging() {
    setState(() {
      _logging = true;
    });
  }

  void endLogging() {
    setState(() {
      _logging = false;
    });
  }

  @override 
  Widget build(BuildContext context) {
    if (!_logging) {
        return Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: startLogging, child: const Text("Log a Workout"))
          ],
                ),
        );
    }
    else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [ 
            const Text("0:00"),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: endLogging, child: const Text("End Workout"))
          ],
        ),
      );
    }
  }
}