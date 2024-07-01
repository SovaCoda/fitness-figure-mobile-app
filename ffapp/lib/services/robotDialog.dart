
//this is just a class that hold a dictionary of possible robot dialogs
//it contains methods that can be called that return the respective list of
//quotes


class RobotDialog {
  final _robotDialog = {
    'dashboard': {
      'low': ["I'm dying without battery :(", "I'm low on battery!"],
      'medium': ["We're doing alright right now.", "Keep working out, you're doing good!"],
      'high': ["This is going great!", "You're a super fitness figure."]
    },
    'logger': {
      'start': ["Starting is always the hardest part!", "This is going to be a great workout."],
      'middle': ["Keep going. Don't give up!", "Push through the pain!"],
      'end': ["We're almost finished.", "My battery is about to be so high!"]
    }
  };

  List<String> getDashboardDialog(int charge) {
    if (charge < 35) {
      return _robotDialog['dashboard']!['low']!;
    }
    else if (charge < 70) {
      return _robotDialog['dashboard']!['medium']!;
    }
    else {
      return _robotDialog['dashboard']!['high']!;
    }
  }

  List<String> getLoggerDialog(int timeElapsed, int goalTime) {
    if (timeElapsed / goalTime < .30) {
      return _robotDialog['logger']!['start']!;
    }
    else if (timeElapsed / goalTime < .70) {
      return _robotDialog['logger']!['middle']!;
    }
    else {
      return _robotDialog['logger']!['end']!;
    }
  }
}