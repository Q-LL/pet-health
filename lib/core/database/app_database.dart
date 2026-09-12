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
  TextColumn get detailsJson => text().withDefault(const Constant('{}'))();
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
  TextColumn get detailsJson => text().withDefault(const Constant('{}'))();
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

@TableIndex(name: 'memory_entries_pet_occurred', columns: {#petId, #occurredAt})
class MemoryEntries extends Table {
  TextColumn get id => text()();
  TextColumn get petId =>
      text().references(Pets, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get occurredAt => dateTime()();
  TextColumn get note => text().withDefault(const Constant(''))();
  TextColumn get moodEmoji => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@TableIndex(name: 'memory_media_entry_position', columns: {#entryId, #position})
class MemoryMediaRefs extends Table {
  TextColumn get id => text()();
  TextColumn get entryId =>
      text().references(MemoryEntries, #id, onDelete: KeyAction.cascade)();
  TextColumn get kind => text()();
  TextColumn get platformRef => text()();
  IntColumn get position => integer()();
  IntColumn get width => integer().nullable()();
  IntColumn get height => integer().nullable()();
  IntColumn get durationMs => integer().nullable()();
  DateTimeColumn get capturedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@TableIndex(
  name: 'care_plans_pet_candidate_unique',
  columns: {#petId, #candidateId},
  unique: true,
)
class CarePlans extends Table {
  TextColumn get id => text()();
  TextColumn get petId =>
      text().references(Pets, #id, onDelete: KeyAction.cascade)();
  TextColumn get candidateId => text()();
  TextColumn get careType => text()();
  TextColumn get title => text()();
  TextColumn get scheduleRule => text()();
  DateTimeColumn get nextDueAt => dateTime().nullable()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  BoolColumn get paused => boolean().withDefault(const Constant(false))();
  TextColumn get reasonSnapshot => text().withDefault(const Constant(''))();
  TextColumn get ruleId => text().nullable()();
  TextColumn get ruleVersion => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class CarePlanLogs extends Table {
  TextColumn get id => text()();
  TextColumn get planId =>
      text().references(CarePlans, #id, onDelete: KeyAction.cascade)();
  TextColumn get petId =>
      text().references(Pets, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get occurredAt => dateTime()();
  TextColumn get action => text()();
  TextColumn get note => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Reminders extends Table {
  TextColumn get id => text()();
  TextColumn get petId =>
      text().references(Pets, #id, onDelete: KeyAction.cascade)();
  TextColumn get sourceType => text()();
  TextColumn get sourceId => text().nullable()();
  TextColumn get title => text()();
  DateTimeColumn get scheduledAt => dateTime()();
  TextColumn get repeatRule => text().nullable()();
  IntColumn get notificationId => integer().nullable()();
  TextColumn get completionMode => text().withDefault(const Constant('none'))();
  TextColumn get completionTarget =>
      text().withDefault(const Constant('health'))();
  TextColumn get recordType => text().nullable()();
  TextColumn get recordTitle => text().nullable()();
  RealColumn get recordNumericValue => real().nullable()();
  TextColumn get recordUnit => text().nullable()();
  TextColumn get recordNote => text().withDefault(const Constant(''))();
  TextColumn get recordDetailsJson =>
      text().withDefault(const Constant('{}'))();
  TextColumn get careType => text().nullable()();
  TextColumn get carePlace => text().withDefault(const Constant(''))();
  TextColumn get careNote => text().withDefault(const Constant(''))();
  TextColumn get careDetailsJson => text().withDefault(const Constant('{}'))();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  BoolColumn get paused => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ReminderLogs extends Table {
  TextColumn get id => text()();
  TextColumn get reminderId =>
      text().references(Reminders, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get occurredAt => dateTime()();
  TextColumn get action => text()();
  TextColumn get result => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    Pets,
    CareActivities,
    HealthRecords,
    AppSettings,
    PetPhotos,
    MemoryEntries,
    MemoryMediaRefs,
    CarePlans,
    CarePlanLogs,
    Reminders,
    ReminderLogs,
  ],
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
  int get schemaVersion => 8;

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
      if (from < 4) {
        await migrator.createTable(carePlans);
        await migrator.createTable(carePlanLogs);
        await migrator.createTable(reminders);
        await migrator.createTable(reminderLogs);
      }
      if (from < 5) {
        await _deduplicateCarePlans();
        await customStatement(
          'CREATE UNIQUE INDEX IF NOT EXISTS care_plans_pet_candidate_unique '
          'ON care_plans (pet_id, candidate_id)',
        );
      }
      if (from < 6) {
        await migrator.addColumn(healthRecords, healthRecords.detailsJson);
        await migrator.addColumn(reminders, reminders.completionMode);
        await migrator.addColumn(reminders, reminders.recordType);
        await migrator.addColumn(reminders, reminders.recordTitle);
        await migrator.addColumn(reminders, reminders.recordNumericValue);
        await migrator.addColumn(reminders, reminders.recordUnit);
        await migrator.addColumn(reminders, reminders.recordNote);
        await migrator.addColumn(reminders, reminders.recordDetailsJson);
      }
      if (from < 7) {
        await migrator.addColumn(careActivities, careActivities.detailsJson);
        await migrator.addColumn(reminders, reminders.completionTarget);
        await migrator.addColumn(reminders, reminders.careType);
        await migrator.addColumn(reminders, reminders.carePlace);
        await migrator.addColumn(reminders, reminders.careNote);
        await migrator.addColumn(reminders, reminders.careDetailsJson);
      }
      if (from < 8) {
        await migrator.createTable(memoryEntries);
        await migrator.createTable(memoryMediaRefs);
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
      await customStatement(
        'CREATE INDEX IF NOT EXISTS memory_entries_pet_occurred '
        'ON memory_entries (pet_id, occurred_at DESC)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS memory_media_entry_position '
        'ON memory_media_refs (entry_id, position)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS care_plans_pet_enabled '
        'ON care_plans (pet_id, enabled)',
      );
      await _deduplicateCarePlans();
      await customStatement(
        'CREATE UNIQUE INDEX IF NOT EXISTS care_plans_pet_candidate_unique '
        'ON care_plans (pet_id, candidate_id)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS care_plan_logs_plan_occurred '
        'ON care_plan_logs (plan_id, occurred_at DESC)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS reminders_pet_enabled '
        'ON reminders (pet_id, enabled)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS reminders_scheduled '
        'ON reminders (scheduled_at)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS reminder_logs_reminder_occurred '
        'ON reminder_logs (reminder_id, occurred_at DESC)',
      );
    },
  );

  Future<void> _deduplicateCarePlans() async {
    await customStatement('''
DELETE FROM care_plans
WHERE id NOT IN (
  SELECT id
  FROM (
    SELECT
      id,
      ROW_NUMBER() OVER (
        PARTITION BY pet_id, candidate_id
        ORDER BY enabled DESC, updated_at DESC, created_at DESC
      ) AS row_number
    FROM care_plans
  )
  WHERE row_number = 1
)
''');
  }
}
