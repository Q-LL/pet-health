import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:pet_health/core/database/app_database.dart';
import 'package:pet_health/core/database/database_provider.dart';
import 'package:pet_health/features/care/application/care_controller.dart';

void main() {
  late AppDatabase database;
  late ProviderContainer container;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(database)],
    );
  });

  tearDown(() async {
    container.dispose();
    await database.close();
  });

  test('records bath time and place', () async {
    final occurredAt = DateTime.utc(2026, 6, 18);

    await container
        .read(careControllerProvider.notifier)
        .recordBath(occurredAt: occurredAt, place: '暖爪护理店');

    final bath = container.read(careControllerProvider).lastBath;
    expect(bath?.occurredAt, occurredAt);
    expect(bath?.place, '暖爪护理店');
  });

  test('calculates walk duration from start and end timestamps', () async {
    final startedAt = DateTime.utc(2026, 6, 22, 18);
    final endedAt = startedAt.add(const Duration(minutes: 36, seconds: 12));
    final controller = container.read(careControllerProvider.notifier);

    await controller.startWalk(at: startedAt);
    final record = await controller.finishWalk(place: '滨江公园', at: endedAt);

    expect(record?.duration, const Duration(minutes: 36, seconds: 12));
    expect(record?.place, '滨江公园');
    expect(container.read(careControllerProvider).activeWalkStartedAt, isNull);
    expect(container.read(careControllerProvider).lastWalk, same(record));
  });
}
