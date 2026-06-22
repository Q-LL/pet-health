import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/features/care/application/care_plan_controller.dart';

void main() {
  test('care suggestions are opt-in and retain the chosen schedule', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final candidate = container.read(carePlanCandidatesProvider).first;
    final controller = container.read(carePlanControllerProvider.notifier);

    expect(container.read(carePlanControllerProvider).enabledPlans, isEmpty);

    controller.enable(candidate, '每周 3 次');

    final enabled = container
        .read(carePlanControllerProvider)
        .enabledPlans[candidate.id];
    expect(enabled?.schedule, '每周 3 次');

    controller.disable(candidate.id);
    expect(container.read(carePlanControllerProvider).enabledPlans, isEmpty);
  });

  test('dismissed suggestions no longer appear as pending', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final candidate = container.read(carePlanCandidatesProvider)[1];

    container.read(carePlanControllerProvider.notifier).dismiss(candidate.id);

    expect(
      container
          .read(carePlanControllerProvider)
          .dismissedCandidateIds
          .contains(candidate.id),
      isTrue,
    );
  });
}
