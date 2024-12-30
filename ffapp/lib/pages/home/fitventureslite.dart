import 'package:ffapp/components/mission.dart';
import 'package:flutter/material.dart';
import 'package:ffapp/assets/data/missions_data.dart';
import 'package:provider/provider.dart';


class FitVenturesLite extends StatefulWidget {
  const FitVenturesLite({super.key});

  @override
  FitVenturesLiteState createState() => FitVenturesLiteState();
}

class FitventuresMissionManagerProvider with ChangeNotifier {
  late MissionListWidget _currentMission = MissionListWidget(
    missionName: "null",
    url: "not",
    moneyReward: 0,
    evoReward: 0,
    chargeReward: 0,
    seconds: 0,
    onStart: () {},
  );

  MissionListWidget get currentMission => _currentMission;

  void startMission(MissionListWidget mission) {
    _currentMission = mission;
    notifyListeners();
  }

  void completeMission() {
    _currentMission = MissionListWidget(
      missionName: "null",
      url: "not",
      moneyReward: 0,
      evoReward: 0,
      chargeReward: 0,
      seconds: 0,
      onStart: () {},
    );
    notifyListeners();
  }
}

class FitVenturesLiteState extends State<FitVenturesLite> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:(context) => FitventuresMissionManagerProvider(),
      child: Center(
        child: 
        MissionList(
          missions: missionList,
        ),
      ),
    );
  }
}