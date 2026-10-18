import 'package:drift/drift.dart';

import '../../../core/db/pet_health_database.dart';
import '../domain/plan_schedule.dart';

/// 把排期写成 `plans` 表的几列；其他排期方式的列一律清空。
PlansCompanion scheduleColumns(PlanSchedule schedule) => switch (schedule) {
  EveryNDays(:final days) => PlansCompanion(
    schedule: const Value(PlanScheduleKind.everyNDays),
    intervalDays: Value(days),
    weekdays: const Value(null),
    dueAt: const Value(null),
  ),
  OnWeekdays(:final mask) => PlansCompanion(
    schedule: const Value(PlanScheduleKind.weekdays),
    intervalDays: const Value(null),
    weekdays: Value(mask),
    dueAt: const Value(null),
  ),
  Once(:final dueAt) => PlansCompanion(
    schedule: const Value(PlanScheduleKind.once),
    intervalDays: const Value(null),
    weekdays: const Value(null),
    dueAt: Value(dueAt.toUtc()),
  ),
};

/// 从 `plans` 表的一行读出排期。表上的 CHECK 约束保证对应的列不为空。
PlanSchedule scheduleFromRow(PlanRow row) => switch (row.schedule) {
  PlanScheduleKind.everyNDays => EveryNDays(row.intervalDays!),
  PlanScheduleKind.weekdays => OnWeekdays(row.weekdays!),
  PlanScheduleKind.once => Once(row.dueAt!.toLocal()),
};
