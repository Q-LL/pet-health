import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../features/reminders/domain/reminder_models.dart';
import 'walk_live_activity_service.dart';

export 'package:flutter_local_notifications/flutter_local_notifications.dart'
    show NotificationResponse;

const walkNotificationId = 9001;
const walkFinishActionId = 'walk_finish';
const walkFinishPayload = 'walk:finish';

const carePlanNotificationBaseId = 20000;

final notificationService = NotificationService();

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  notificationService.handleResponse(response);
}

class NotificationService {
  NotificationService();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  final _responses = StreamController<NotificationResponse>.broadcast();
  var _initialized = false;
  int? _lastWalkTimerStartedAtMillis;
  Future<void>? _walkTimerStartInFlight;

  Stream<NotificationResponse> get responses => _responses.stream;

  Future<void> initialize() async {
    if (_initialized || kIsWeb) return;
    tz.initializeTimeZones();
    await _configureLocalTimezone();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final darwin = DarwinInitializationSettings(
      notificationCategories: [
        DarwinNotificationCategory(
          'walk_timer',
          actions: [
            DarwinNotificationAction.plain(
              walkFinishActionId,
              '结束遛狗',
              options: {DarwinNotificationActionOption.foreground},
            ),
          ],
        ),
      ],
    );
    final settings = InitializationSettings(android: android, iOS: darwin);

    try {
      await _plugin.initialize(
        settings: settings,
        onDidReceiveNotificationResponse: handleResponse,
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      );
      await requestPermissions();
      _initialized = true;
    } catch (_) {
      _initialized = false;
    }
  }

  Future<void> requestPermissions() async {
    if (kIsWeb) return;
    try {
      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestExactAlarmsPermission();
      await _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } catch (_) {}
  }

  void handleResponse(NotificationResponse response) {
    if (_responses.isClosed) return;
    _responses.add(response);
  }

  Future<NotificationAppLaunchDetails?> getLaunchDetails() async {
    if (kIsWeb) return Future.value();
    try {
      return await _plugin.getNotificationAppLaunchDetails();
    } catch (_) {
      return Future.value();
    }
  }

  Future<void> scheduleReminder(Reminder reminder) async {
    if (kIsWeb || !_initialized || !reminder.enabled || reminder.paused) {
      return;
    }
    final id =
        reminder.notificationId ?? notificationIdForReminder(reminder.id);
    final scheduledAt = reminder.scheduledAt.toLocal();
    if (!scheduledAt.isAfter(DateTime.now())) return;
    try {
      await _plugin.zonedSchedule(
        id: id,
        title: reminder.title,
        body: _reminderBody(reminder),
        scheduledDate: tz.TZDateTime.from(scheduledAt, tz.local),
        notificationDetails: _reminderDetails(reminder),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: 'reminder:${reminder.id}',
      );
    } catch (_) {}
  }

  Future<void> cancelReminder(Reminder reminder) async {
    if (kIsWeb || !_initialized) return;
    try {
      await _plugin.cancel(
        id: reminder.notificationId ?? notificationIdForReminder(reminder.id),
      );
    } catch (_) {}
  }

  Future<void> showWalkTimer({
    required DateTime startedAt,
    String? petName,
  }) async {
    if (kIsWeb || !_initialized) return;
    final startedAtMillis = startedAt.toUtc().millisecondsSinceEpoch;
    if (_lastWalkTimerStartedAtMillis == startedAtMillis) return;
    final inFlight = _walkTimerStartInFlight;
    if (inFlight != null) {
      await inFlight;
      if (_lastWalkTimerStartedAtMillis == startedAtMillis) return;
    }
    _lastWalkTimerStartedAtMillis = startedAtMillis;

    final startOperation = _showWalkTimer(
      startedAt: startedAt,
      petName: petName,
    );
    _walkTimerStartInFlight = startOperation;
    try {
      await startOperation;
    } finally {
      if (identical(_walkTimerStartInFlight, startOperation)) {
        _walkTimerStartInFlight = null;
      }
    }
  }

