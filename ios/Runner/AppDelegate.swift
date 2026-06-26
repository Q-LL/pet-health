import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    registerWalkLiveActivityChannel(engineBridge)
  }

  private func registerWalkLiveActivityChannel(_ engineBridge: FlutterImplicitEngineBridge) {
    let registrar = engineBridge.pluginRegistry.registrar(
      forPlugin: "WalkLiveActivityPlugin"
    )
    guard let registrar else {
      return
    }
    let channel = FlutterMethodChannel(
      name: "pet_health/walk_live_activity",
      binaryMessenger: registrar.messenger()
    )

    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "start":
        guard
          let arguments = call.arguments as? [String: Any],
          let startedAtValue = arguments["startedAt"] as? NSNumber
        else {
          result(FlutterError(code: "bad_arguments", message: "Missing startedAt", details: nil))
          return
        }

        guard #available(iOS 16.2, *) else {
          result(false)
          return
        }

        let startedAt = Date(timeIntervalSince1970: startedAtValue.doubleValue / 1000)
        let petName = arguments["petName"] as? String
        Task {
          do {
            try await WalkLiveActivityManager.start(startedAt: startedAt, petName: petName)
            result(true)
          } catch {
            result(false)
          }
        }

      case "end":
        guard #available(iOS 16.2, *) else {
          result(nil)
          return
        }

        Task {
          await WalkLiveActivityManager.endAll(dismissImmediately: true)
          result(nil)
        }

      case "getPendingFinish":
        guard let pending = WalkLiveActivityStore.pendingFinish() else {
          result(nil)
          return
        }

        result([
          "startedAt": Int64(pending.startedAt.timeIntervalSince1970 * 1000),
          "endedAt": Int64(pending.endedAt.timeIntervalSince1970 * 1000),
        ])

      case "clearPendingFinish":
        WalkLiveActivityStore.clearPendingFinish()
        result(nil)

      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }
}
