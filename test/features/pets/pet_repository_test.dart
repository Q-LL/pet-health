import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/core/database/app_database.dart';
import 'package:pet_health/features/care/data/care_repository.dart';
import 'package:pet_health/features/pets/data/pet_repository.dart';
import 'package:pet_health/features/pets/domain/pet_profile.dart';

void main() {
  late AppDatabase database;
  late PetRepository pets;
  late CareRepository care;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    pets = PetRepository(database);
    care = CareRepository(database);
  });

  tearDown(() => database.close());

  test(
    'first real pet upgrades placeholder and keeps existing care data',
    () async {
      final placeholderId = await pets.ensureSelectedPetId();
      await care.recordBath(
        petId: placeholderId,
        occurredAt: DateTime.utc(2026, 6, 20),
        place: '家里',
      );

      final pet = await pets.savePet(
        const PetDraft(name: '团子', species: '小型犬', breed: '贵宾犬'),
      );
      final careState = await care.watchState(pet.id).first;

      expect(pet.id, placeholderId);
      expect(pet.isPlaceholder, isFalse);
      expect(pet.name, '团子');
      expect(careState.lastBath?.place, '家里');
    },
  );

  test('supports multiple pets and persists current selection', () async {
    final first = await pets.savePet(const PetDraft(name: '团子'));
    final second = await pets.savePet(const PetDraft(name: '旺财'));

    expect(await pets.watchSelectedPetId().first, second.id);
    await pets.selectPet(first.id);
    expect(await pets.watchSelectedPetId().first, first.id);
    expect(await pets.watchPets().first, hasLength(2));
  });

  test('deleting selected pet selects a remaining local pet', () async {
    final first = await pets.savePet(const PetDraft(name: '团子'));
    final second = await pets.savePet(const PetDraft(name: '旺财'));

    await pets.deletePet(second.id);

    expect(await pets.watchSelectedPetId().first, first.id);
    expect((await pets.watchPets().first).map((pet) => pet.name), ['团子']);
  });

  test('supports explicit CRUD, keyword search and pagination', () async {
    final first = await pets.create(
      const PetDraft(name: '团子', species: '小型犬', breed: '贵宾犬'),
    );
    await pets.create(
      const PetDraft(name: '旺财', species: '大型犬', chronicConditions: '关注关节'),
    );

    final updated = await pets.update(
      first.id,
      const PetDraft(name: '团团', species: '小型犬', breed: '贵宾犬'),
    );
    final smallDogs = await pets.findPets(species: '小型犬');
    final joint = await pets.findPets(keyword: '关节');
    final page = await pets.findPets(limit: 1, offset: 1);

    expect(updated.name, '团团');
    expect((await pets.getById(first.id))?.name, '团团');
    expect(smallDogs.single.name, '团团');
    expect(joint.single.name, '旺财');
    expect(page, hasLength(1));
    expect(await pets.delete(first.id), isTrue);
    expect(await pets.delete(first.id), isFalse);
  });

  test('count returns total and respects filters', () async {
    await pets.create(const PetDraft(name: '团子', species: '小型犬', breed: '贵宾犬'));
    await pets.create(
      const PetDraft(name: '旺财', species: '大型犬', chronicConditions: '关节'),
    );
    await pets.create(const PetDraft(name: '豆豆', species: '中型犬'));

    expect(await pets.count(), 3);
    expect(await pets.count(species: '小型犬'), 1);
    expect(await pets.count(keyword: '关节'), 1);
    expect(await pets.count(species: '中型犬'), 1);
  });

  test('update rejects a missing pet', () async {
    expect(
      () => pets.update('missing', const PetDraft(name: '不存在')),
      throwsStateError,
    );
  });
}
