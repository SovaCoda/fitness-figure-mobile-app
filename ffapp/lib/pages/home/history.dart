import 'package:ffapp/components/button_themes.dart';
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
  late final ValueNotifier<List<Routes.Workout>> _selectedEvents =
      ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    auth = Provider.of<AuthService>(context, listen: false);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      initialize();
    });
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  void initialize() async {
    List<Routes.Workout> workouts = await auth.getWorkouts().then((value) {
      return value.workouts;
    });
    Provider.of<HistoryModel>(context, listen: false).setWorkouts(workouts);
    setState(() {
      _workouts = workouts;
    });
  }

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

  Future<List<Routes.Workout>> getWorkouts() async {
    List<Routes.Workout> workouts = [];
    Routes.MultiWorkout recievedWorkouts;
    try {
      recievedWorkouts = await auth.getWorkouts();
      for (var workout in recievedWorkouts.workouts) {
        workouts.add(workout);
      }
    } catch (e) {
      logger.e(e);
    }
    return workouts;
  }

  String formatSeconds(int seconds) {
    final formatter = NumberFormat('00');
    String hours = formatter.format((seconds / 3600).floor());
    String minutes = formatter.format(((seconds % 3600) / 60).floor());
    String second = formatter.format((seconds % 60));
    return "$hours:$minutes:$second";
  }

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        WorkoutCalendar(
          calendarFormat: CalendarFormat.month,
          isInteractable: true,
        )
      ],
    );
  }
}
