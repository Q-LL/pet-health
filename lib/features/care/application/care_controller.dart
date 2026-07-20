import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/notifications/notification_service.dart';
import '../data/care_repository.dart';
import '../domain/care_models.dart';
import '../../pets/data/pet_repository.dart';

final careControllerProvider = NotifierProvider<CareController, CareState>(
  CareController.new,
);

final persistedCareStateProvider = StreamProvider<CareState>((ref) async* {
  final repository = ref.watch(careRepositoryProvider);
  final petId = ref.watch(selectedPetIdProvider).value;
  if (petId == null) {
    yield const CareState();
    return;
  }
  yield* repository.watchState(petId);
});

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
  CareState build() {
    return ref.watch(persistedCareStateProvider).value ?? const CareState();
  }

  Future<void> recordBath({
    required DateTime occurredAt,
    required String place,
  }) async {
    final repository = ref.read(careRepositoryProvider);
    final petId = await ref
        .read(petRepositoryProvider)
        .requireSelectedRealPetId();
    final record = await repository.recordBath(
      petId: petId,
      occurredAt: occurredAt,
      place: place,
    );
    state = state.copyWith(lastBath: record);
  }

  Future<void> startWalk({DateTime? at}) async {
    if (state.activeWalkStartedAt != null) return;
    final repository = ref.read(careRepositoryProvider);
    final petId = await ref
        .read(petRepositoryProvider)
        .requireSelectedRealPetId();
    final startedAt = await repository.startWalk(petId: petId, at: at);
    state = state.copyWith(activeWalkStartedAt: startedAt);
    await notificationService.showWalkTimer(startedAt: startedAt);
  }

  Future<WalkRecord?> finishWalk({
    DateTime? at,
    DateTime? expectedStartedAt,
  }) async {
    final repository = ref.read(careRepositoryProvider);
    final petId = await ref
        .read(petRepositoryProvider)
        .requireSelectedRealPetId();
    final record = await repository.finishWalk(
      petId: petId,
      place: '',
      at: at,
      expectedStartedAt: expectedStartedAt,
    );
    if (record == null) return null;

    state = state.copyWith(
      clearActiveWalk: true,
      walks: [record, ...state.walks],
    );
    await notificationService.cancelWalkTimer();
    return record;
  }

  Future<WalkRecord> updateWalkDetails(
    WalkRecord record, {
    required String place,
    String note = '',
  }) async {
    await ref.read(petRepositoryProvider).requireSelectedRealPetId();
    final updated = await ref
        .read(careRepositoryProvider)
        .updateWalkDetails(id: record.id, place: place, note: note);
    state = state.copyWith(
      walks: [
        for (final walk in state.walks)
          if (walk.id == updated.id) updated else walk,
      ],
    );
    return updated;
  }
}
