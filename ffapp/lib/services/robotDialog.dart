
//this is just a class that hold a dictionary of possible robot dialogs
//it contains methods that can be called that return the respective list of
//quotes

import 'dart:ffi';

class RobotDialog {
  final _robotDialog = {
    'dashboard': {
      'low': [
       "Warning: Energy reserves critically low. Let’s power up with some squats!",
       "Running on fumes! Push-ups will recharge our circuits!",
       "Warning: Critical charge level. Let’s finish strong with a sprint!",
       "Emergency charge needed. Channel your inner sprinter!",
       "Low charge remaining. Let's not give up now!",
       "Low battery remaining. Let's workout so we can both get stronger!"
       ],
      'medium': [
                 "We're doing alright right now. Keep at it!",
                 "Keep working out, you're doing great!"
              
                ],
      'high': [
               "Power levels soaring! You've almost reached your goal!",
               "You've almost reached your goal! Finish it off!",
               "You're a super fitness figure.",
               "Smooth sailing from here! Keep at it!",
               "You're almost there! Just a little more to reach your goal!"
              ]
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