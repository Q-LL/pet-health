import '../../../core/codes/coded_enum.dart';

enum PlanSource implements CodedEnum {
  /// 按犬种分组自动生成。
  breedDefault('breed_default'),

  /// 用户自己建的。
  user('user');

  const PlanSource(this.code);

  @override
  final String code;
}
