//
//  LiveActivityManager.swift
//  Beontteuk
//
//  Created by 곽다은 on 5/28/25.
//

import SwiftUI
import ActivityKit

final class LiveActivityManager: ObservableObject {
    static let shared = LiveActivityManager()

    private var activityMap: [UUID: Activity<BeontteukWidgetAttributes>] = [:]

    private init() {}

    func start(for id: UUID?, endAfter duration: Double) {
        guard let id else { return }
        let attributes = BeontteukWidgetAttributes()
        let contentState = BeontteukWidgetAttributes.ContentState(duration: duration)
        let staleDate = Date().addingTimeInterval(duration)

        do {
            if #available(iOS 16.2, *) {
                let activityContent = ActivityContent(state: contentState, staleDate: staleDate)
                let activity = try Activity<BeontteukWidgetAttributes>.request(attributes: attributes, content: activityContent)
                activityMap[id] = activity
            }
        } catch {
            print(error)
        }
    }

    func update(state: BeontteukWidgetAttributes.ContentState) {
        Task {
            let updateContentState = BeontteukWidgetAttributes.ContentState(emoji: state.emoji)
            if #available(iOS 16.2, *) {
                // staleDate: The date when the system considers the Live Activity to be out of date.
                let activityContent = ActivityContent(state: updateContentState, staleDate: nil)
                for activity in Activity<BeontteukWidgetAttributes>.activities {
                    await activity.update(activityContent)
                }
            }
        }
    }

    func stop(for id: UUID?) {
        guard let id else { return }
        Task {
            if let activity = activityMap[id], #available(iOS 16.2, *) {
                await activity.end(nil, dismissalPolicy: .immediate)
            }

        }
    }
}
