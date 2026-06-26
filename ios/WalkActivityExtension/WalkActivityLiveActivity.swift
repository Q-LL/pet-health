import ActivityKit
import AppIntents
import SwiftUI
import WidgetKit

@main
struct WalkActivityExtensionBundle: WidgetBundle {
  var body: some Widget {
    WalkActivityLiveActivity()
  }
}

struct WalkActivityLiveActivity: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: WalkActivityAttributes.self) { context in
      WalkActivityLockScreenView(context: context)
        .activityBackgroundTint(Color(.systemBackground))
        .activitySystemActionForegroundColor(.primary)
    } dynamicIsland: { context in
      DynamicIsland {
        DynamicIslandExpandedRegion(.leading) {
          Label(context.state.endedAt == nil ? "遛狗中" : "遛狗结束", systemImage: "figure.walk")
        }
        DynamicIslandExpandedRegion(.trailing) {
          if let endedAt = context.state.endedAt {
            Text(durationText(from: context.state.startedAt, to: endedAt))
              .monospacedDigit()
          } else {
            Text(context.state.startedAt, style: .timer)
              .monospacedDigit()
          }
        }
        DynamicIslandExpandedRegion(.bottom) {
          WalkActionButton(startedAt: context.state.startedAt, endedAt: context.state.endedAt)
        }
      } compactLeading: {
        Image(systemName: "figure.walk")
      } compactTrailing: {
        if let endedAt = context.state.endedAt {
          Text(durationText(from: context.state.startedAt, to: endedAt))
            .monospacedDigit()
        } else {
          Text(context.state.startedAt, style: .timer)
            .monospacedDigit()
        }
      } minimal: {
        Image(systemName: "figure.walk")
      }
    }
  }
}

private struct WalkActivityLockScreenView: View {
  let context: ActivityViewContext<WalkActivityAttributes>

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack(alignment: .top) {
        VStack(alignment: .leading, spacing: 4) {
          Text(title)
            .font(.headline)
          Text(subtitle)
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        Spacer()
        Image(systemName: "figure.walk.circle.fill")
          .font(.system(size: 34))
          .symbolRenderingMode(.hierarchical)
      }

      HStack {
        VStack(alignment: .leading, spacing: 2) {
          Text("已遛时间")
            .font(.caption)
            .foregroundStyle(.secondary)
          if let endedAt = context.state.endedAt {
            Text(durationText(from: context.state.startedAt, to: endedAt))
              .font(.system(.title2, design: .rounded).monospacedDigit())
              .fontWeight(.semibold)
          } else {
            Text(context.state.startedAt, style: .timer)
              .font(.system(.title2, design: .rounded).monospacedDigit())
              .fontWeight(.semibold)
          }
        }
        Spacer()
        WalkActionButton(startedAt: context.state.startedAt, endedAt: context.state.endedAt)
      }
    }
    .padding()
  }

  private var title: String {
    guard let endedAt = context.state.endedAt else {
      return "正在遛狗"
    }
    return "遛狗结束（\(durationText(from: context.state.startedAt, to: endedAt))）"
  }

  private var subtitle: String {
    if context.state.endedAt != nil {
      return "返回 app 后补充遛狗详情"
    }
    guard let petName = context.state.petName, !petName.isEmpty else {
      return "返回 app 后补充遛狗详情"
    }
    return "正在陪 \(petName) 散步"
  }
}

private struct WalkActionButton: View {
  let startedAt: Date
  let endedAt: Date?

  var body: some View {
    if let endedAt {
      Button(intent: RecordWalkIntent(startedAt: startedAt, endedAt: endedAt)) {
        Label("记录遛狗", systemImage: "square.and.pencil")
      }
      .buttonStyle(.borderedProminent)
      .tint(.green)
    } else {
      Button(intent: EndWalkIntent(startedAt: startedAt)) {
        Label("结束遛狗", systemImage: "flag.checkered")
      }
      .buttonStyle(.borderedProminent)
      .tint(.green)
    }
  }
}

private func durationText(from startedAt: Date, to endedAt: Date) -> String {
  let seconds = max(0, Int(endedAt.timeIntervalSince(startedAt).rounded()))
  let hours = seconds / 3600
  let minutes = (seconds % 3600) / 60
  if hours > 0 {
    return "\(hours) 小时 \(minutes) 分钟"
  }
  return "\(max(1, minutes)) 分钟"
}
