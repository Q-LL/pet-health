import ActivityKit
import Foundation

enum WalkLiveActivityError: Error {
  case unavailable
}

@available(iOS 16.2, *)
enum WalkLiveActivityManager {
  static func start(startedAt: Date, petName: String?) async throws {
    guard ActivityAuthorizationInfo().areActivitiesEnabled else {
      throw WalkLiveActivityError.unavailable
    }

    for activity in Activity<WalkActivityAttributes>.activities {
      let state = activity.content.state
      if state.endedAt == nil && abs(state.startedAt.timeIntervalSince(startedAt)) < 1 {
        return
      }
    }

    await endAll(dismissImmediately: true)

    let attributes = WalkActivityAttributes(walkId: UUID().uuidString)
    let contentState = WalkActivityAttributes.ContentState(
      startedAt: startedAt,
      endedAt: nil,
      petName: petName
    )
    let content = ActivityContent(state: contentState, staleDate: nil)
    _ = try Activity<WalkActivityAttributes>.request(
      attributes: attributes,
      content: content,
      pushType: nil
    )
  }

  static func endAll(dismissImmediately: Bool) async {
    let policy: ActivityUIDismissalPolicy = dismissImmediately ? .immediate : .default
    for activity in Activity<WalkActivityAttributes>.activities {
      let content = ActivityContent(state: activity.content.state, staleDate: nil)
      await activity.end(content, dismissalPolicy: policy)
    }
  }
}
