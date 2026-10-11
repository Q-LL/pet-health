import '../codes/coded_enum.dart';

/// 日期的显示顺序，用户在设置里选择。只影响显示，数据库一律存 `yyyy-MM-dd`。
enum DateDisplayFormat implements CodedEnum {
  /// 跟随系统地区。
  auto('auto'),

  /// 2026-10-12
  ymd('ymd'),

  /// 10/12/2026
  mdy('mdy'),

  /// 12/10/2026
  dmy('dmy');

  const DateDisplayFormat(this.code);

  @override
  final String code;

  /// 把 [auto] 换成具体顺序：美国等地区用月日年，中日韩用年月日，其余用日月年。
  ///
  /// [countryCode] 为 ISO 3166 代码，[languageCode] 为 ISO 639 代码。
  DateDisplayFormat resolve({String? countryCode, String? languageCode}) {
    if (this != auto) return this;
    final country = countryCode?.toUpperCase();
    if (_monthFirstRegions.contains(country)) return mdy;
    if (_yearFirstLanguages.contains(languageCode?.toLowerCase()) ||
        _yearFirstRegions.contains(country)) {
      return ymd;
    }
    return languageCode == null && country == null ? ymd : dmy;
  }

  static const _monthFirstRegions = {'US', 'PH', 'FM', 'MH', 'PW'};
  static const _yearFirstLanguages = {'zh', 'ja', 'ko'};
  static const _yearFirstRegions = {'CN', 'TW', 'HK', 'JP', 'KR'};
}

/// 按 [format] 显示本地日期；[withYear] 为假时省略年份，用于今年内的日期。
///
/// [format] 为 [DateDisplayFormat.auto] 时按年月日显示；页面应先调用
/// [DateDisplayFormat.resolve]。
String formatDisplayDate(
  DateTime date,
  DateDisplayFormat format, {
  bool withYear = true,
}) {
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return switch (format) {
    DateDisplayFormat.mdy => withYear ? '$m/$d/$y' : '$m/$d',
    DateDisplayFormat.dmy => withYear ? '$d/$m/$y' : '$d/$m',
    DateDisplayFormat.ymd ||
    DateDisplayFormat.auto => withYear ? '$y-$m-$d' : '$m-$d',
  };
}
