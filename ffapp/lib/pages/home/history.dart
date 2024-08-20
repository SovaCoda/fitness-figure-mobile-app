import 'package:ffapp/components/button_themes.dart';
import 'package:ffapp/components/utils/history_model.dart';
import 'package:ffapp/components/workout_calendar.dart';
import 'package:ffapp/components/workout_history_view.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/services/auth.dart';
import 'package:ffapp/services/routes.pb.dart' as Routes;
import 'package:ffapp/services/routes.pbgrpc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => HistoryState();
}

class HistoryState extends State<History> {
  late AuthService auth;
  late List<Routes.Workout> _workouts;

  @override
  void initState() {
    Provider.of<HistoryModel>(context, listen: false).retrieveWorkouts();
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      initialize();
    });
  }

  void initialize() async {}

  List<Routes.Workout> _getWorkoutsForDay(DateTime day) {
    List<Routes.Workout> workouts = [];
    for (var workout in _workouts) {
      DateTime date = DateTime.parse(workout.endDate);
      if (date.year == day.year &&
          date.month == day.month &&
          date.day == day.day) {
        workouts.add(workout);
      }
    }
    return workouts;
  }

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        WorkoutCalendar(
          showWorkoutData: true,
          calendarFormat: CalendarFormat.month,
          isInteractable: true,
        )
      ],
    );
  }
}
