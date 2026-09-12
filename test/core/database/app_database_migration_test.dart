import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/core/database/app_database.dart';

void main() {
  test('migrates a v7 database to v8 without losing existing pets', () async {
    final temporaryDirectory = await Directory.systemTemp.createTemp(
      'pet-health-v7-v8-',
    );
    addTearDown(() => temporaryDirectory.delete(recursive: true));
    final databaseFile = File('${temporaryDirectory.path}/user.sqlite');
    final now = DateTime(2026, 7, 20, 12);

    var database = AppDatabase(NativeDatabase(databaseFile));
    await database
        .into(database.pets)
        .insert(
          PetsCompanion.insert(
            id: 'pet-before-migration',
            name: '团子',
            createdAt: now,
            updatedAt: now,
          ),
        );

    // Build a faithful v7 boundary from the current schema: v7 had every
    // existing table except the two memory tables introduced by v8.
    await database.customStatement('DROP TABLE memory_media_refs');
    await database.customStatement('DROP TABLE memory_entries');
    await database.customStatement('PRAGMA user_version = 7');
    await database.close();

    database = AppDatabase(NativeDatabase(databaseFile));
    addTearDown(database.close);

    final pet = await (database.select(
      database.pets,
    )..where((row) => row.id.equals('pet-before-migration'))).getSingle();
    expect(pet.name, '团子');

    final schemaObjects = await database
        .customSelect(
          "SELECT name FROM sqlite_master "
          "WHERE name IN (?, ?, ?, ?) ORDER BY name",
          variables: [
            const Variable('memory_entries'),
            const Variable('memory_entries_pet_occurred'),
            const Variable('memory_media_entry_position'),
            const Variable('memory_media_refs'),
          ],
        )
        .get();
    expect(schemaObjects.map((row) => row.read<String>('name')).toSet(), {
      'memory_entries',
      'memory_entries_pet_occurred',
      'memory_media_entry_position',
      'memory_media_refs',
    });

    await database
        .into(database.memoryEntries)
        .insert(
          MemoryEntriesCompanion.insert(
            id: 'memory-after-migration',
            petId: pet.id,
            occurredAt: now,
            note: const Value('迁移后仍可记录'),
            moodEmoji: const Value('🥰'),
            createdAt: now,
            updatedAt: now,
          ),
        );
    await database
        .into(database.memoryMediaRefs)
        .insert(
          MemoryMediaRefsCompanion.insert(
            id: 'media-after-migration',
            entryId: 'memory-after-migration',
            kind: 'image',
            platformRef: 'local-reference',
            position: 0,
          ),
        );

    await (database.delete(
      database.pets,
    )..where((row) => row.id.equals(pet.id))).go();
    expect(await database.select(database.memoryEntries).get(), isEmpty);
    expect(await database.select(database.memoryMediaRefs).get(), isEmpty);
  });
}
