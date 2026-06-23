import 'package:flutter/foundation.dart';

/// 狗狗照片筛选参数，用于 family provider 的 key。
@immutable
class PetPhotoFilter {
  const PetPhotoFilter({
    required this.petId,
    this.keyword,
    this.limit,
    this.offset = 0,
  });

  /// 目标狗狗 ID。
  final String petId;

  /// 关键词，匹配原文件名和照片说明。
  final String? keyword;

  /// 每页条数，`null` 表示不限制。
  final int? limit;

  /// 偏移量，默认 0。
  final int offset;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PetPhotoFilter &&
          runtimeType == other.runtimeType &&
          petId == other.petId &&
          keyword == other.keyword &&
          limit == other.limit &&
          offset == other.offset;

  @override
  int get hashCode => Object.hash(petId, keyword, limit, offset);

  /// 返回不带分页参数的副本，适合 `count()` 查询。
  PetPhotoFilter withoutPaging() =>
      PetPhotoFilter(petId: petId, keyword: keyword);
}
