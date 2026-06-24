import 'package:flutter/foundation.dart';

/// 提醒筛选参数，用于 family provider 的 key。
@immutable
class ReminderFilter {
  const ReminderFilter({
    required this.petId,
    this.sourceType,
    this.enabled,
    this.from,
    this.to,
    this.limit,
    this.offset = 0,
  });

  /// 目标狗狗 ID。
  final String petId;

  /// 来源类型筛选，`null` 表示不限。
  final String? sourceType;

  /// 启用状态筛选，`null` 表示不限。
  final bool? enabled;

  /// 计划时间下界（包含），`null` 表示不限。
  final DateTime? from;

  /// 计划时间上界（不包含），`null` 表示不限。
  final DateTime? to;

  /// 每页条数，`null` 表示不限制。
  final int? limit;

  /// 偏移量，默认 0。
  final int offset;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderFilter &&
          runtimeType == other.runtimeType &&
          petId == other.petId &&
          sourceType == other.sourceType &&
          enabled == other.enabled &&
          from == other.from &&
          to == other.to &&
          limit == other.limit &&
          offset == other.offset;

  @override
  int get hashCode =>
      Object.hash(petId, sourceType, enabled, from, to, limit, offset);

  /// 返回不带分页参数的副本，适合 `count()` 查询。
  ReminderFilter withoutPaging() => ReminderFilter(
    petId: petId,
    sourceType: sourceType,
    enabled: enabled,
    from: from,
    to: to,
  );
}
