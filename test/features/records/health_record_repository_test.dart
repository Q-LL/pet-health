import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/core/database/app_database.dart';
import 'package:pet_health/features/pets/data/pet_repository.dart';
import 'package:pet_health/features/pets/domain/pet_profile.dart';
import 'package:pet_health/features/records/data/health_record_repository.dart';
import 'package:pet_health/features/records/domain/health_record.dart';

void main() {
  late AppDatabase database;
  late PetRepository pets;
  late HealthRecordRepository records;
  late String petId;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    pets = PetRepository(database);
    records = HealthRecordRepository(database);
    petId = (await pets.savePet(const PetDraft(name: '团子'))).id;
  });

  tearDown(() => database.close());

  test('creates, updates and filters health records', () async {
    final weight = await records.create(
      HealthRecordDraft(
        petId: petId,
        type: 'weight',
        occurredAt: DateTime.utc(2026, 6, 22),
        title: '体重',
        numericValue: 4.8,
        unit: 'kg',
      ),
    );
    await records.save(
      HealthRecordDraft(
        petId: petId,
        type: 'symptom',
        occurredAt: DateTime.utc(2026, 6, 23),
        title: '偶尔打喷嚏',
        severity: 2,
      ),
    );

    final weights = await records.watchForPet(petId, type: 'weight').first;
    expect(weights, hasLength(1));
    expect(weights.single.numericValue, 4.8);

    final updated = await records.update(
      weight.id,
      HealthRecordDraft(
        petId: petId,
        type: 'weight',
        occurredAt: weight.occurredAt,
        title: '晨间体重',
        numericValue: 4.9,
        unit: 'kg',
      ),
    );
    expect(updated.id, weight.id);
    expect(updated.numericValue, 4.9);
  });

  test('persists structured details for typed records', () async {
    final food = await records.create(
      HealthRecordDraft(
        petId: petId,
        type: 'food',
        occurredAt: DateTime.utc(2026, 6, 24, 8),
        title: '早餐',
        numericValue: 80,
        unit: 'g',
        details: const {'foodName': '低敏犬粮', 'meal': '早餐', 'appetite': '正常吃完'},
      ),
    );

    final found = await records.getById(food.id);

    expect(found?.numericValue, 80);
    expect(found?.unit, 'g');
    expect(found?.details['foodName'], '低敏犬粮');
    expect(found?.details['appetite'], '正常吃完');
  });

  test('searches by keyword and supports pagination', () async {
    for (var index = 0; index < 3; index++) {
      await records.create(
        HealthRecordDraft(
          petId: petId,
          type: 'custom',
          occurredAt: DateTime.utc(2026, 6, 20 + index),
          title: index == 1 ? '夜间观察' : '日常记录 $index',
          note: index == 2 ? '夜间喝水正常' : '',
        ),
      );
    }

    final search = await records.findForPet(petId, keyword: '夜间');
    final secondPage = await records.findForPet(petId, limit: 1, offset: 1);

    expect(search, hasLength(2));
    expect(secondPage, hasLength(1));
    expect(secondPage.single.occurredAt, DateTime.utc(2026, 6, 21));
  });

  test('gets and deletes a record by id', () async {
    final created = await records.create(
      HealthRecordDraft(
        petId: petId,
        type: 'symptom',
        occurredAt: DateTime.utc(2026, 6, 23),
        title: '打喷嚏',
      ),
    );

    expect((await records.getById(created.id))?.title, '打喷嚏');
    expect(await records.delete(created.id), isTrue);
    expect(await records.delete(created.id), isFalse);
    expect(await records.getById(created.id), isNull);
  });

  test('update rejects a missing record', () async {
    expect(
      () => records.update(
        'missing',
        HealthRecordDraft(
          petId: petId,
          type: 'custom',
          occurredAt: DateTime.now(),
          title: '不存在',
        ),
      ),
      throwsStateError,
    );
  });

  test('validates record type, weight value and severity', () async {
    expect(
      () => records.save(
        HealthRecordDraft(
          petId: petId,
          type: 'unknown',
          occurredAt: DateTime.now(),
          title: '未知记录',
        ),
      ),
      throwsFormatException,
    );
    expect(
      () => records.save(
        HealthRecordDraft(
          petId: petId,
          type: 'weight',
          occurredAt: DateTime.now(),
          title: '体重',
        ),
      ),
      throwsFormatException,
    );
  });

  test('count returns total and respects filters', () async {
    await records.create(
      HealthRecordDraft(
        petId: petId,
        type: 'weight',
        occurredAt: DateTime.utc(2026, 6, 20),
        title: '体重',
        numericValue: 4.5,
        unit: 'kg',
      ),
    );
    await records.create(
      HealthRecordDraft(
        petId: petId,
        type: 'symptom',
        occurredAt: DateTime.utc(2026, 6, 22),
        title: '打喷嚏',
        note: '夜间观察',
      ),
    );
    await records.create(
      HealthRecordDraft(
        petId: petId,
        type: 'weight',
        occurredAt: DateTime.utc(2026, 6, 23),
        title: '体重',
        numericValue: 4.8,
        unit: 'kg',
      ),
    );

    expect(await records.count(petId), 3);
    expect(await records.count(petId, type: 'weight'), 2);
    expect(await records.count(petId, keyword: '夜间'), 1);
    expect(
      await records.count(
        petId,
        from: DateTime.utc(2026, 6, 21),
        to: DateTime.utc(2026, 6, 24),
      ),
      2,
    );
  });

  test('pet deletion cascades to its health records', () async {
    await records.save(
      HealthRecordDraft(
        petId: petId,
        type: 'custom',
        occurredAt: DateTime.now(),
        title: '备注',
      ),
    );

    await pets.deletePet(petId);

    expect(await records.watchForPet(petId).first, isEmpty);
  });
}
