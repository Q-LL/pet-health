import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/care_models.dart';

final careControllerProvider = NotifierProvider<CareController, CareState>(
  CareController.new,
);

final walkElapsedProvider = StreamProvider.autoDispose<Duration>((ref) async* {
  final startedAt = ref.watch(
    careControllerProvider.select((state) => state.activeWalkStartedAt),
  );

  if (startedAt == null) {
    yield Duration.zero;
    return;
  }

  yield DateTime.now().difference(startedAt);
  yield* Stream<Duration>.periodic(
    const Duration(seconds: 1),
    (_) => DateTime.now().difference(startedAt),
  );
});

class CareController extends Notifier<CareState> {
  @override
  CareState build() => const CareState();

  void recordBath({required DateTime occurredAt, required String place}) {
    state = state.copyWith(
      lastBath: BathRecord(occurredAt: occurredAt, place: place.trim()),
    );
  }

  void startWalk({DateTime? at}) {
    if (state.activeWalkStartedAt != null) return;
    state = state.copyWith(activeWalkStartedAt: at ?? DateTime.now());
  }

  WalkRecord? finishWalk({required String place, DateTime? at}) {
    final startedAt = state.activeWalkStartedAt;
    if (startedAt == null) return null;

    final endedAt = at ?? DateTime.now();
    final duration = endedAt.isBefore(startedAt)
        ? Duration.zero
        : endedAt.difference(startedAt);
    final record = WalkRecord(
      startedAt: startedAt,
      endedAt: endedAt,
      duration: duration,
      place: place.trim(),
    );

    state = state.copyWith(
      clearActiveWalk: true,
      walks: [record, ...state.walks],
    );
    return record;
  }
}
