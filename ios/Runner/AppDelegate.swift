import AVFoundation
import Flutter
import Photos
import PhotosUI
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate, PHPickerViewControllerDelegate {
  private var pendingAlbumPickerResult: FlutterResult?
  private var pendingAlbumPickerKind = "image"
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    registerWalkLiveActivityChannel(engineBridge)
    registerAlbumAssetChannel(engineBridge)
  }

  private func registerAlbumAssetChannel(_ engineBridge: FlutterImplicitEngineBridge) {
    let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "AlbumAssetPlugin")
    guard let registrar else { return }
    let channel = FlutterMethodChannel(
      name: "pet_health/album_assets",
      binaryMessenger: registrar.messenger()
    )
    channel.setMethodCallHandler { [weak self] call, result in
      guard let self else { return }
      switch call.method {
      case "pickImages":
        self.presentAlbumPicker(kind: "image", result: result)
      case "pickVideo":
        self.presentAlbumPicker(kind: "video", result: result)
      case "requestThumbnail", "requestPreview":
        guard
          let arguments = call.arguments as? [String: Any],
          let reference = arguments["ref"] as? String
        else {
          result(FlutterError(code: "bad_arguments", message: "缺少媒体引用", details: nil))
          return
        }
        let size = (arguments["size"] as? NSNumber)?.intValue ?? 512
        self.requestImage(reference: reference, size: size, result: result)
      case "openAsset":
        guard
          let arguments = call.arguments as? [String: Any],
          let reference = arguments["ref"] as? String
        else {
          result(nil)
          return
        }
        self.openVideo(reference: reference, result: result)
      case "checkAvailability":
        guard
          let arguments = call.arguments as? [String: Any],
          let reference = arguments["ref"] as? String
        else {
          result(false)
          return
        }
        result(PHAsset.fetchAssets(withLocalIdentifiers: [reference], options: nil).count > 0)
      case "releaseReference":
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private func presentAlbumPicker(kind: String, result: @escaping FlutterResult) {
    guard pendingAlbumPickerResult == nil else {
      result(FlutterError(code: "picker_busy", message: "相册选择器正在使用", details: nil))
      return
    }
    PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
      guard let self else { return }
      guard status == .authorized || status == .limited else {
        DispatchQueue.main.async {
          result(FlutterError(code: "permission_denied", message: "没有相册访问权限", details: nil))
        }
        return
      }
      DispatchQueue.main.async {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = kind == "video" ? .videos : .images
        configuration.selectionLimit = kind == "video" ? 1 : 0
        configuration.selection = .ordered
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.pendingAlbumPickerResult = result
        self.pendingAlbumPickerKind = kind
        guard let presenter = self.topViewController() else {
          self.pendingAlbumPickerResult = nil
          result(FlutterError(code: "picker_unavailable", message: "无法打开系统相册", details: nil))
          return
        }
        presenter.present(picker, animated: true)
      }
    }
  }

  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    picker.dismiss(animated: true)
    guard let callback = pendingAlbumPickerResult else { return }
    pendingAlbumPickerResult = nil
    let identifiers = results.compactMap(\.assetIdentifier)
    guard !identifiers.isEmpty else {
      callback(pendingAlbumPickerKind == "video" ? nil : [])
      return
    }
    let assets = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
    var byIdentifier: [String: PHAsset] = [:]
    assets.enumerateObjects { asset, _, _ in byIdentifier[asset.localIdentifier] = asset }
    let values: [[String: Any]] = identifiers.compactMap { identifier in
      guard let asset = byIdentifier[identifier] else { return nil }
      var value: [String: Any] = [
        "ref": identifier,
        "kind": asset.mediaType == .video ? "video" : "image",
        "width": asset.pixelWidth,
        "height": asset.pixelHeight,
      ]
      if asset.mediaType == .video {
        value["durationMs"] = Int64(asset.duration * 1000)
      }
      if let date = asset.creationDate {
        value["capturedAt"] = Int64(date.timeIntervalSince1970 * 1000)
      }
      return value
    }
    callback(pendingAlbumPickerKind == "video" ? values.first : values)
  }

  private func requestImage(reference: String, size: Int, result: @escaping FlutterResult) {
    guard let asset = PHAsset.fetchAssets(
      withLocalIdentifiers: [reference],
      options: nil
    ).firstObject else {
      result(nil)
      return
    }
    let options = PHImageRequestOptions()
    options.deliveryMode = .highQualityFormat
    options.resizeMode = .fast
    options.isNetworkAccessAllowed = true
    PHImageManager.default().requestImage(
      for: asset,
      targetSize: CGSize(width: size, height: size),
      contentMode: .aspectFill,
      options: options
    ) { image, info in
      if (info?[PHImageCancelledKey] as? Bool) == true {
        DispatchQueue.main.async {
          result(nil)
        }
        return
      }
      if (info?[PHImageResultIsDegradedKey] as? Bool) == true {
        return
      }
      DispatchQueue.main.async {
        result(image?.jpegData(compressionQuality: 0.84))
      }
    }
  }

  private func openVideo(reference: String, result: @escaping FlutterResult) {
    guard let asset = PHAsset.fetchAssets(
      withLocalIdentifiers: [reference],
      options: nil
    ).firstObject else {
      result(nil)
      return
    }
    let options = PHVideoRequestOptions()
    options.deliveryMode = .highQualityFormat
    options.isNetworkAccessAllowed = true
    PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { asset, _, _ in
      let urlAsset = asset as? AVURLAsset
      DispatchQueue.main.async {
        result(urlAsset?.url.path)
      }
    }
  }

  private func topViewController() -> UIViewController? {
    var controller = window?.rootViewController
    while let presented = controller?.presentedViewController {
      controller = presented
    }
    return controller
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
