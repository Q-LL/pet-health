import ActivityKit
import AppIntents
import Foundation

struct EndWalkIntent: LiveActivityIntent {
  static var title: LocalizedStringResource = "结束遛狗"
  static var description = IntentDescription("结束当前遛狗计时，并保留实时活动等待记录。")
  static var openAppWhenRun = false

  @available(iOS 26.0, *)
  static var supportedModes: IntentModes {
    .background
  }

  @Parameter(title: "开始时间")
  var startedAt: Date

  init() {
    startedAt = Date()
  }

  init(startedAt: Date) {
    self.startedAt = startedAt
  }

  func perform() async throws -> some IntentResult {
    let endedAt = Date()

    for activity in Activity<WalkActivityAttributes>.activities {
      var updatedState = activity.content.state
      updatedState.endedAt = endedAt
      let content = ActivityContent(state: updatedState, staleDate: nil)
      await activity.update(content)
    }

    return .result()
  }
}

struct RecordWalkIntent: LiveActivityIntent {
  static var title: LocalizedStringResource = "记录遛狗"
  static var description = IntentDescription("打开 app 补充遛狗地点和备注。")
  static var openAppWhenRun = true

  @available(iOS 26.0, *)
  static var supportedModes: IntentModes {
    .foreground(.immediate)
  }

  @Parameter(title: "开始时间")
  var startedAt: Date

  @Parameter(title: "结束时间")
  var endedAt: Date

  init() {
    let now = Date()
    startedAt = now
    endedAt = now
  }

  init(startedAt: Date, endedAt: Date) {
    self.startedAt = startedAt
    self.endedAt = endedAt
  }

  func perform() async throws -> some IntentResult {
    WalkLiveActivityStore.markPendingFinish(startedAt: startedAt, endedAt: endedAt)
    return .result()
  }
}
