import 'package:flutter/foundation.dart';

import '../../../core/units/units.dart';
import '../../entries/domain/entry_codes.dart';
import 'pet_codes.dart';

/// 狗狗档案。日期都是本地日历日期（当天零点）。
@immutable
class Pet {
  const Pet({
    required this.id,
    required this.name,
    required this.birthPrecision,
    required this.breedGroup,
    required this.createdAt,
    required this.updatedAt,
    this.sex,
    this.neutered,
    this.birthDate,
    this.homeDate,
    this.breedCode,
    this.breedName,
  });

  final String id;
  final String name;
  final PetSex? sex;
  final bool? neutered;
  final DateTime? birthDate;
  final BirthPrecision birthPrecision;
  final DateTime? homeDate;
  final String? breedCode;
  final String? breedName;
  final BreedGroup breedGroup;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// 在一起的第几天：到家当天是第 1 天。没填到家日期或日期在未来时为 `null`。
  int? dayTogether(DateTime today) {
    final home = homeDate;
    if (home == null) return null;
    final days = DateTime.utc(
      today.year,
      today.month,
      today.day,
    ).difference(DateTime.utc(home.year, home.month, home.day)).inDays;
    return days < 0 ? null : days + 1;
  }
}

/// 新建或修改档案时填写的内容。
@immutable
class PetDraft {
  const PetDraft({
    required this.name,
    this.sex,
    this.neutered,
    this.birthDate,
    this.birthPrecision = BirthPrecision.day,
    this.homeDate,
    this.breedCode,
    this.breedName,
    this.breedGroup,
  });

  final String name;
  final PetSex? sex;
  final bool? neutered;
  final DateTime? birthDate;
  final BirthPrecision birthPrecision;
  final DateTime? homeDate;

  /// 预设犬种；不在预设里的犬种写在 [breedName]。
  final String? breedCode;
  final String? breedName;

  /// 为空时按 [breedCode] 推导。
  final BreedGroup? breedGroup;
}

/// 每只狗的习惯预设，一键记录按这里的值填写。
@immutable
class PetPresets {
  const PetPresets({
    required this.petId,
    required this.quickTypes,
    this.mealAmount,
    this.mealUnit,
    this.mealsPerDay,
    this.bowlMl,
  });

  final String petId;
  final double? mealAmount;

  /// 为空时使用设置里的默认食物单位。
  final PortionUnit? mealUnit;
  final int? mealsPerDay;

  /// 水碗容量，单位 ml。
  final double? bowlMl;
  final List<EntryType> quickTypes;
}

@immutable
class PetPresetsDraft {
  const PetPresetsDraft({
    required this.quickTypes,
    this.mealAmount,
    this.mealUnit,
    this.mealsPerDay,
    this.bowlMl,
  });

  final double? mealAmount;
  final PortionUnit? mealUnit;
  final int? mealsPerDay;
  final double? bowlMl;
  final List<EntryType> quickTypes;
}
