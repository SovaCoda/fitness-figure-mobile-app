import 'dart:math';

import 'package:ffapp/components/utils/time_utils.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/services/auth.dart';
import 'package:ffapp/services/routes.pb.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryModel extends ChangeNotifier {
  List<Workout> workouts = List.empty();
  bool workedOutToday = false;
  AuthService? auth;
  double investment = 0;
  double lastWeekInvestment = 0;

  List<int> currentWeek = List.filled(7, 0, growable: false);
  List<int> lastWeek = List.filled(7, 0, growable: false);

  void retrieveWorkouts() async {
    auth = await AuthService.instance;
    List<Workout> newWorkouts = await auth!.getWorkouts().then((value) {
      return value.workouts;
    });
    setWorkouts(newWorkouts);
    logger.i("retrieved ${newWorkouts.length} workouts");
  }

  void addWorkout(Workout workout) {
    auth!.createWorkout(workout);
    workouts.add(workout);
    setWorkouts(workouts);
  }

  DateTime mostRecentSunday(DateTime date) {
    return DateTime(date.year, date.month, date.day - date.weekday % 7);
  }

  void setInvestment(double newInvestment) {
    investment = newInvestment;
    notifyListeners();
  }

  void setWorkouts(List<Workout> newWorkouts) {
    investment = 0;
    lastWeekInvestment = 0;
    workedOutToday = false;
    DateTime now = DateTime.now().toLocal();
    DateTime weekstart = mostRecentSunday(now); // get week start (sunday is 7)
    List<DateTime?> workoutsInCurrentWeek = List.filled(7, null,
        growable: false); // track workouts in our current week
    for (int i = 0; i < newWorkouts.length; i++) {
      DateTime curDate = DateTime.parse(newWorkouts[i].endDate).toLocal();
      int currentCountable = newWorkouts[i].countable;
      
      bool goalMet = currentCountable == 1;

      if (curDate.isAfter(weekstart) && goalMet) {
        workoutsInCurrentWeek[curDate.weekday % 7] = curDate;
      } // if workout is in our current week add it to our list
      if (curDate.day == now.day &&
          curDate.month == now.month &&
          curDate.year == now.year &&
          goalMet) {
        workedOutToday = true;
      }
    }

    for (int i = 0; i < 7; i++) {
      DateTime curDate = weekstart.add(Duration(days: i));
      for (int j = 0; j < newWorkouts.length; j++) {
        DateTime workoutDate = DateTime.parse(newWorkouts[j].endDate);
        if (workoutDate.day == curDate.day &&
            workoutDate.month == curDate.month &&
            workoutDate.year == curDate.year) {
          investment += newWorkouts[j].investment;
        }
      }
    }

    

    // take the day subtract 7 days to get the last week
    // determine the start of that day's week
    // go through 7 dates and check the status of those workouts
    // add those statuses to the last week list

    DateTime lastWeekStart = mostRecentSunday(
        now.subtract(Duration(days: 7))); // get week start (sunday is 7)
    List<DateTime?> workoutsInLastWeek = List.filled(7, null,
        growable: false); // track workouts in our last week
    for (int i = 0; i < 7; i++) {
      DateTime curDate = lastWeekStart.add(Duration(days: i));
      for (int j = 0; j < newWorkouts.length; j++) {
        DateTime workoutDate = DateTime.parse(newWorkouts[j].endDate);
        if (workoutDate.day == curDate.day &&
            workoutDate.month == curDate.month &&
            workoutDate.year == curDate.year) {
          workoutsInLastWeek[curDate.weekday % 7] = curDate;
          lastWeekInvestment += newWorkouts[j].investment;
        }
      }
    }

    

    for (int i = 0; i < lastWeek.length; i++) {
      int status = 0;
      if (workoutsInLastWeek[i] == null &&
          lastWeekStart.add(Duration(days: i)).isBefore(now)) {
        status = 0;
      } // in the past didnt workout Dark Green
      if (workoutsInLastWeek[i] == null &&
          lastWeekStart.add(Duration(days: i)).isAfter(now)) {
        status = 1;
      } // in the future hasnt workedout Gray Surface
      if (workoutsInLastWeek[i] != null) {
        status = 2;
      } // worked out Bright Green

      lastWeek[i] = status;
    }

    for (int i = 0; i < currentWeek.length; i++) {
      int status = 0;
      if (workoutsInCurrentWeek[i] == null &&
          weekstart.add(Duration(days: i)).isBefore(now)) {
        status = 0;
      } // in the past didnt workout Dark Green
      if (workoutsInCurrentWeek[i] == null &&
          weekstart.add(Duration(days: i)).isAfter(now)) {
        status = 1;
      } // in the future hasnt workedout Gray Surface
      if (workoutsInCurrentWeek[i] != null) {
        status = 2;
      } // worked out Bright Green

      currentWeek[i] = status;
    }
    workouts = newWorkouts;
    notifyListeners();
  }

  Future<Map<String, List<FlSpot>>> getWeekData(
      String userEmail,
      int maxEv,
      String figureName,
      DateTime date,
      int curCharge,
      int curEv,
      int curStreak,
      int curWeekComplete) async {
    //get the start of the week in utc
    //loop through the week days and get the total charge and ev for that day from the snapshots (snapshots are a day ahead in utc subtract 1 day)
    //add the total charge and ev to the list
    //return the list
    auth = await AuthService.instance;
    List<DailySnapshot> snapshots = await auth!
        .getDailySnapshots(
            DailySnapshot(userEmail: userEmail, figureName: figureName))
        .then(
      (value) {
        return value.dailySnapshots;
      },
    );

    DateTime weekstart = mostRecentSunday(date);
    Map<String, List<FlSpot>> weekData = {
      "charge": [],
      "ev": [],
      "changes": [],
      "streakAndGoal": []
    };

    snapshots = snapshots
        .where((element) => (DateTime.parse(element.date)
                .isAfter(weekstart.add(const Duration(days: 1))) &&
            DateTime.parse(element.date)
                .isBefore(weekstart.add(const Duration(days: 8)))))
        .toList();

    if (isSameDay(mostRecentSunday(date), mostRecentSunday(DateTime.now()))) {
      snapshots.add(DailySnapshot(
          date: DateTime.now().add(Duration(days: 1)).toString(),
          charge: curCharge,
          evPoints: curEv,
          userStreak: curStreak,
          userWeekComplete: curWeekComplete));
    }

    if (snapshots.isNotEmpty) {
      weekData['changes']!.add(FlSpot(
          (snapshots.last.charge - snapshots.first.charge).toDouble(),
          (snapshots.last.evPoints - snapshots.first.evPoints).toDouble()));

      weekData['streakAndGoal']!.add(FlSpot(
          (snapshots.last.userStreak - snapshots.first.userStreak).toDouble(),
          (snapshots.last.userWeekComplete).toDouble()));
    }

    int snapshotIterator = 0;
    for (int i = 0; i < 7; i++) {
      if (snapshotIterator < snapshots.length) {
        if (isSameDay(weekstart.add(Duration(days: i + 1)),
            DateTime.parse(snapshots[snapshotIterator].date))) {
          weekData['charge']!.add(FlSpot(
              i.toDouble() + 1, snapshots[snapshotIterator].charge.toDouble()));

          double displayEv = snapshots[snapshotIterator].evPoints.toDouble();
          if (snapshots[snapshotIterator].evPoints > maxEv) {
            displayEv = maxEv.toDouble();
          }
          weekData['ev']!.add(FlSpot(i.toDouble() + 1, displayEv));
          snapshotIterator++;
          continue;
        }
      }
    }

    return weekData;
  }
}
