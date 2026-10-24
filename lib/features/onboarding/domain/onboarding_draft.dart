import 'package:flutter/foundation.dart';

import '../../../core/units/units.dart';
import '../../entries/domain/entry_codes.dart';
import '../../pets/domain/pet_codes.dart';
import '../../plans/domain/parasite_choice.dart';

export '../../plans/domain/parasite_choice.dart';

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
