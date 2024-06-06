import 'package:ffapp/components/Mission.dart';
import 'package:flutter/material.dart';
import 'package:ffapp/assets/data/missions.dart';
import 'package:provider/provider.dart';


class FitVenturesLite extends StatefulWidget {
  const FitVenturesLite({Key? key}) : super(key: key);

  @override
  _FitVenturesLiteState createState() => _FitVenturesLiteState();
}

class FitventuresMissionManagerProvider with ChangeNotifier {
  late ListMission _currentMission = ListMission(
    missionName: "null",
    url: "not",
    moneyReward: 0,
    evoReward: 0,
    chargeReward: 0,
    seconds: 0,
    onStart: () {},
  );

  ListMission get currentMission => _currentMission;

  void startMission(ListMission mission) {
    _currentMission = mission;
    notifyListeners();
  }

  void completeMission() {
    _currentMission = ListMission(
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

class _FitVenturesLiteState extends State<FitVenturesLite> {
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