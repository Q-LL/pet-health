import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/core/format/date_display.dart';

void main() {
  final date = DateTime(2026, 3, 7);

  test('三种显示顺序', () {
    expect(formatDisplayDate(date, DateDisplayFormat.ymd), '2026-03-07');
    expect(formatDisplayDate(date, DateDisplayFormat.mdy), '03/07/2026');
    expect(formatDisplayDate(date, DateDisplayFormat.dmy), '07/03/2026');
  });

  test('省略年份', () {
    expect(
      formatDisplayDate(date, DateDisplayFormat.ymd, withYear: false),
      '03-07',
    );
    expect(
      formatDisplayDate(date, DateDisplayFormat.mdy, withYear: false),
      '03/07',
    );
  });

  group('自动', () {
    const auto = DateDisplayFormat.auto;

    test('美国用月日年', () {
      expect(
        auto.resolve(countryCode: 'us', languageCode: 'en'),
        DateDisplayFormat.mdy,
      );
      // 在美国用中文系统，仍按地区显示月日年。
      expect(
        auto.resolve(countryCode: 'US', languageCode: 'zh'),
        DateDisplayFormat.mdy,
      );
    });

    test('中文和中国地区用年月日', () {
      expect(
        auto.resolve(countryCode: 'CN', languageCode: 'zh'),
        DateDisplayFormat.ymd,
      );
      expect(auto.resolve(languageCode: 'zh'), DateDisplayFormat.ymd);
    });

    test('其他地区用日月年，不知道地区和语言时用年月日', () {
      expect(
        auto.resolve(countryCode: 'GB', languageCode: 'en'),
        DateDisplayFormat.dmy,
      );
      expect(auto.resolve(), DateDisplayFormat.ymd);
    });

    test('用户手动选择优先', () {
      expect(
        DateDisplayFormat.dmy.resolve(countryCode: 'US'),
        DateDisplayFormat.dmy,
      );
    });
  });
}
