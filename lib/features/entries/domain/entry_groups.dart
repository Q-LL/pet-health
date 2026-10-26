import 'entry_codes.dart';

/// 记录类型的分组：记录中心按它排列，时间线按它筛选。
///
/// 只用于显示，不存进数据库。每种记录类型恰好属于一组。
enum EntryGroup {
  daily([EntryType.meal, EntryType.water, EntryType.potty, EntryType.walk]),
  care([
    EntryType.brushing,
    EntryType.bath,
    EntryType.grooming,
    EntryType.earCheck,
  ]),
  health([
    EntryType.weight,
    EntryType.symptom,
    EntryType.medication,
    EntryType.vetTest,
  ]),
  more([
    EntryType.parasitePrevention,
    EntryType.vaccine,
    EntryType.otherCare,
    EntryType.custom,
  ]);

  const EntryGroup(this.types);

  final List<EntryType> types;
}
