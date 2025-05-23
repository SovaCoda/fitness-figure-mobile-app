import 'dart:developer';

import 'package:flutter/services.dart';

class DynamicIslandManager {
  final String channelKey;
  late final MethodChannel _methodChannel;

  DynamicIslandManager({required this.channelKey}) {
    _methodChannel = MethodChannel(channelKey);
  }

  Future<void> startLiveActivity({required Map<String, dynamic> jsonData}) async {
    try {
      await _methodChannel.invokeListMethod('startLiveActivity', jsonData);
    } catch (e, st) {
      log(e.toString(), stackTrace: st);
    }
  }

  Future<void> updateLiveActivity({required Map<String, dynamic> jsonData}) async {
    try {
      await _methodChannel.invokeListMethod('updateLiveActivity', jsonData);
    } catch (e, st) {
      log(e.toString(), stackTrace: st);
    }
  }

  Future<void> stopLiveActivity() async {
    try {
      await _methodChannel.invokeListMethod('stopLiveActivity');
    } catch (e, st) {
      log(e.toString(), stackTrace: st);
    }
  }
}

class DynamicIslandStopwatchDataModel {
  final int elapsedSeconds;
  final int timeGoal;
  final bool paused;

  DynamicIslandStopwatchDataModel({
    required this.elapsedSeconds,
    required this.timeGoal,
    required this.paused,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'elapsedSeconds': elapsedSeconds,
      'timeGoal' : timeGoal,
      'paused' : paused,
    };
  }
}
