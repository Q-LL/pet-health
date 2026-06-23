import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/core/database/app_database.dart';
import 'package:pet_health/features/care/data/care_repository.dart';
import 'package:pet_health/features/care/domain/care_models.dart';

void main() {
  late AppDatabase database;
  late CareRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = CareRepository(database);
  });

  tearDown(() => database.close());

  test('stores bath records and streams the latest one', () async {
    final petId = await repository.ensureDefaultPet();
    final occurredAt = DateTime.utc(2026, 6, 18);

    await repository.recordBath(
      petId: petId,
      occurredAt: occurredAt,
      place: ' 暖爪护理店 ',
    );

    final state = await repository.watchState(petId).first;
    expect(state.lastBath?.occurredAt, occurredAt);
    expect(state.lastBath?.place, '暖爪护理店');
  });

  test('active walk survives reload and is completed in place', () async {
    final petId = await repository.ensureDefaultPet();
    final startedAt = DateTime.utc(2026, 6, 22, 18);
    final endedAt = startedAt.add(const Duration(minutes: 36, seconds: 12));

    await repository.startWalk(petId: petId, at: startedAt);
    final activeState = await repository.watchState(petId).first;
    expect(activeState.activeWalkStartedAt, startedAt);

    final record = await repository.finishWalk(
      petId: petId,
      place: '滨江公园',
      at: endedAt,
    );
    final completedState = await repository.watchState(petId).first;

    expect(record?.duration, const Duration(minutes: 36, seconds: 12));
    expect(completedState.activeWalkStartedAt, isNull);
    expect(completedState.lastWalk?.place, '滨江公园');
  });

  test('starting twice keeps a single active walk', () async {
    final petId = await repository.ensureDefaultPet();
    final firstStart = DateTime.utc(2026, 6, 22, 18);

    final first = await repository.startWalk(petId: petId, at: firstStart);
    final second = await repository.startWalk(
      petId: petId,
      at: firstStart.add(const Duration(minutes: 5)),
    );

    expect(first, firstStart);
    expect(second, firstStart);
    final rows = await database.select(database.careActivities).get();
    expect(rows, hasLength(1));
  });

  test('creates, reads and updates a general care activity', () async {
    final petId = await repository.ensureDefaultPet();
    final created = await repository.create(
      CareActivityDraft(
        petId: petId,
        type: 'grooming',
        occurredAt: DateTime.utc(2026, 6, 22),
        place: '家里',
        note: '梳毛十分钟',
      ),
    );

    expect((await repository.getById(created.id))?.note, '梳毛十分钟');
    final updated = await repository.update(
      created.id,
      CareActivityDraft(
        petId: petId,
        type: 'grooming',
        occurredAt: created.occurredAt,
        place: '阳台',
        note: '梳毛十五分钟',
      ),
    );

    expect(updated.id, created.id);
    expect(updated.place, '阳台');
    expect(updated.note, '梳毛十五分钟');
  });

  test('searches care activities by keyword, type, time and page', () async {
    final petId = await repository.ensureDefaultPet();
    await repository.create(
      CareActivityDraft(
        petId: petId,
        type: 'paw',
        occurredAt: DateTime.utc(2026, 6, 20),
        place: '玄关',
        note: '雨天清洁足爪',
      ),
    );
    await repository.create(
      CareActivityDraft(
        petId: petId,
        type: 'grooming',
        occurredAt: DateTime.utc(2026, 6, 21),
        place: '客厅',
        note: '日常梳毛',
      ),
    );
    await repository.create(
      CareActivityDraft(
        petId: petId,
        type: 'paw',
        occurredAt: DateTime.utc(2026, 6, 22),
        place: '浴室',
        note: '雨天回家检查',
      ),
    );

    final rainyPaw = await repository.findForPet(
      petId,
      type: 'paw',
      keyword: '雨天',
      from: DateTime.utc(2026, 6, 19),
      to: DateTime.utc(2026, 6, 23),
    );
    final secondPage = await repository.findForPet(petId, limit: 1, offset: 1);

    expect(rainyPaw, hasLength(2));
    expect(secondPage.single.occurredAt, DateTime.utc(2026, 6, 21));
  });

  test('deletes care activity and rejects invalid updates', () async {
    final petId = await repository.ensureDefaultPet();
    final created = await repository.create(
      CareActivityDraft(
        petId: petId,
        type: 'ear',
        occurredAt: DateTime.utc(2026, 6, 22),
        note: '观察耳部',
      ),
    );

    expect(await repository.delete(created.id), isTrue);
    expect(await repository.delete(created.id), isFalse);
    expect(await repository.getById(created.id), isNull);
    expect(
      () => repository.update(
        'missing',
        CareActivityDraft(
          petId: petId,
          type: 'custom',
          occurredAt: DateTime.now(),
        ),
      ),
      throwsStateError,
    );
  });
}
