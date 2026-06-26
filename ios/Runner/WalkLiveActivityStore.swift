import Foundation

enum WalkLiveActivityStore {
  private static let suiteName = "group.com.qll.petHealth"
  private static let pendingStartedAtKey = "pendingWalkFinish.startedAt"
  private static let pendingEndedAtKey = "pendingWalkFinish.endedAt"
  private static let pendingActionKey = "pendingWalkFinish.action"
  private static let recordAction = "record"

  private static var defaults: UserDefaults? {
    UserDefaults(suiteName: suiteName)
  }

  static func markPendingFinish(startedAt: Date, endedAt: Date) {
    defaults?.set(startedAt.timeIntervalSince1970, forKey: pendingStartedAtKey)
    defaults?.set(endedAt.timeIntervalSince1970, forKey: pendingEndedAtKey)
    defaults?.set(recordAction, forKey: pendingActionKey)
  }

  static func pendingFinish() -> (startedAt: Date, endedAt: Date)? {
    guard
      let defaults,
      defaults.string(forKey: pendingActionKey) == recordAction,
      defaults.object(forKey: pendingStartedAtKey) != nil,
      defaults.object(forKey: pendingEndedAtKey) != nil
    else {
      clearPendingFinish()
      return nil
    }

    let startedAt = Date(timeIntervalSince1970: defaults.double(forKey: pendingStartedAtKey))
    let endedAt = Date(timeIntervalSince1970: defaults.double(forKey: pendingEndedAtKey))
    return (startedAt, endedAt)
  }

  static func clearPendingFinish() {
    defaults?.removeObject(forKey: pendingStartedAtKey)
    defaults?.removeObject(forKey: pendingEndedAtKey)
    defaults?.removeObject(forKey: pendingActionKey)
  }
}
