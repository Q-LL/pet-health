import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/core/codes/coded_enum.dart';
import 'package:pet_health/core/format/date_display.dart';
import 'package:pet_health/core/l10n/app_locale.dart';
import 'package:pet_health/core/l10n/labels.dart';
import 'package:pet_health/core/l10n/unit_format.dart';
import 'package:pet_health/core/units/unit_preferences.dart';
import 'package:pet_health/core/units/units.dart';
import 'package:pet_health/features/cards/domain/card_codes.dart';
import 'package:pet_health/features/entries/domain/entry_codes.dart';
import 'package:pet_health/features/pets/domain/breed_catalog.dart';
import 'package:pet_health/features/pets/domain/pet_codes.dart';
import 'package:pet_health/features/plans/domain/plan_schedule.dart';
import 'package:pet_health/features/settings/domain/app_preferences.dart';

final en = lookupAppLocalizations(const Locale('en'));
final zh = lookupAppLocalizations(const Locale('zh'));

/// 记录细节里的全部选项 enum。
const List<List<CodedEnum>> _optionEnums = [
  Appetite.values,
  WaterIntake.values,
  PottyKind.values,
  StoolStatus.values,
  UrineStatus.values,
  CoatCondition.values,
  BathPlace.values,
  GroomingPlace.values,
  ParasiteCoverage.values,
  VetTestKind.values,
  VetTestResult.values,
  EarCondition.values,
  OtherCareKind.values,
  SymptomKind.values,
  SymptomStatus.values,
];

Map<String, Object?> _arb(String name) =>
    jsonDecode(File('lib/core/l10n/arb/$name').readAsStringSync())
        as Map<String, Object?>;

void _expectDistinctLabels<T>(
  Iterable<T> values,
  String Function(AppLocalizations l, T value) label,
) {
  for (final l in [en, zh]) {
    final labels = values.map((value) => label(l, value)).toList();
    expect(labels.every((text) => text.trim().isNotEmpty), isTrue);
    expect(labels.toSet(), hasLength(labels.length), reason: '$labels');
  }
}

