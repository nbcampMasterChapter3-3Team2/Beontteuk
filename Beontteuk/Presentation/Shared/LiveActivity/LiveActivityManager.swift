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

    func update(for id: UUID?, remainTime duration: Double) {
        let staleDate = Date().addingTimeInterval(duration)
        Task {
            guard let id, let activity = activityMap[id] else { return }
            let updateContentState = BeontteukWidgetAttributes.ContentState(duration: duration)
            if #available(iOS 16.2, *) {
                let activityContent = ActivityContent(state: updateContentState, staleDate: staleDate)
                await activity.update(activityContent)
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
