import 'package:flutter/foundation.dart';

/// 护理记录筛选参数，用于 family provider 的 key。
///
/// 所有时间字段统一使用 UTC；页面在构造时自行调用 `toUtc()`。
@immutable
class CareActivityFilter {
  const CareActivityFilter({
    required this.petId,
    this.type,
    this.from,
    this.to,
    this.keyword,
    this.limit,
    this.offset = 0,
  });

  /// 目标狗狗 ID。
  final String petId;

  /// 护理类型筛选，`null` 表示不限。
  final String? type;

  /// 发生时间下界（包含），`null` 表示不限。
  final DateTime? from;

  /// 发生时间上界（不包含），`null` 表示不限。
  final DateTime? to;

  /// 关键词，同时匹配地点和备注。
  final String? keyword;

  /// 每页条数，`null` 表示不限制。
  final int? limit;

  /// 偏移量，默认 0。
  final int offset;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CareActivityFilter &&
          runtimeType == other.runtimeType &&
          petId == other.petId &&
          type == other.type &&
          from == other.from &&
          to == other.to &&
          keyword == other.keyword &&
          limit == other.limit &&
          offset == other.offset;

  @override
  int get hashCode =>
      Object.hash(petId, type, from, to, keyword, limit, offset);

  /// 返回不带分页参数的副本，适合 `count()` 查询。
  CareActivityFilter withoutPaging() => CareActivityFilter(
    petId: petId,
    type: type,
    from: from,
    to: to,
    keyword: keyword,
  );
}
