import 'package:flutter/foundation.dart';

import '../../entries/domain/entry_codes.dart';
import 'plan.dart';
import 'plan_schedule.dart';

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

/// 一类驱虫的选择对应的计划："按时用药"记驱虫，"定期检查"记检查。
PlanDraft? parasitePlanDraft(
  String petId,
  ParasiteCoverage coverage,
  ParasiteChoice choice,
) {
  final schedule = choice.schedule;
  if (schedule == null) return null;
  final testKind = _testKindFor(coverage);
  return switch (choice.mode) {
    ParasiteMode.none => null,
    ParasiteMode.scheduled => PlanDraft(
      petId: petId,
      entryType: EntryType.parasitePrevention,
      entryKind: coverage.code,
      schedule: schedule,
    ),
    ParasiteMode.tests when testKind != null => PlanDraft(
      petId: petId,
      entryType: EntryType.vetTest,
      entryKind: testKind.code,
      schedule: schedule,
    ),
    ParasiteMode.tests => null,
  };
}

/// 从已有的计划读出一类驱虫当前的方式；两种都有时以按时用药为准。
ParasiteChoice parasiteChoiceFromPlans(
  ParasiteCoverage coverage,
  Iterable<Plan> plans,
) {
  final testKind = _testKindFor(coverage);
  for (final plan in plans) {
    if (plan.entryType == EntryType.parasitePrevention &&
        plan.entryKind == coverage.code) {
      return ParasiteChoice(ParasiteMode.scheduled, plan.schedule);
    }
  }
  for (final plan in plans) {
    if (testKind != null &&
        plan.entryType == EntryType.vetTest &&
        plan.entryKind == testKind.code) {
      return ParasiteChoice(ParasiteMode.tests, plan.schedule);
    }
  }
  return const ParasiteChoice.none();
}

/// 一类驱虫对应的计划是否属于这一类（换方式时要先删掉）。
bool isParasitePlanFor(ParasiteCoverage coverage, Plan plan) {
  final testKind = _testKindFor(coverage);
  return (plan.entryType == EntryType.parasitePrevention &&
          plan.entryKind == coverage.code) ||
      (testKind != null &&
          plan.entryType == EntryType.vetTest &&
          plan.entryKind == testKind.code);
}

/// 定期检查时查的项目；跳蚤和蜱虫不靠检查。
VetTestKind? _testKindFor(ParasiteCoverage coverage) => switch (coverage) {
  ParasiteCoverage.intestinal => VetTestKind.fecal,
  ParasiteCoverage.heartworm => VetTestKind.heartworm,
  ParasiteCoverage.fleasTicks => null,
};
