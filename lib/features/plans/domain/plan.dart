import 'package:flutter/foundation.dart';

import '../../entries/domain/entry_codes.dart';
import 'plan_codes.dart';
import 'plan_schedule.dart';

/// 一个计划。时间都是本地时间。
@immutable
class Plan {
  const Plan({
    required this.id,
    required this.petId,
    required this.entryType,
    required this.schedule,
    required this.source,
    required this.paused,
    required this.createdAt,
    required this.updatedAt,
    this.entryKind,
    this.title,
    this.notifyMinute,
    this.snoozedUntil,
    this.notificationId,
  });

  final String id;
  final String petId;

  /// 完成这个计划需要记哪种记录。
  final EntryType entryType;

  /// 细分到具体项，比如 other_care 下的 `nails`。
  final String? entryKind;

  /// 只有自定义事项才有；内置类型的名称来自翻译文件。
  final String? title;
  final PlanSchedule schedule;

  /// 当天几点提醒（距零点的分钟数）；为空表示不发通知。
  final int? notifyMinute;
  final DateTime? snoozedUntil;
  final int? notificationId;
  final PlanSource source;
  final bool paused;
  final DateTime createdAt;
  final DateTime updatedAt;
}

@immutable
class PlanDraft {
  const PlanDraft({
    required this.petId,
    required this.entryType,
    required this.schedule,
    this.entryKind,
    this.title,
    this.notifyMinute,
    this.paused = false,
  });

  final String petId;
  final EntryType entryType;
  final String? entryKind;
  final String? title;
  final PlanSchedule schedule;
  final int? notifyMinute;
  final bool paused;
}

/// 计划和它此刻的状态。
@immutable
class PlanStatus {
  const PlanStatus({required this.plan, required this.due, this.lastDoneAt});

  final Plan plan;
  final PlanDue due;

  /// 最近一次完成的时间；没有记录时为空。
  final DateTime? lastDoneAt;
}
