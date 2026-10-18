import 'package:flutter/foundation.dart';

import '../../../core/units/units.dart';
import 'entry_codes.dart';
import 'entry_details.dart';

/// 一条记录。时间都是本地时间。
@immutable
class Entry {
  const Entry({
    required this.id,
    required this.petId,
    required this.type,
    required this.occurredAt,
    required this.details,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
    this.planId,
    this.amount,
    this.unit,
    this.startedAt,
    this.endedAt,
    this.durationSec,
    this.distanceM,
    this.label,
  });

  final String id;
  final String petId;
  final EntryType type;
  final DateTime occurredAt;
  final String? planId;

  /// 体重为 kg、饮水为 ml；饮食和用药按 [unit] 原样存。
  final double? amount;
  final PortionUnit? unit;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final int? durationSec;
  final double? distanceM;
  final EntryDetails details;
  final String? label;
  final String note;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isActiveWalk => type == EntryType.walk && endedAt == null;
}

/// 新建或修改记录时填写的内容。
///
/// 正在进行的遛狗用 `startWalk` / `finishWalk`，不走这里；
/// 补记一次已经结束的遛狗时，填 [startedAt] 和 [endedAt]。
@immutable
class EntryDraft {
  const EntryDraft({
    required this.petId,
    required this.type,
    required this.occurredAt,
    this.planId,
    this.amount,
    this.unit,
    this.details,
    this.label,
    this.note = '',
    this.startedAt,
    this.endedAt,
    this.distanceM,
  });

  final String petId;
  final EntryType type;
  final DateTime occurredAt;
  final String? planId;
  final double? amount;
  final PortionUnit? unit;

  /// 为空时按类型使用空的细节。
  final EntryDetails? details;
  final String? label;
  final String note;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final double? distanceM;
}

/// 这只狗已经有一条正在进行的遛狗。
class ActiveWalkExists implements Exception {
  const ActiveWalkExists(this.petId);

  final String petId;

  @override
  String toString() => 'ActiveWalkExists($petId)';
}
