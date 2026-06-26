import ActivityKit
import Foundation

struct WalkActivityAttributes: ActivityAttributes {
  public struct ContentState: Codable, Hashable {
    var startedAt: Date
    var endedAt: Date?
    var petName: String?
  }

  var walkId: String
}
