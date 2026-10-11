import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/core/codes/coded_enum.dart';
import 'package:pet_health/core/format/date_display.dart';
import 'package:pet_health/core/units/unit_preferences.dart';
import 'package:pet_health/core/units/units.dart';
import 'package:pet_health/features/entries/domain/entry_codes.dart';
import 'package:pet_health/features/entries/domain/entry_details.dart';
import 'package:pet_health/features/cards/domain/card_codes.dart';
import 'package:pet_health/features/pets/domain/pet_codes.dart';
import 'package:pet_health/features/plans/domain/plan_codes.dart';
import 'package:pet_health/features/plans/domain/plan_schedule.dart';

/// 所有会写进数据库的 enum。新增 enum 时加到这里。
const List<List<CodedEnum>> _storedEnums = [
  EntryType.values,
  Appetite.values,
  WaterIntake.values,
  PottyKind.values,
  StoolStatus.values,
  UrineStatus.values,
  CoatCondition.values,
  BathPlace.values,
  GroomingPlace.values,
  DewormerCoverage.values,
  EarCondition.values,
  OtherCareKind.values,
  SymptomKind.values,
  SymptomStatus.values,
  WeightUnit.values,
  VolumeUnit.values,
  DistanceUnit.values,
  TemperatureUnit.values,
  PortionUnit.values,
  UnitSystem.values,
  DateDisplayFormat.values,
  PetSex.values,
  BirthPrecision.values,
  BreedGroup.values,
  WeightCadence.values,
  PlanScheduleKind.values,
  PlanSource.values,
  CardCategory.values,
  CardFrequency.values,
];

/// 每种记录类型各一个填满字段的例子。
const _filled = <EntryType, EntryDetails>{
  EntryType.meal: MealDetails(appetite: Appetite.leftSome),
  EntryType.water: WaterDetails(intake: WaterIntake.more),
  EntryType.potty: PottyDetails(
    kind: PottyKind.poop,
    stool: StoolStatus.bloodOrMucus,
  ),
  EntryType.brushing: BrushingDetails(coat: CoatCondition.heavyShedding),
  EntryType.bath: BathDetails(where: BathPlace.groomer),
  EntryType.grooming: GroomingDetails(where: GroomingPlace.home),
  EntryType.dewormer: DewormerDetails(
    coverage: {DewormerCoverage.external, DewormerCoverage.internal},
  ),
  EntryType.earCheck: EarCheckDetails(ears: EarCondition.redOrSmelly),
  EntryType.otherCare: OtherCareDetails(kind: OtherCareKind.nails),
  EntryType.symptom: SymptomDetails(
    kind: SymptomKind.lowEnergy,
    status: SymptomStatus.worse,
  ),
};

void main() {
  test('存储用的 code 在同一个 enum 内唯一，且为小写下划线格式', () {
    final format = RegExp(r'^[a-z][a-z0-9]*(_[a-z0-9]+)*$');
    for (final values in _storedEnums) {
      final codes = values.map((value) => value.code).toList();
      expect(codes.toSet(), hasLength(codes.length), reason: '$codes');
      for (final code in codes) {
        expect(code, matches(format));
      }
    }
  });

  group('EntryDetails JSON', () {
    test('每种类型往返后内容不变', () {
      for (final type in EntryType.values) {
        final details = _filled[type] ?? const NoDetails();
        final json = details.toJson();
        expect(EntryDetails.fromJson(type, json), details, reason: type.code);
      }
    });

    test('JSON 里只有 code 字符串', () {
      expect(_filled[EntryType.potty]!.toJson(), {
        'kind': 'poop',
        'stool': 'blood_or_mucus',
      });
      expect(_filled[EntryType.dewormer]!.toJson(), {
        'coverage': ['internal', 'external'],
      });
    });

    test('未填写的字段不写进 JSON', () {
      expect(const MealDetails().toJson(), isEmpty);
      expect(const DewormerDetails().toJson(), isEmpty);
    });

    test('不认识的 code 按未填写处理，不报错', () {
      final details = EntryDetails.fromJson(EntryType.potty, {
        'kind': 'poop',
        'stool': 'rainbow',
        'urine': 42,
        'unknownField': 'x',
      });
      expect(details, const PottyDetails(kind: PottyKind.poop));

      final dewormer = EntryDetails.fromJson(EntryType.dewormer, {
        'coverage': ['internal', 'cosmic'],
      });
      expect(
        dewormer,
        const DewormerDetails(coverage: {DewormerCoverage.internal}),
      );
      expect(
        EntryDetails.fromJson(EntryType.dewormer, {'coverage': 'internal'}),
        const DewormerDetails(),
      );
    });

    test('类型和细节对应', () {
      expect(EntryDetails.fromJson(EntryType.meal, {}), isA<MealDetails>());
      expect(EntryDetails.fromJson(EntryType.weight, {}), isA<NoDetails>());
      expect(decodeCode(EntryType.values, 'ear_check'), EntryType.earCheck);
      expect(decodeCode(EntryType.values, 'earCheck'), isNull);
    });
  });
}
