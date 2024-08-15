import 'package:ffapp/main.dart';
import 'package:ffapp/services/routes.pb.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryModel extends ChangeNotifier {
  List<Workout> workouts = List.empty();
  bool workedOutToday = false;

  List<int> currentWeek = List.filled(7, 0, growable: false);

  DateTime mostRecentSunday(DateTime date) {
    return DateTime(date.year, date.month, date.day - date.weekday % 7);
  }

  void setWorkouts(List<Workout> newWorkouts, BuildContext context) {
    DateTime now = DateTime.now().toLocal();
    DateTime weekstart = mostRecentSunday(now); // get week start (sunday is 7)
    List<DateTime?> workoutsInCurrentWeek = List.filled(7, null,
        growable: false); // track workouts in our current week
    int minTime = Provider.of<UserModel>(context, listen: false)
        .user!
        .workoutMinTime
        .toInt();
    for (int i = 0; i < newWorkouts.length; i++) {
      DateTime curDate = DateTime.parse(newWorkouts[i].endDate);
      bool goalMet = newWorkouts[i].elapsed.toInt() / 60 >= minTime;

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

  Map<String, List<FlSpot>> getWeekData(
      DateTime date, int curCharge, int curEv) {
    DateTime weekstart = mostRecentSunday(date);
    Map<String, List<FlSpot>> weekData = {"ev": [], "charge": []};

    List<int> chargeAdds = [];
    List<int> evAdds = [];

    for (int i = 0; i < 7; i++) {
      DateTime curDate = weekstart.add(Duration(days: i));
      int charge = 0;
      int ev = 0;
      bool foundWorkout = false;
      if (curDate.isAfter(DateTime.now())) {
        break;
      }
      for (int j = 0; j < workouts.length; j++) {
        DateTime workoutDate = DateTime.parse(workouts[j].endDate);
        if (workoutDate.day == curDate.day &&
            workoutDate.month == curDate.month &&
            workoutDate.year == curDate.year) {
          charge += workouts[j].chargeAdd.toInt();
          ev += workouts[j].currencyAdd.toInt();
          foundWorkout = true;
        }
        if (j == workouts.length - 1 && !foundWorkout) {
          charge = -5;
        }
      }
      chargeAdds.add(charge);
      evAdds.add(ev);
    }
    int totalCharge = curCharge;
    int totalEv = curEv;

    List<int> oldChargeAdds = chargeAdds;
    chargeAdds.last = curCharge;

    List<int> oldEvAdds = evAdds.toList();
    evAdds.last = curEv;

    for (int i = chargeAdds.length - 2; i >= 0; i--) {
      chargeAdds[i] = oldChargeAdds[i] + chargeAdds[i + 1];
      evAdds[i] = evAdds[i + 1] - oldEvAdds[i + 1];
    }

    for (int i = 7; i > 0; i--) {
      if (i > chargeAdds.length) {
        weekData["charge"]!.add(FlSpot(i.toDouble(), 0));
        weekData["ev"]!.add(FlSpot(i.toDouble(), 0));
        continue;
      } else {
        weekData["charge"]!
            .add(FlSpot(i.toDouble(), chargeAdds[i - 1].toDouble()));
        weekData["ev"]!.add(FlSpot(i.toDouble(), evAdds[i - 1].toDouble()));
      }
    }

    return weekData;
  }
}
