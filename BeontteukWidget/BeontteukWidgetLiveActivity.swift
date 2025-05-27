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
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct BeontteukWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: BeontteukWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

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
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension BeontteukWidgetAttributes {
    fileprivate static var preview: BeontteukWidgetAttributes {
        BeontteukWidgetAttributes(name: "World")
    }
}

extension BeontteukWidgetAttributes.ContentState {
    fileprivate static var smiley: BeontteukWidgetAttributes.ContentState {
        BeontteukWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: BeontteukWidgetAttributes.ContentState {
         BeontteukWidgetAttributes.ContentState(emoji: "🤩")
     }
}
