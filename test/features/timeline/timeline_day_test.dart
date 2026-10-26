import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/features/entries/domain/entry.dart';
import 'package:pet_health/features/entries/domain/entry_codes.dart';
import 'package:pet_health/features/entries/domain/entry_details.dart';
import 'package:pet_health/features/timeline/domain/timeline_day.dart';

Entry _entry(String id, DateTime at) => Entry(
  id: id,
  petId: 'p',
  type: EntryType.meal,
  occurredAt: at,
  details: const MealDetails(),
  note: '',
  createdAt: at,
  updatedAt: at,
);

void main() {
  test('按本地自然日分组：零点算新的一天，顺序不变', () {
    final days = groupByDay([
      _entry('a', DateTime(2026, 10, 26, 0, 0)),
      _entry('b', DateTime(2026, 10, 25, 23, 59)),
      _entry('c', DateTime(2026, 10, 25, 8)),
      _entry('d', DateTime(2026, 10, 20, 12)),
    ]);

    expect([for (final day in days) day.date], [
      DateTime(2026, 10, 26),
      DateTime(2026, 10, 25),
      DateTime(2026, 10, 20),
    ]);
    expect([for (final e in days[1].entries) e.id], ['b', 'c']);
    expect(groupByDay(const []), isEmpty);
  });
}
