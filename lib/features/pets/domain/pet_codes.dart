import '../../../core/codes/coded_enum.dart';

enum PetSex implements CodedEnum {
  male('male'),
  female('female');

  const PetSex(this.code);

  @override
  final String code;
}

/// 生日的精度；不知道确切日期时可以只填年月。
enum BirthPrecision implements CodedEnum {
  day('day'),

  /// 只知道年月，`birthDate` 存当月 1 日。
  month('month');

  const BirthPrecision(this.code);

  @override
  final String code;
}

/// 按"体型 + 毛发类型"划分的犬种分组，决定默认的记录项和护理间隔。
enum BreedGroup implements CodedEnum {
  largeDouble('large_double'),
  mediumDouble('medium_double'),
  smallSilky('small_silky'),
  curly('curly'),
  smallShort('small_short'),
  largeShort('large_short'),
  mixed('mixed');

  const BreedGroup(this.code);

  @override
  final String code;
}
