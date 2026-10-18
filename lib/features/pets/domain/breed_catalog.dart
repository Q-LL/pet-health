import 'package:flutter/foundation.dart';

import '../../entries/domain/entry_codes.dart';
import '../../plans/domain/plan_schedule.dart';
import 'pet_codes.dart';

/// 预设的常见犬种。名称来自翻译文件，这里只有 code 和分组。
///
/// code 会存进 `pets.breedCode`，规则同 CodedEnum：只加不改。
const breedCatalog = <String, BreedGroup>{
  'golden_retriever': BreedGroup.largeDouble,
  'labrador_retriever': BreedGroup.largeDouble,
  'german_shepherd': BreedGroup.largeDouble,
  'bernese_mountain_dog': BreedGroup.largeDouble,
  'samoyed': BreedGroup.largeDouble,
  'siberian_husky': BreedGroup.largeDouble,
  'corgi': BreedGroup.mediumDouble,
  'shiba_inu': BreedGroup.mediumDouble,
  'border_collie': BreedGroup.mediumDouble,
  'australian_shepherd': BreedGroup.mediumDouble,
  'cavalier_king_charles_spaniel': BreedGroup.smallSilky,
  'maltese': BreedGroup.smallSilky,
  'yorkshire_terrier': BreedGroup.smallSilky,
  'shih_tzu': BreedGroup.smallSilky,
  'papillon': BreedGroup.smallSilky,
  'poodle': BreedGroup.curly,
  'bichon_frise': BreedGroup.curly,
  'doodle': BreedGroup.curly,
  'french_bulldog': BreedGroup.smallShort,
  'pug': BreedGroup.smallShort,
  'chihuahua': BreedGroup.smallShort,
  'dachshund': BreedGroup.smallShort,
  'beagle': BreedGroup.largeShort,
  'boxer': BreedGroup.largeShort,
  'doberman': BreedGroup.largeShort,
  'pit_bull': BreedGroup.largeShort,
};

/// 预设犬种的分组；不在列表里时为混种 / 不确定。
BreedGroup breedGroupFor(String? breedCode) =>
    breedCatalog[breedCode] ?? BreedGroup.mixed;

/// 体重计划可选的间隔天数：每周、每两周、每月、每季度。
const weightCheckIntervals = [7, 14, 30, 90];

/// 新建狗狗时按分组生成的一个计划。
@immutable
class DefaultPlan {
  const DefaultPlan(this.entryType, this.schedule, {this.entryKind});

  final EntryType entryType;
  final String? entryKind;
  final PlanSchedule schedule;
}

/// 分组的默认护理计划，对应 docs/COPY_DRAFT.md 第 6 节。
///
/// 只是护理习惯上的建议，用户可以随时修改或删除。驱虫和心丝虫药的间隔
/// 因地区和兽医建议而不同，不在这里自动生成，由引导流程询问。
List<DefaultPlan> defaultPlansFor(BreedGroup group) {
  OnWeekdays perWeek(int times) => OnWeekdays(Weekdays.forTimesPerWeek(times));

  final (brushing, bathDays) = switch (group) {
    BreedGroup.largeDouble => (4, 42),
    BreedGroup.mediumDouble => (3, 42),
    BreedGroup.smallSilky => (4, 21),
    BreedGroup.curly => (4, 21),
    BreedGroup.smallShort => (1, 42),
    BreedGroup.largeShort => (1, 42),
    BreedGroup.mixed => (2, 35),
  };

  return [
    DefaultPlan(EntryType.brushing, perWeek(brushing)),
    DefaultPlan(EntryType.bath, EveryNDays(bathDays)),
    const DefaultPlan(EntryType.weight, EveryNDays(30)),
    if (group == BreedGroup.curly)
      const DefaultPlan(EntryType.grooming, EveryNDays(35)),
    if (group
        case BreedGroup.largeDouble ||
            BreedGroup.smallSilky ||
            BreedGroup.curly)
      DefaultPlan(EntryType.earCheck, perWeek(1)),
    if (group == BreedGroup.smallSilky)
      DefaultPlan(
        EntryType.otherCare,
        perWeek(1),
        entryKind: OtherCareKind.eyes.code,
      ),
    if (group == BreedGroup.smallShort)
      DefaultPlan(
        EntryType.otherCare,
        perWeek(1),
        entryKind: OtherCareKind.teeth.code,
      ),
  ];
}
