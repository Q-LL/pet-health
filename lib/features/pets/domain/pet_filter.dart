import 'package:flutter/foundation.dart';

/// 狗狗档案筛选参数，用于 family provider 的 key。
@immutable
class PetFilter {
  const PetFilter({
    this.keyword,
    this.species,
    this.includePlaceholder = false,
    this.limit,
    this.offset = 0,
  });

  /// 关键词，匹配名字、品种、过敏信息和慢性病信息。
  final String? keyword;

  /// 狗狗类型、犬种或体型精确筛选。
  final String? species;

  /// 是否包含占位档案，默认不包含。
  final bool includePlaceholder;

  /// 每页条数，`null` 表示不限制。
  final int? limit;

  /// 偏移量，默认 0。
  final int offset;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PetFilter &&
          runtimeType == other.runtimeType &&
          keyword == other.keyword &&
          species == other.species &&
          includePlaceholder == other.includePlaceholder &&
          limit == other.limit &&
          offset == other.offset;

  @override
  int get hashCode =>
      Object.hash(keyword, species, includePlaceholder, limit, offset);

  /// 返回不带分页参数的副本，适合 `count()` 查询。
  PetFilter withoutPaging() => PetFilter(
    keyword: keyword,
    species: species,
    includePlaceholder: includePlaceholder,
  );
}
