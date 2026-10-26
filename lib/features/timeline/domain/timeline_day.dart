import 'package:flutter/foundation.dart';

import '../../entries/domain/entry.dart';

/// 时间线上的一天：本地日期和这一天的记录。
@immutable
class TimelineDay {
  const TimelineDay(this.date, this.entries);

  /// 本地日期的零点。
  final DateTime date;

  /// 按时间倒序。
  final List<Entry> entries;
}

/// 把按时间倒序排好的记录按本地自然日分组，保持原来的顺序。
List<TimelineDay> groupByDay(List<Entry> entries) {
  final days = <TimelineDay>[];
  for (final entry in entries) {
    final at = entry.occurredAt;
    final date = DateTime(at.year, at.month, at.day);
    if (days.isNotEmpty && days.last.date == date) {
      days.last.entries.add(entry);
    } else {
      days.add(TimelineDay(date, [entry]));
    }
  }
  return days;
}
