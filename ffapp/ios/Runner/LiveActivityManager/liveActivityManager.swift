//
//  liveActivityManager.swift
//  Runner
//
//  Created by Kevin Crothers on 9/14/24.
//

import ActivityKit
import Flutter
import Foundation

class LiveActivityManager {

    private var stopwatchActivity: Activity<LiveActivitiesAppAttributes>? = nil

    func startLiveActivity(data: [String: Any]?, result: FlutterResult) {
      let attributes = LiveActivitiesAppAttributes()
      

      if let info = data as? [String: Any] {
        let state = LiveActivitiesAppAttributes.ContentState(
          elapsedTime: info["elapsedSeconds"] as? Int ?? 0,
          timeGoal: info["timeGoal"] as? Int ?? 0
        )
        stopwatchActivity = try? Activity<LiveActivitiesAppAttributes>.request(
          attributes: attributes, contentState: state, pushType: nil)
      } else {
        result(FlutterError(code: "418", message: "Live activity didn't invoked", details: nil))
      }
    }

  func updateLiveActivity(data: [String: Any]?, result: FlutterResult) {
    if let info = data as? [String: Any] {
      let updatedState = LiveActivitiesAppAttributes.ContentState(
        elapsedTime: info["elapsedSeconds"] as? Int ?? 0,
        timeGoal: info["timeGoal"] as? Int ?? 0
      )

      Task {
        await stopwatchActivity?.update(using: updatedState)
      }
    } else {
      result(FlutterError(code: "418", message: "Live activity didn't updated", details: nil))
    }
  }

  func stopLiveActivity(result: FlutterResult) {
    do {
      Task {
        await stopwatchActivity?.end(using: nil, dismissalPolicy: .immediate)
      }
    } catch {
      result(FlutterError(code: "418", message: error.localizedDescription, details: nil))
    }
  }
}
