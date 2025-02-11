import 'dart:async';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

String formatSeconds(int seconds) {
  final formatter = NumberFormat('00');
  String hours = formatter.format((seconds / 3600).floor());
  String minutes = formatter.format(((seconds % 3600) / 60).floor());
  String second = formatter.format((seconds % 60));
  return "$hours:$minutes:$second";
}

bool isSameDay(DateTime date1, DateTime date2) {
  return date1.day == date2.day &&
      date1.month == date2.month &&
      date1.year == date2.year;
}

DateTime mostRecentSunday(DateTime date) {
  return DateTime(date.year, date.month, date.day - date.weekday % 7);
}

class PersistantTimer {
  PersistantTimer(
      {required this.timerName,
      required this.prefs,
      this.milliseconds = 0,
      this.onTick,
      this.tickSpeedMS = 1000});

  SharedPreferences? prefs;
  void Function()? onTick;
  String timerName;
  int tickSpeedMS;
  int milliseconds = 0;
  int addableTime = 1000;
  Timer? classTimer;
  Logger logger = Logger();

  Future storeTime() async {
    DateTime now = DateTime.now();

    await prefs!.setString('$timerName timerStarted', now.toString());
  }

  Future storeDisposalTime() async {
    DateTime now = DateTime.now();

    await prefs!.setString('$timerName disposedAt', now.toString());
  }

  Future storePauseTime() async {
    DateTime now = DateTime.now();

    await prefs!.setString('$timerName pausedAt', now.toString());
  }

  bool hasStoredTime() {
    return prefs!.containsKey('$timerName timerStarted');
  }

  bool hasStoredPauseTime() {
    return prefs!.containsKey('$timerName pausedAt');
  }

  bool hasStoredDisposalTime() {
    return prefs!.containsKey('$timerName disposedAt');
  }

  Future<int?> loadTime() async {
    if (hasStoredPauseTime()) {
      String? pausedAt = prefs!.getString('$timerName pausedAt');
      DateTime pausedAtDate = DateTime.parse(pausedAt!);
      DateTime now = DateTime.now();
      prefs!.setString('$timerName pausedAt', now.toString());
      int differenceInMS = now.difference(pausedAtDate).inMilliseconds;
      DateTime newStartDate =
          DateTime.parse(prefs!.getString('$timerName timerStarted')!)
              .add(Duration(milliseconds: differenceInMS));
      prefs!.setString('$timerName timerStarted', newStartDate.toString());
      int difference = now.difference(newStartDate).inMilliseconds;
      milliseconds = difference;
      if (classTimer != null) {
        classTimer!.cancel();
      }
      return 0;
    }

    if (hasStoredDisposalTime()) {
      String? disposedAt = prefs!.getString('$timerName disposedAt');
      DateTime disposedAtDate = DateTime.parse(disposedAt!);
      DateTime now = DateTime.now();
      prefs!.remove('$timerName disposedAt');
      int differenceInSeconds = now.difference(disposedAtDate).inSeconds;
      if (classTimer != null) {
        classTimer!.cancel();
      }
      classTimer = Timer.periodic(Duration(milliseconds: tickSpeedMS), (timer) {
        milliseconds += addableTime;
        if (onTick != null) {
          onTick!();
        }
      });
      return differenceInSeconds;
    }

    String? timerStarted = prefs!.getString('$timerName timerStarted');
    DateTime timerStartedDate;
    try {
      timerStartedDate = DateTime.parse(timerStarted!);
    } catch (e) {
      logger.e("Error parsing timerStartedDate: $e");
      milliseconds = 0;
      deleteTimer();
      return 0;
    }

    // if (pausedAt != null) {
    //   DateTime pausedAtDate = DateTime.parse(pausedAt);
    //   int differenceInSeconds =
    //       pausedAtDate.difference(DateTime.now()).inSeconds * -1;
    //   timerStarted = timerStartedDate!
    //       .add(Duration(seconds: differenceInSeconds))
    //       .toString();
    //   await prefs!.setString('$timerName timerStarted', timerStarted.toString());
    //   await prefs!.remove('$timerName pausedAt');
    //   timerStartedDate = DateTime.parse(timerStarted);
    // }

    DateTime now = DateTime.now();
    int difference = ((now.difference(timerStartedDate).inMilliseconds *
            ((1 - (tickSpeedMS / 1000)) + 1)))
        .round();
    if (classTimer != null) {
      classTimer!.cancel();
    }
    milliseconds = difference;
    classTimer = Timer.periodic(Duration(milliseconds: tickSpeedMS), (timer) {
      milliseconds += addableTime;
      if (onTick != null) {
        onTick!();
      }
    });
    return 1;
  }

  void changeTickSpeedMS(int tickSpeedMS) {
    if (classTimer != null) {
      classTimer!.cancel();
      classTimer = Timer.periodic(Duration(milliseconds: tickSpeedMS), (timer) {
        milliseconds += addableTime;
        if (onTick != null) {
          onTick!();
        }
      });
    }
  }

  int getTimeInMilliseconds() {
    return milliseconds;
  }

  int getTimeInSeconds() {
    return milliseconds ~/ 1000;
  }

  int getTimeInMinutes() {
    return milliseconds ~/ 60000;
  }

  int getDisposalDifferenceInSeconds() {
    if (hasStoredDisposalTime()) {
      String? disposedAt = prefs!.getString('$timerName disposedAt');
      DateTime disposedAtDate = DateTime.parse(disposedAt!);
      DateTime now = DateTime.now();
      int differenceInSeconds = now.difference(disposedAtDate).inSeconds;
      return differenceInSeconds;
    }
    return 0;
  }

  void addTime(int addableMilliseconds) {
    milliseconds += addableMilliseconds;
  }

  void pause() {
    classTimer!.cancel();
    storePauseTime();
  }

  void resume() {
    String? pausedAt = prefs!.getString('$timerName pausedAt');
    DateTime pausedAtDate = DateTime.parse(pausedAt!);
    DateTime now = DateTime.now();
    int differenceInMS = now.difference(pausedAtDate).inMilliseconds;
    DateTime newStartDate =
        DateTime.parse(prefs!.getString('$timerName timerStarted')!)
            .add(Duration(milliseconds: differenceInMS));

    prefs!.remove('$timerName pausedAt');
    prefs!.remove('$timerName pausedAt');
    prefs!.setString('$timerName timerStarted', newStartDate.toString());

    classTimer = Timer.periodic(Duration(milliseconds: tickSpeedMS), (timer) {
      milliseconds += tickSpeedMS;
      if (onTick != null) {
        onTick!();
      }
    });
  }

  Future<int?> start() async {
    addableTime = 1000;
    if (hasStoredTime() || hasStoredDisposalTime()) {
      return loadTime();
    }

    classTimer = Timer.periodic(Duration(milliseconds: tickSpeedMS), (timer) {
      milliseconds += addableTime;
      if (onTick != null) {
        onTick!();
      }
    });
    prefs!.setString('$timerName timerStarted', DateTime.now().toString());
    return 0;
  }

  void stop() {
    if (classTimer != null) classTimer!.cancel();
  }

  void dispose() {
    classTimer!.cancel();
  }

  void deleteTimer() {
    prefs!.remove('$timerName timerStarted');
    prefs!.remove('$timerName pausedAt');
    prefs!.remove('$timerName disposedAt');
    stop();
  }
}
