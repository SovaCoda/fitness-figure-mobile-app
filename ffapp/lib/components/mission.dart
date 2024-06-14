import 'dart:async';

import 'package:ffapp/components/robot_image_holder.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/pages/home/fitventureslite.dart' as FL;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class InternalListMission {
  final String missionName;
  final String url;
  final int moneyReward;
  final int evoReward;
  final double chargeReward;
  final int seconds;
  final VoidCallback onStart;

  InternalListMission({
    required this.missionName,
    required this.url,
    required this.moneyReward,
    required this.evoReward,
    required this.chargeReward,
    required this.seconds,
    required this.onStart,
  });
}

class MissionListWidget extends StatefulWidget {
  final String missionName;
  final String url;
  final int moneyReward;
  final int evoReward;
  final double chargeReward;
  int seconds;
  final VoidCallback onStart;

  MissionListWidget({
    required this.missionName,
    required this.url,
    required this.moneyReward,
    required this.evoReward,
    required this.chargeReward,
    required this.seconds,
    required this.onStart,
  });

  @override
  _MissionState createState() => _MissionState();
}

class _MissionState extends State<MissionListWidget> {
  Timer _timer = Timer(Duration.zero, () {});

  void startTimer() {
    if (widget.seconds == 0) return;
    if (Provider.of<FL.FitventuresMissionManagerProvider>(context, listen: false).currentMission.missionName != "null") return;


    Provider.of<FL.FitventuresMissionManagerProvider>(context, listen: false).startMission(MissionListWidget(
      missionName: widget.missionName,
      url: widget.url,
      moneyReward: widget.moneyReward,
      evoReward: widget.evoReward,
      chargeReward: widget.chargeReward,
      seconds: widget.seconds,
      onStart: widget.onStart,
    ));
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        widget.seconds--;
        if (widget.seconds == 0) {
          onMissionComplete();
        }
      });
    });
  }

  void onMissionCancel() {
    Provider.of<FL.FitventuresMissionManagerProvider>(context, listen: false).completeMission();
    _timer.cancel();
  }

  void onMissionComplete() {
    _timer.cancel();
    Provider.of<FL.FitventuresMissionManagerProvider>(context, listen: false).completeMission();
  }

  String formatSeconds(int seconds) {
    final formatter = NumberFormat('00');
    String hours = formatter.format((seconds / 3600).floor());
    String minutes = formatter.format(((seconds % 3600) / 60).floor());
    String second = formatter.format((seconds % 60));
    return "$hours:$minutes:$second";
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FL.FitventuresMissionManagerProvider>(
      builder: (context, missionManager, child) {
        return Opacity(
          opacity: (missionManager.currentMission?.missionName == widget.missionName || missionManager.currentMission?.missionName == "null") ? 1 : 0.5,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.onPrimary,
                  blurRadius: 10,
                  spreadRadius: 5,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Consumer<FigureModel>(
                  builder: (context, figure, child) {
                    return RobotImageHolder(
                      url: (figure.figure != null) ? ("${figure.figure!.figureName}/${figure.figure!.figureName}_skin${figure.figure!.curSkin}_evo${0}_cropped_happy") : "robot1/robot1_skin0_evo0_cropped_happy",
                      height: 150,
                      width: 150,
                    );
                  },
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(widget.missionName),
                    Text(
                      "+\$${widget.moneyReward.toString()}",
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    Text(
                      "+${widget.evoReward.toString()} EVO",
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                    Text(
                      "+${widget.chargeReward.toString()}% Charge",
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(formatSeconds(widget.seconds), style: TextStyle(fontSize: 30)),
                    missionManager.currentMission?.missionName == widget.missionName ?
                      ElevatedButton(
                        onPressed: onMissionCancel,
                        child: Text("Cancel", style: TextStyle(fontSize: 20)),
                      )
                      : 
                      ElevatedButton(
                        onPressed: startTimer,
                        child: Text("Start", style: TextStyle(fontSize: 20)),
                      ),
                    
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class MissionList extends StatelessWidget {
  final List<MissionListWidget> missions;

  MissionList({required this.missions});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: missions.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: missions[index],
        );
      },
    );
  }
}
