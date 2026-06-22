import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/features/care/application/care_controller.dart';

void main() {
  test('records bath time and place', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final occurredAt = DateTime(2026, 6, 18);

    container
        .read(careControllerProvider.notifier)
        .recordBath(occurredAt: occurredAt, place: '暖爪宠物店');

    final bath = container.read(careControllerProvider).lastBath;
    expect(bath?.occurredAt, occurredAt);
    expect(bath?.place, '暖爪宠物店');
  });

  test('calculates walk duration from start and end timestamps', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final startedAt = DateTime(2026, 6, 22, 18);
    final endedAt = startedAt.add(const Duration(minutes: 36, seconds: 12));
    final controller = container.read(careControllerProvider.notifier);

    controller.startWalk(at: startedAt);
    final record = controller.finishWalk(place: '滨江公园', at: endedAt);

    expect(record?.duration, const Duration(minutes: 36, seconds: 12));
    expect(record?.place, '滨江公园');
    expect(container.read(careControllerProvider).activeWalkStartedAt, isNull);
    expect(container.read(careControllerProvider).lastWalk, same(record));
  });
}