void main() {
  group('翻译文件', () {
    test('中英文的键完全一致', () {
      Set<String> keys(Map<String, Object?> arb) =>
          arb.keys.where((key) => !key.startsWith('@')).toSet();
      expect(keys(_arb('app_zh.arb')), keys(_arb('app_en.arb')));
    });

    test('英文模板的每条文字都有说明，带参数的都声明了参数', () {
      final arb = _arb('app_en.arb');
      for (final key in arb.keys.where((key) => !key.startsWith('@'))) {
        final meta = arb['@$key'] as Map<String, Object?>?;
        expect(meta?['description'], isA<String>(), reason: key);
        if ((arb[key] as String).contains('{')) {
          expect(meta!['placeholders'], isA<Map>(), reason: key);
        }
      }
    });
  });

  group('code 的显示文字', () {
    test('同一组里的名称非空且互不相同', () {
      _expectDistinctLabels(EntryType.values, (l, v) => l.entryType(v));
      for (final values in _optionEnums) {
        _expectDistinctLabels(values, (l, v) => l.option(v));
      }
      _expectDistinctLabels(PetSex.values, (l, v) => l.sex(v));
      _expectDistinctLabels(BreedGroup.values, (l, v) => l.breedGroup(v));
      _expectDistinctLabels(UnitSystem.values, (l, v) => l.unitSystem(v));
      _expectDistinctLabels(
        DateDisplayFormat.values,
        (l, v) => l.dateFormat(v),
      );
      _expectDistinctLabels(CardCategory.values, (l, v) => l.cardCategory(v));
      _expectDistinctLabels(CardFrequency.values, (l, v) => l.cardFrequency(v));
    });

    test('语言选项里的语言名称保持本来的写法', () {
      for (final l in [en, zh]) {
        expect(l.language(AppLanguage.zh), '中文');
        expect(l.language(AppLanguage.en), 'English');
      }
      expect(
        en.language(AppLanguage.system),
        isNot(zh.language(AppLanguage.system)),
      );
    });

    test('每个预设犬种都有中英文名称，未知犬种返回 null', () {
      for (final code in breedCatalog.keys) {
        expect(en.breed(code), isNotNull, reason: code);
        expect(zh.breed(code), isNotNull, reason: code);
      }
      _expectDistinctLabels(breedCatalog.keys, (l, code) => l.breed(code)!);
      expect(en.breed('unknown'), isNull);
      expect(en.breed(null), isNull);
    });

    test('例子', () {
      expect(en.entryType(EntryType.parasitePrevention), 'Parasite prevention');
      expect(zh.entryType(EntryType.parasitePrevention), '驱虫');
      expect(en.option(ParasiteCoverage.heartworm), 'Heartworm prevention');
      expect(zh.option(StoolStatus.bloodOrMucus), '有血或黏液');
      expect(en.breed('golden_retriever'), 'Golden Retriever');
      expect(zh.breed('poodle'), '贵宾（泰迪）');
    });

    test('不是记录选项的 enum 不能当选项显示', () {
      expect(() => en.option(EntryType.meal), throwsArgumentError);
    });
  });

  group('单位', () {
    test('体重换算后保留 1 位小数', () {
      expect(en.weight(31.2, WeightUnit.kg), '31.2 kg');
      expect(en.weight(31.2, WeightUnit.lb), '68.8 lb');
      expect(zh.weight(31.2, WeightUnit.jin), '62.4 斤');
      expect(en.weight(30, WeightUnit.kg), '30 kg');
    });

    test('水量：ml 和 oz 取整，杯保留 1 位小数并区分单复数', () {
      expect(en.water(750, VolumeUnit.ml), '750 ml');
      expect(en.water(750, VolumeUnit.oz), '25 oz');
      expect(en.water(236.588, VolumeUnit.cup), '1 cup');
      expect(en.water(750, VolumeUnit.cup), '3.2 cups');
      expect(zh.water(750, VolumeUnit.cup), '3.2 杯');
    });

    test('距离和温度', () {
      expect(en.distance(2400, DistanceUnit.km), '2.4 km');
      expect(zh.distance(2400, DistanceUnit.km), '2.4 公里');
      expect(en.distance(538000, DistanceUnit.mi), '334.3 mi');
      expect(en.temperature(33, TemperatureUnit.f), '91°F');
      expect(zh.temperature(21.4, TemperatureUnit.c), '21°C');
      expect(en.temperature(-0.3, TemperatureUnit.c), '0°C');
    });

    test('份量最多 2 位小数，英文区分单复数', () {
      expect(en.portion(1, PortionUnit.scoop), '1 scoop');
      expect(en.portion(2, PortionUnit.scoop), '2 scoops');
      expect(en.portion(0.25, PortionUnit.cup), '0.25 cups');
      expect(en.portion(1.5, PortionUnit.cup), '1.5 cups');
      expect(zh.portion(2, PortionUnit.scoop), '2 勺');
      expect(zh.portion(120, PortionUnit.g), '120 克');
      expect(en.portion(1, PortionUnit.tablet), '1 tablet');
    });

    test('每个单位在两种语言下都能显示', () {
      for (final l in [en, zh]) {
        for (final unit in WeightUnit.values) {
          expect(l.weight(10, unit), isNotEmpty);
        }
        for (final unit in VolumeUnit.values) {
          expect(l.water(500, unit), isNotEmpty);
        }
        for (final unit in PortionUnit.values) {
          expect(l.portion(2, unit), contains('2'));
        }
      }
    });
  });

  group('天数与排期', () {
    test('天数区分单复数', () {
      expect(en.dayCount(1), '1 day');
      expect(en.dayCount(34), '34 days');
      expect(zh.dayCount(34), '34 天');
      expect(en.daysAgo(0), 'Today');
      expect(en.daysAgo(1), 'Yesterday');
      expect(zh.daysAgo(5), '5 天前');
      expect(zh.dayTogether(500), '在一起的第 500 天');
    });

    test('排期描述', () {
      String both(PlanSchedule schedule) => [
        en.schedule(schedule, dateFormat: DateDisplayFormat.mdy),
        zh.schedule(schedule, dateFormat: DateDisplayFormat.ymd),
      ].join(' | ');

      expect(both(const EveryNDays(1)), 'Every day | 每天');
      expect(both(const EveryNDays(7)), 'Every week | 每周');
      expect(both(const EveryNDays(35)), 'Every 35 days | 每 35 天');
      expect(both(const EveryNMonths(1)), 'Every month | 每月');
      expect(both(const EveryNMonths(6)), 'Every 6 months | 每 6 个月');
      expect(both(const EveryNMonths(12)), 'Every year | 每年');
      expect(
        both(OnWeekdays(Weekdays.maskOf(const [1, 3, 5]))),
        'Mon, Wed, Fri | 每周一、三、五',
      );
      expect(both(const OnWeekdays(Weekdays.all)), 'Every day | 每天');
      expect(
        both(Once(DateTime(2026, 10, 20, 15, 30))),
        'On 10/20/2026 | 2026-10-20',
      );
    });
  });

  group('界面语言', () {
    test('手动选择优先', () {
      expect(
        resolveAppLocale(AppLanguage.zh, const [Locale('en', 'US')]),
        const Locale('zh'),
      );
      expect(
        resolveAppLocale(AppLanguage.en, const [Locale('zh', 'CN')]),
        const Locale('en'),
      );
    });

    test('跟随系统时取第一个受支持的语言，都不支持时用英文', () {
      expect(
        resolveAppLocale(AppLanguage.system, const [Locale('zh', 'TW')]),
        const Locale('zh'),
      );
      expect(
        resolveAppLocale(AppLanguage.system, const [
          Locale('ja'),
          Locale('zh', 'CN'),
        ]),
        const Locale('zh'),
      );
      expect(
        resolveAppLocale(AppLanguage.system, const [Locale('fr', 'FR')]),
        const Locale('en'),
      );
      expect(
        resolveAppLocale(AppLanguage.system, const []),
        const Locale('en'),
      );
    });

    test('地区取系统首选语言的地区', () {
      expect(systemRegion(const [Locale('zh', 'US')]), 'US');
      expect(systemRegion(const [Locale('en')]), isNull);
      expect(systemRegion(const []), isNull);
    });
  });
}
