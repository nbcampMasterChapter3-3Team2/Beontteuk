//
//  BeontteukWidgetLiveActivity.swift
//  BeontteukWidget
//
//  Created by 곽다은 on 5/28/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct BeontteukWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var duration: Double
    }

    // Fixed non-changing properties about your activity go here!
//    var name: String
}

struct BeontteukWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: BeontteukWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text(context.state.duration.convertToTimeString())
                    .foregroundStyle(.neutral100)
                    .font(.largeTitle)
                    .fontWeight(.light)
            }
            .activityBackgroundTint(.primary500)

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
                    Text("\(context.state.duration)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.duration)")
            } minimal: {
                Text("⏲️")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}
