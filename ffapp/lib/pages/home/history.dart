import 'package:ffapp/components/workout_history_view.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/services/auth.dart';
import 'package:ffapp/services/routes.pb.dart' as Routes;
import 'package:ffapp/services/routes.pbgrpc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => HistoryState();
}

class HistoryState extends State<History> {
  late AuthService auth;
  late Future<List<Routes.Workout>> workoutsFuture;

  @override
  void initState() {
    super.initState();
    auth = Provider.of<AuthService>(context, listen: false);
    workoutsFuture = getWorkouts();
  }

  Future<List<Routes.Workout>> getWorkouts() async {
    List<Routes.Workout> workouts = [];
    Routes.MultiWorkout recievedWorkouts;
    try {
      recievedWorkouts = await auth.getWorkouts();
      for (var workout in recievedWorkouts.workouts) {
        workouts.add(workout);
        logger.i(workout);
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Routes.Workout>>(
      future: workoutsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Routes.Workout? workout = snapshot.data?[index];
              
              return WorkoutHistoryView(
                robotUrl: "lib/assets/robot1/robot1_skin0_evo0_cropped_happy.gif",
                dateTime: workout?.startDate ?? "",
                elapsedTime: formatSeconds(workout!.elapsed.toInt()) ?? '00:00:00',
                chargeGain: workout?.chargeAdd.toInt() ?? 0,
                evoGain: 0, // needs hookup
                currencyGain: workout?.currencyAdd.toInt() ?? 0,
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
