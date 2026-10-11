/// 会被写进数据库的 enum。
///
/// [code] 一经存储就不能修改或删除（废弃的值保留、只是不再显示）；
/// Dart 侧的名称可以随意重构，不影响已存数据。
abstract interface class CodedEnum {
  String get code;
}

/// 按 [code] 查找 enum 值；不认识的 code 或非字符串返回 `null`。
T? decodeCode<T extends CodedEnum>(Iterable<T> values, Object? code) {
  if (code is! String) return null;
  for (final value in values) {
    if (value.code == code) return value;
  }
  return null;
}

/// 解码 code 列表，跳过不认识的值；不是列表时返回空集合。
Set<T> decodeCodeSet<T extends CodedEnum>(Iterable<T> values, Object? codes) {
  if (codes is! List) return <T>{};
  return {for (final code in codes) ?decodeCode(values, code)};
}
