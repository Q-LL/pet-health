import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

const _channel = MethodChannel('pet_health/walk_live_activity');

final walkLiveActivityService = WalkLiveActivityService();

class WalkLiveActivityService {
  const WalkLiveActivityService();

  bool get _isSupportedPlatform =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  Future<bool> start({required DateTime startedAt, String? petName}) async {
    if (!_isSupportedPlatform) return false;
    try {
      final result = await _channel.invokeMethod<bool>('start', {
        'startedAt': startedAt.toUtc().millisecondsSinceEpoch,
        if (petName != null && petName.trim().isNotEmpty)
          'petName': petName.trim(),
      });
      return result ?? false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  Future<void> end() async {
    if (!_isSupportedPlatform) return;
    try {
      await _channel.invokeMethod<void>('end');
    } on PlatformException {
      // Live Activity is best-effort; the regular notification path still works.
    } on MissingPluginException {
      // Live Activity is only registered on iOS.
    }
  }

  Future<PendingWalkFinish?> getPendingFinish() async {
    if (!_isSupportedPlatform) return null;
    try {
      final raw = await _channel.invokeMapMethod<String, Object?>(
        'getPendingFinish',
      );
      if (raw == null) return null;
      final startedAtMillis = raw['startedAt'] as int?;
      final endedAtMillis = raw['endedAt'] as int?;
      if (startedAtMillis == null || endedAtMillis == null) return null;
      return PendingWalkFinish(
        startedAt: DateTime.fromMillisecondsSinceEpoch(
          startedAtMillis,
          isUtc: true,
        ),
        endedAt: DateTime.fromMillisecondsSinceEpoch(
          endedAtMillis,
          isUtc: true,
        ),
      );
    } on PlatformException {
      return null;
    } on MissingPluginException {
      return null;
    }
  }

  Future<void> clearPendingFinish() async {
    if (!_isSupportedPlatform) return;
    try {
      await _channel.invokeMethod<void>('clearPendingFinish');
    } on PlatformException {
      // Pending finish is a convenience prompt and can be safely skipped.
    } on MissingPluginException {
      // Live Activity is only registered on iOS.
    }
  }
}

@immutable
class PendingWalkFinish {
  const PendingWalkFinish({required this.startedAt, required this.endedAt});

  final DateTime startedAt;
  final DateTime endedAt;
}
