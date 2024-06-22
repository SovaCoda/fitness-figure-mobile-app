import 'package:ffapp/services/auth.dart';
import 'package:ffapp/services/routes.pb.dart' as Routes;
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
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              Routes.Workout? workout = snapshot.data?[index];
              return ListTile(
                title: Text(workout!.startDate, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                subtitle: 
                DefaultTextStyle(
                  style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.secondary),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Elapsed time: ${formatSeconds(workout.elapsed.toInt())}'),
                      Text('Charge gained: ${workout.chargeAdd}'),
                      Text('Currency gained: ${workout.currencyAdd}'),
                    ],
                  )
                ),
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
