import '../../../core/codes/coded_enum.dart';

/// 每日卡片的四种类别。
enum CardCategory implements CodedEnum {
  /// 和平时不一样。
  observation('observation'),

  /// 计划该做了。
  comingUp('coming_up'),

  /// 结合当天情况的小贴士。
  tip('tip'),

  /// 陪伴时刻。
  moment('moment');

  const CardCategory(this.code);

  @override
  final String code;
}

/// 每类卡片的出现频率，用户在设置里调整。
enum CardFrequency implements CodedEnum {
  off('off'),
  less('less'),
  normal('normal');

  const CardFrequency(this.code);

  @override
  final String code;

  /// "少看这类"按钮：降一档。
  CardFrequency get lowered => switch (this) {
    normal => less,
    less || off => off,
  };
}