  Future<void> _showWalkTimer({
    required DateTime startedAt,
    String? petName,
  }) async {
    await walkLiveActivityService.clearPendingFinish();
    if (defaultTargetPlatform == TargetPlatform.iOS &&
        await walkLiveActivityService.start(
          startedAt: startedAt,
          petName: petName,
        )) {
      return;
    }
    try {
      await _plugin.show(
        id: walkNotificationId,
        title: '正在遛狗',
        body: petName == null || petName.isEmpty
            ? '点击返回补充遛狗记录'
            : '正在陪 $petName 遛狗',
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            'walk_timer',
            '遛狗计时',
            channelDescription: '显示进行中的遛狗计时和结束入口',
            importance: Importance.low,
            priority: Priority.low,
            ongoing: true,
            autoCancel: false,
            onlyAlertOnce: true,
            usesChronometer: true,
            when: startedAt.toLocal().millisecondsSinceEpoch,
            category: AndroidNotificationCategory.workout,
            actions: const [
              AndroidNotificationAction(
                walkFinishActionId,
                '结束遛狗',
                showsUserInterface: true,
                cancelNotification: false,
              ),
            ],
          ),
          iOS: const DarwinNotificationDetails(
            categoryIdentifier: 'walk_timer',
            presentBanner: true,
            presentList: true,
            presentSound: false,
          ),
        ),
        payload: walkFinishPayload,
      );
    } catch (_) {}
  }

  Future<void> cancelWalkTimer() async {
    if (kIsWeb || !_initialized) return;
    _lastWalkTimerStartedAtMillis = null;
    _walkTimerStartInFlight = null;
    await walkLiveActivityService.end();
    try {
      await _plugin.cancel(id: walkNotificationId);
    } catch (_) {}
  }

  /// 调度护理计划到期通知。
  Future<void> scheduleCarePlanDue({
    required String planId,
    required String title,
    required DateTime dueAt,
    String? petName,
  }) async {
    if (kIsWeb || !_initialized) return;
    final scheduledAt = dueAt.toLocal();
    if (!scheduledAt.isAfter(DateTime.now())) return;
    final id = notificationIdForCarePlan(planId);
    try {
      await _plugin.zonedSchedule(
        id: id,
        title: '该护理了：$title',
        body: petName == null || petName.isEmpty
            ? '已经到了推荐护理时间，点击查看详情'
            : '$petName 的$title已经到了推荐护理时间',
        scheduledDate: tz.TZDateTime.from(scheduledAt, tz.local),
        notificationDetails: _carePlanDueDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: 'care_plan:$planId',
      );
    } catch (_) {}
  }

  /// 取消护理计划到期通知。
  Future<void> cancelCarePlanDue(String planId) async {
    if (kIsWeb || !_initialized) return;
    try {
      await _plugin.cancel(id: notificationIdForCarePlan(planId));
    } catch (_) {}
  }

  /// 立即显示护理计划到期通知（App 前台时使用）。
  Future<void> showCarePlanDueNow({
    required String planId,
    required String title,
    String? petName,
  }) async {
    if (kIsWeb || !_initialized) return;
    final id = notificationIdForCarePlan(planId);
    try {
      await _plugin.show(
        id: id,
        title: '该护理了：$title',
        body: petName == null || petName.isEmpty
            ? '已经到了推荐护理时间'
            : '$petName 的$title已经到了推荐护理时间',
        notificationDetails: _carePlanDueDetails(),
        payload: 'care_plan:$planId',
      );
    } catch (_) {}
  }

  Future<void> _configureLocalTimezone() async {
    try {
      final timezone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timezone.identifier));
    } catch (_) {
      tz.setLocalLocation(tz.UTC);
    }
  }
}

int notificationIdForReminder(String id) {
  return 10000 + (id.hashCode & 0x3fffffff);
}

int notificationIdForCarePlan(String planId) {
  return carePlanNotificationBaseId + (planId.hashCode & 0x3fffffff);
}

NotificationDetails _carePlanDueDetails() {
  return const NotificationDetails(
    android: AndroidNotificationDetails(
      'care_plan_due',
      '护理提醒',
      channelDescription: '护理计划到期时提醒',
      importance: Importance.high,
      priority: Priority.high,
      category: AndroidNotificationCategory.reminder,
    ),
    iOS: DarwinNotificationDetails(
      presentBanner: true,
      presentList: true,
      presentSound: true,
    ),
  );
}

NotificationDetails _reminderDetails(Reminder reminder) {
  return const NotificationDetails(
    android: AndroidNotificationDetails(
      'care_reminders',
      '提醒',
      channelDescription: '狗狗健康与护理提醒',
      importance: Importance.high,
      priority: Priority.high,
      category: AndroidNotificationCategory.reminder,
    ),
    iOS: DarwinNotificationDetails(
      presentBanner: true,
      presentList: true,
      presentSound: true,
    ),
  );
}

String _reminderBody(Reminder reminder) {
  return switch (reminder.completionMode) {
    'auto_record' => '完成后会自动写入记录',
    'ask_record' => '完成后会打开记录表单',
    _ => '点击返回毛健康处理提醒',
  };
}
