import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/core/database/app_database.dart';

import 'generated/schema.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late Directory temporaryDirectory;
  late File databaseFile;
  final now = DateTime(2026, 10, 9, 12);

  setUp(() async {
    temporaryDirectory = await Directory.systemTemp.createTemp(
      'pet-health-migration-',
    );
    databaseFile = File('${temporaryDirectory.path}/user.sqlite');
  });

  tearDown(() => temporaryDirectory.delete(recursive: true));

  Future<void> insertPet(AppDatabase database, String id) {
    return database
        .into(database.pets)
        .insert(
          PetsCompanion.insert(
            id: id,
            name: '团子',
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  test('v8 snapshot matches the current schema', () async {
    final verifier = SchemaVerifier(GeneratedHelper());
    final connection = await verifier.startAt(8);
    final database = AppDatabase(connection);
    addTearDown(database.close);

    // 默认不校验多余对象：beforeOpen 额外创建的 SQL 索引不在 drift 表定义里。
    await verifier.migrateAndValidate(database, 8);
  });

  test('reopening a v8 database keeps existing data', () async {
    var database = AppDatabase(NativeDatabase(databaseFile));
    await insertPet(database, 'pet-v8');
    await database.close();

    database = AppDatabase(NativeDatabase(databaseFile));
    addTearDown(database.close);
    final pets = await database.select(database.pets).get();
    expect(pets.map((pet) => pet.id), ['pet-v8']);
  });

  test('recreates a v3 database that previously failed to upgrade', () async {
    // 按 v3 的真实结构构造：没有 v4 之后的表，也没有 v6 / v7 新增的列。
    // 旧迁移在这里会因 details_json 重复添加而失败。
    var database = AppDatabase(NativeDatabase(databaseFile));
    await insertPet(database, 'pet-v3');
    for (final table in [
      'memory_media_refs',
      'memory_entries',
      'reminder_logs',
      'reminders',
      'care_plan_logs',
      'care_plans',
    ]) {
      await database.customStatement('DROP TABLE $table');
    }
    await database.customStatement(
      'ALTER TABLE health_records DROP COLUMN details_json',
    );
    await database.customStatement(
      'ALTER TABLE care_activities DROP COLUMN details_json',
    );
    await database.customStatement('PRAGMA user_version = 3');
    await database.close();

    database = AppDatabase(NativeDatabase(databaseFile));
    addTearDown(database.close);

    expect(await database.select(database.pets).get(), isEmpty);
    await database.validateDatabaseSchema();
    expect(
      (await database.customSelect('PRAGMA user_version').getSingle())
          .read<int>('user_version'),
      8,
    );

    await insertPet(database, 'pet-after-recreate');
    await database
        .into(database.memoryEntries)
        .insert(
          MemoryEntriesCompanion.insert(
            id: 'memory-after-recreate',
            petId: 'pet-after-recreate',
            occurredAt: now,
            createdAt: now,
            updatedAt: now,
          ),
        );
    await (database.delete(
      database.pets,
    )..where((row) => row.id.equals('pet-after-recreate'))).go();
    expect(await database.select(database.memoryEntries).get(), isEmpty);
  });

  for (var version = 1; version < 8; version++) {
    test('recreates an empty v8 schema from v$version', () async {
      var database = AppDatabase(NativeDatabase(databaseFile));
      await insertPet(database, 'pet-v$version');
      await database.customStatement('PRAGMA user_version = $version');
      await database.close();

      database = AppDatabase(NativeDatabase(databaseFile));
      addTearDown(database.close);

      expect(await database.select(database.pets).get(), isEmpty);
      await database.validateDatabaseSchema();
    });
  }
}
