import 'package:ffapp/components/button_themes.dart';
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
  late List<Routes.Workout> workoutsFuture;
  late final ValueNotifier<List<Routes.Workout>> _selectedEvents;

  @override
  void initState() {
    super.initState();
    auth = Provider.of<AuthService>(context, listen: false);
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier([]);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var workouts =
          await getWorkouts(); // Assuming getWorkouts() is an async function returning a List<Workout>
      setState(() {
        workoutsFuture = workouts;
        _selectedEvents.value = _getWorkoutsForDay(_selectedDay!);
      });
    });
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Routes.Workout> _getWorkoutsForDay(DateTime day) {
    List<Routes.Workout> workouts = [];
    for (var workout in workoutsFuture) {
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
    return Column(
      children: [
        TableCalendar(
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                // Call `setState()` when updating calendar format
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              // No need to call `setState()` here
              _focusedDay = focusedDay;
            },
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _selectedEvents.value = _getWorkoutsForDay(selectedDay);
              });
            },
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 10, 16),
            focusedDay: _focusedDay,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
              leftChevronIcon: Icon(
                Icons.chevron_left,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
                weekendStyle:
                    TextStyle(color: Theme.of(context).colorScheme.secondary)),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryFixedDim,
                shape: BoxShape.rectangle,
              ),
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.rectangle,
              ),
              weekendTextStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
              weekNumberTextStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
              defaultTextStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
            )),
        ValueListenableBuilder<List<Routes.Workout>>(
            valueListenable: _selectedEvents,
            builder: (context, value, _) {
              if (value.isEmpty && _selectedDay!.isAfter(DateTime.now())) {
                return Center(
                  child: Text(
                    'No workouts for this day, but its hard to workout in the future!',
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer),
                  ),
                );
              } else if (value.isEmpty) {
                return Center(
                  child: Text(
                    'No workouts for this day',
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer),
                  ),
                );
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return WorkoutHistoryView(
                        dateTime: value[index].endDate,
                        chargeGain: value[index].chargeAdd.toInt(),
                        currencyGain: value[index].currencyAdd.toInt(),
                        elapsedTime:
                            formatSeconds(value[index].elapsed.toInt()),
                        evoGain: 30,
                        robotUrl: "robot1/robot1_skin0_evo0_cropped_happy",
                      );
                    },
                  ),
                );
              }
            })
      ],
    );
  }
}
