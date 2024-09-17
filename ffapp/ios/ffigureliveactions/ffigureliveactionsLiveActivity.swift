//
//  ffigureliveactionsLiveActivity.swift
//  ffigureliveactions
//
//  Created by Kevin Crothers on 9/11/24.
//

import ActivityKit
import WidgetKit
import SwiftUI
import Foundation


struct LiveActivitiesAppAttributes: ActivityAttributes {
  public typealias stopwatchStatus = ContentState
    
  public struct ContentState: Codable, Hashable {
      var elapsedTime: Int
  }
}

struct ffigureliveactionsLiveActivity: Widget {
    func getTimeString(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = (seconds % 3600) % 60
        
        return hours == 0 ?
                String(format: "%02d:%02d", minutes, seconds)
                : String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivitiesAppAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack(alignment: .leading) {
                 // Text element with Nova Square font
                VStack(alignment: .leading) {Text(getTimeString(context.state.elapsedTime))
                        .font(.custom("NovaSquare", size: 48))  // Custom font
                    Text("elapsed").font(.custom("NovaSquare", size: 16))
                    //Text(timerInterval: Date.now...Date(timeInterval: 60, since: .now)).font(.custom("NovaSquare", size: 16))
                }.padding()
                 
                 // Progress view with green color
                ProgressView(value: Double(context.state.elapsedTime)/60.0)
                     .progressViewStyle(LinearProgressViewStyle(tint: .green))
                     
             }
            .activityBackgroundTint(Color(white: 0.26, opacity: 0.9))
            .activitySystemActionForegroundColor(Color(white: 0.26, opacity: 0.9))

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text(getTimeString(context.state.elapsedTime))
                    // more content
                }
            } compactLeading: {
                Text(getTimeString(context.state.elapsedTime))
            } compactTrailing: {
                Text("T")
            } minimal: {
                Text("H")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}
