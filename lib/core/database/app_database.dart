import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class Pets extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get species => text().nullable()();
  TextColumn get breed => text().nullable()();
  TextColumn get sex => text().nullable()();
  DateTimeColumn get birthday => dateTime().nullable()();
  BoolColumn get neutered => boolean().nullable()();
  TextColumn get allergies => text().withDefault(const Constant(''))();
  TextColumn get chronicConditions => text().withDefault(const Constant(''))();
  TextColumn get avatarPath => text().nullable()();
  BoolColumn get isPlaceholder =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@TableIndex(name: 'care_pet_occurred_at', columns: {#petId, #occurredAt})
@TableIndex(name: 'care_pet_type', columns: {#petId, #type})
class CareActivities extends Table {
  TextColumn get id => text()();
  TextColumn get petId =>
      text().references(Pets, #id, onDelete: KeyAction.cascade)();
  TextColumn get type => text()();
  DateTimeColumn get occurredAt => dateTime()();
  DateTimeColumn get startedAt => dateTime().nullable()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  IntColumn get durationSeconds => integer().nullable()();
  TextColumn get place => text().withDefault(const Constant(''))();
  TextColumn get note => text().withDefault(const Constant(''))();
  TextColumn get routeFilePath => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class HealthRecords extends Table {
  TextColumn get id => text()();
  TextColumn get petId =>
      text().references(Pets, #id, onDelete: KeyAction.cascade)();
  TextColumn get type => text()();
  DateTimeColumn get occurredAt => dateTime()();
  TextColumn get title => text()();
  TextColumn get note => text().withDefault(const Constant(''))();
  RealColumn get numericValue => real().nullable()();
  TextColumn get unit => text().nullable()();
  IntColumn get severity => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

class PetPhotos extends Table {
  TextColumn get id => text()();
  TextColumn get petId =>
      text().references(Pets, #id, onDelete: KeyAction.cascade)();
  TextColumn get filePath => text().nullable()();
  BlobColumn get bytes => blob().nullable()();
  TextColumn get originalName => text()();
  TextColumn get mediaType => text()();
  TextColumn get caption => text().withDefault(const Constant(''))();
  DateTimeColumn get capturedAt => dateTime().nullable()();
  BoolColumn get isAvatar => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(
  tables: [Pets, CareActivities, HealthRecords, AppSettings, PetPhotos],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  AppDatabase.defaults()
    : super(
        driftDatabase(
          name: 'user',
          web: DriftWebOptions(
            sqlite3Wasm: Uri.parse('sqlite3.wasm'),
            driftWorker: Uri.parse('drift_worker.js'),
          ),
        ),
      );

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
    },
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.createTable(healthRecords);
        await migrator.createTable(appSettings);
      }
      if (from < 3) {
        await migrator.createTable(petPhotos);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      await customStatement(
        'CREATE UNIQUE INDEX IF NOT EXISTS one_active_walk_per_pet '
        "ON care_activities (pet_id) WHERE type = 'walk' AND ended_at IS NULL",
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS health_pet_occurred_at '
        'ON health_records (pet_id, occurred_at DESC)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS health_pet_type '
        'ON health_records (pet_id, type)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS pet_photos_pet_created '
        'ON pet_photos (pet_id, created_at DESC)',
      );
      await customStatement(
        'CREATE UNIQUE INDEX IF NOT EXISTS one_avatar_per_pet '
        'ON pet_photos (pet_id) WHERE is_avatar = 1',
      );
    },
  );
}
