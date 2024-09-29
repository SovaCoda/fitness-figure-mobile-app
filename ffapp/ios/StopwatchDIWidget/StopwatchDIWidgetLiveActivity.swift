//
//  StopwatchDIWidgetLiveActivity.swift
//  StopwatchDIWidget
//
//  Created by Kevin Crothers on 9/23/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct StopwatchDIWidgetAttributes: ActivityAttributes {
    public typealias stopwatchStatus = ContentState
    
    public struct ContentState: Codable, Hashable {
        var elapsedTime: Int
        var timeGoal: Int
        var paused: Bool
    }
}

struct StopwatchDIWidgetLiveActivity: Widget {
    func getTimeString(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = (seconds % 3600) % 60
        
        return hours == 0 ?
                String(format: "%02d:%02d", minutes, seconds)
                : String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: StopwatchDIWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack(alignment: .leading) {
                let now = Date.now
                var whenToPause = context.state.paused ? now : nil
                var start = Calendar.current.date(byAdding: .second, value: Int(-context.state.elapsedTime), to: now)!
                var end = Calendar.current.date(byAdding: .second, value: Int(context.state.timeGoal), to: start)!                 // Text element with Nova Square font
                VStack(alignment: .leading) {Text(timerInterval: start...end, pauseTime: whenToPause, countsDown: false).font(.custom("NovaSquare", size: 48)).foregroundColor(.white)
                          // Custom font
                    if (context.state.paused) {Text("paused").font(.custom("NovaSquare", size: 16)).foregroundColor(.white) }
                    else {
                        Text("elapsed").font(.custom("NovaSquare", size: 16)).foregroundColor(.white)}
                    //Text(timerInterval: Date.now...Date(timeInterval: 60, since: .now)).font(.custom("NovaSquare", size: 16))
                }.padding()
                 
                 // Progress view with green color
                if (context.state.paused) { ProgressView(value: 1)
                    .progressViewStyle(LinearProgressViewStyle(tint: .red))}
                else {
                    ProgressView(timerInterval: start...end, countsDown: false).labelsHidden()
                    .progressViewStyle(LinearProgressViewStyle(tint: .green))}
                     
             }
            .activityBackgroundTint(Color(white: 0.26, opacity: 0.9))
            .activitySystemActionForegroundColor(Color(white: 0.26, opacity: 0.9))

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom

                DynamicIslandExpandedRegion(.bottom) {
                    let now = Date.now
                    var whenToPause = context.state.paused ? now : nil
                    var start = Calendar.current.date(byAdding: .second, value: Int(-context.state.elapsedTime), to: now)!
                    var end = Calendar.current.date(byAdding: .second, value: Int(context.state.timeGoal), to: start)!                 // Text element with Nova Square font
                    VStack(alignment: .leading) {Text(timerInterval: start...end, pauseTime: whenToPause, countsDown: false).font(.custom("NovaSquare", size: 24)).foregroundColor(.white)}
                }
            } compactLeading: {
                let now = Date.now
                var whenToPause = context.state.paused ? now : nil
                var start = Calendar.current.date(byAdding: .second, value: Int(-context.state.elapsedTime), to: now)!
                var end = Calendar.current.date(byAdding: .second, value: Int(context.state.timeGoal), to: start)!                 // Text element with Nova Square font
                VStack(alignment: .leading) {Text(timerInterval: start...end, pauseTime: whenToPause, countsDown: false).font(.custom("NovaSquare", size: 24)).foregroundColor(.white)}
            } compactTrailing: {
                Text("")
            } minimal: {
                Text("")
            }
            .widgetURL(URL(string: "http://www.fitnessfigure.com"))
            .keylineTint(Color.green)
        }
    }
}
