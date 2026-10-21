import 'package:flutter/foundation.dart';

import '../../../core/units/units.dart';
import '../../entries/domain/entry_codes.dart';
import '../../pets/domain/pet_codes.dart';
import '../../plans/domain/plan_schedule.dart';

/// 某一类驱虫的管理方式。
enum ParasiteMode { scheduled, tests, none }

/// 一类驱虫的选择：方式和间隔。[ParasiteMode.none] 时 [schedule] 不用。
@immutable
class ParasiteChoice {
  const ParasiteChoice(this.mode, this.schedule);

  const ParasiteChoice.none() : mode = ParasiteMode.none, schedule = null;

  final ParasiteMode mode;
  final PlanSchedule? schedule;

  @override
  bool operator ==(Object other) =>
      other is ParasiteChoice &&
      mode == other.mode &&
      schedule == other.schedule;

  @override
  int get hashCode => Object.hash(mode, schedule);
}

/// 每一类可选的方式和间隔。这些只是常见的选项，具体按医生的建议选。
abstract final class ParasiteOptions {
  static List<ParasiteMode> modesFor(ParasiteCoverage coverage) =>
      switch (coverage) {
        // 跳蚤和蜱虫靠检查发现没有意义，只有按时用药。
        ParasiteCoverage.fleasTicks => const [
          ParasiteMode.scheduled,
          ParasiteMode.none,
        ],
        _ => ParasiteMode.values,
      };

  static List<PlanSchedule> schedulesFor(
    ParasiteCoverage coverage,
    ParasiteMode mode,
  ) => switch ((coverage, mode)) {
    (ParasiteCoverage.intestinal, ParasiteMode.scheduled) => const [
      EveryNMonths(1),
      EveryNMonths(3),
      EveryNMonths(6),
    ],
    (ParasiteCoverage.fleasTicks, ParasiteMode.scheduled) => const [
      EveryNMonths(1),
      EveryNDays(84),
    ],
    (ParasiteCoverage.heartworm, ParasiteMode.scheduled) => const [
      EveryNMonths(1),
      EveryNMonths(6),
      EveryNMonths(12),
    ],
    (ParasiteCoverage.intestinal, ParasiteMode.tests) => const [
      EveryNMonths(3),
      EveryNMonths(6),
      EveryNMonths(12),
    ],
    (ParasiteCoverage.heartworm, ParasiteMode.tests) => const [
      EveryNMonths(12),
      EveryNMonths(6),
    ],
    _ => const [],
  };

  /// 选了某种方式但还没选间隔时，默认用第一个。
  static ParasiteChoice defaultFor(
    ParasiteCoverage coverage,
    ParasiteMode mode,
  ) => mode == ParasiteMode.none
      ? const ParasiteChoice.none()
      : ParasiteChoice(mode, schedulesFor(coverage, mode).first);
}

/// 引导流程里填写的全部内容。只有名字必填。
@immutable
class OnboardingDraft {
  const OnboardingDraft({
    this.name = '',
    this.sex,
    this.breedCode,
    this.breedName,
    this.breedGroup,
    this.birthDate,
    this.birthPrecision = BirthPrecision.day,
    this.homeDate,
    this.mealAmount,
    this.mealUnit,
    this.mealsPerDay,
    this.bowlMl,
    this.parasites = const {},
  });

  final String name;
  final PetSex? sex;
  final String? breedCode;
  final String? breedName;

  /// 为空时按 [breedCode] 推导。
  final BreedGroup? breedGroup;
  final DateTime? birthDate;
  final BirthPrecision birthPrecision;
  final DateTime? homeDate;
  final double? mealAmount;
  final PortionUnit? mealUnit;
  final int? mealsPerDay;
  final double? bowlMl;

  /// 没有出现的类别视为"先不设置"。
  final Map<ParasiteCoverage, ParasiteChoice> parasites;

  ParasiteChoice parasite(ParasiteCoverage coverage) =>
      parasites[coverage] ?? const ParasiteChoice.none();

  OnboardingDraft copyWith({
    String? name,
    ValueGetter<PetSex?>? sex,
    ValueGetter<String?>? breedCode,
    ValueGetter<String?>? breedName,
    ValueGetter<BreedGroup?>? breedGroup,
    ValueGetter<DateTime?>? birthDate,
    BirthPrecision? birthPrecision,
    ValueGetter<DateTime?>? homeDate,
    ValueGetter<double?>? mealAmount,
    ValueGetter<PortionUnit?>? mealUnit,
    ValueGetter<int?>? mealsPerDay,
    ValueGetter<double?>? bowlMl,
    Map<ParasiteCoverage, ParasiteChoice>? parasites,
  }) => OnboardingDraft(
    name: name ?? this.name,
    sex: sex == null ? this.sex : sex(),
    breedCode: breedCode == null ? this.breedCode : breedCode(),
    breedName: breedName == null ? this.breedName : breedName(),
    breedGroup: breedGroup == null ? this.breedGroup : breedGroup(),
    birthDate: birthDate == null ? this.birthDate : birthDate(),
    birthPrecision: birthPrecision ?? this.birthPrecision,
    homeDate: homeDate == null ? this.homeDate : homeDate(),
    mealAmount: mealAmount == null ? this.mealAmount : mealAmount(),
    mealUnit: mealUnit == null ? this.mealUnit : mealUnit(),
    mealsPerDay: mealsPerDay == null ? this.mealsPerDay : mealsPerDay(),
    bowlMl: bowlMl == null ? this.bowlMl : bowlMl(),
    parasites: parasites ?? this.parasites,
  );
}
