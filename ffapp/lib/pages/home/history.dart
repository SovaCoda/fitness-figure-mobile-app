import 'package:ffapp/components/utils/history_model.dart';
import 'package:ffapp/components/workout_calendar.dart';
import 'package:ffapp/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => HistoryState();
}

class HistoryState extends State<History> {
  late AuthService auth;
  // late List<Routes.Workout> _workouts;

  @override
  void initState() {
    Provider.of<HistoryModel>(context, listen: false).retrieveWorkouts();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initialize();
    });
  }

  Future<void> initialize() async {}

  // List<Routes.Workout> _getWorkoutsForDay(DateTime day) {
  //   final List<Routes.Workout> workouts = [];
  //   for (final workout in _workouts) {
  //     final DateTime date = DateTime.parse(workout.endDate);
  //     if (date.year == day.year &&
  //         date.month == day.month &&
  //         date.day == day.day) {
  //       workouts.add(workout);
  //     }
  //   }
  //   return workouts;
  // }

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        WorkoutCalendar(
          showWorkoutData: true,
          calendarFormat: CalendarFormat.month,
        ),
      ],
    );
  }
}
