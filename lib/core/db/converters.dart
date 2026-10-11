import 'dart:convert';

import 'package:drift/drift.dart';

import '../codes/coded_enum.dart';

/// 把 [CodedEnum] 存成 code 文本。
///
/// 非空列读到不认识的 code 时抛 [FormatException]；可空列需要容忍未知值时，
/// 在 Repository 里先按文本读取再用 [decodeCode] 解码。
class CodedEnumConverter<T extends CodedEnum> extends TypeConverter<T, String> {
  const CodedEnumConverter(this.values);

  final List<T> values;

  @override
  T fromSql(String fromDb) =>
      decodeCode(values, fromDb) ??
      (throw FormatException('Unknown ${T.toString()} code', fromDb));

  @override
  String toSql(T value) => value.code;
}

/// 本地日历日期（没有时间和时区），存成 `yyyy-MM-dd`。
///
/// Dart 侧用当天零点的本地 [DateTime] 表示；写入时忽略时分秒。
class LocalDateConverter extends TypeConverter<DateTime, String> {
  const LocalDateConverter();

  @override
  DateTime fromSql(String fromDb) {
    final parts = fromDb.split('-');
    if (parts.length != 3) throw FormatException('Invalid date', fromDb);
    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  @override
  String toSql(DateTime value) => formatLocalDate(value);
}

String formatLocalDate(DateTime value) =>
    '${value.year.toString().padLeft(4, '0')}-'
    '${value.month.toString().padLeft(2, '0')}-'
    '${value.day.toString().padLeft(2, '0')}';

/// JSON 对象，用于 `details`、`params` 这类只存 code 的结构化字段。
class JsonMapConverter extends TypeConverter<Map<String, Object?>, String> {
  const JsonMapConverter();

  @override
  Map<String, Object?> fromSql(String fromDb) {
    final decoded = jsonDecode(fromDb);
    return decoded is Map<String, Object?> ? decoded : const {};
  }

  @override
  String toSql(Map<String, Object?> value) => jsonEncode(value);
}

/// [CodedEnum] 列表，跳过不认识的 code，用于 `quickTypes` 这类可排序的选择。
class CodedEnumListConverter<T extends CodedEnum>
    extends TypeConverter<List<T>, String> {
  const CodedEnumListConverter(this.values);

  final List<T> values;

  @override
  List<T> fromSql(String fromDb) {
    final decoded = jsonDecode(fromDb);
    if (decoded is! List) return const [];
    return [for (final code in decoded) ?decodeCode(values, code)];
  }

  @override
  String toSql(List<T> value) =>
      jsonEncode([for (final item in value) item.code]);
}
