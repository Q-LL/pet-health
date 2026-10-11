import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../features/cards/domain/card_codes.dart';
import '../../features/entries/domain/entry_codes.dart';
import '../../features/pets/domain/pet_codes.dart';
import '../../features/plans/domain/plan_codes.dart';
import '../../features/plans/domain/plan_schedule.dart';
import '../units/units.dart';
import 'converters.dart';

part 'pet_health_database.g.dart';

// v1 数据库，结构说明见 docs/V1_SCHEMA.md。
//
// 与旧的 AppDatabase（lib/core/database，库名 `user`）并存：旧页面全部替换后，
// 旧数据库连同它的快照与迁移测试一起删除。
//
// 时间点（occurredAt 等）以 UTC 存储；本地日历日期（生日、卡片日期等）存成
// `yyyy-MM-dd` 文本，不受时区影响。

@DataClassName('PetRow')
class Pets extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get sex =>
      text().map(const CodedEnumConverter(PetSex.values)).nullable()();
  BoolColumn get neutered => boolean().nullable()();
  TextColumn get birthDate =>
      text().map(const LocalDateConverter()).nullable()();
  TextColumn get birthPrecision => text()
      .map(const CodedEnumConverter(BirthPrecision.values))
      .withDefault(const Constant('day'))();
  TextColumn get homeDate =>
      text().map(const LocalDateConverter()).nullable()();
  TextColumn get breedCode => text().nullable()();
  TextColumn get breedName => text().nullable()();
  TextColumn get breedGroup => text()
      .map(const CodedEnumConverter(BreedGroup.values))
      .withDefault(const Constant('mixed'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// 每只狗一行的习惯预设。
@DataClassName('PetPresetRow')
class PetPresets extends Table {
  TextColumn get petId =>
      text().references(Pets, #id, onDelete: KeyAction.cascade)();
  RealColumn get mealAmount => real().nullable()();
  TextColumn get mealUnit =>
      text().map(const CodedEnumConverter(PortionUnit.values)).nullable()();
  IntColumn get mealsPerDay => integer().nullable()();

  /// 水碗容量，一律按 ml 存。
  RealColumn get bowlMl => real().nullable()();
  TextColumn get weightCadence => text()
      .map(const CodedEnumConverter(WeightCadence.values))
      .withDefault(const Constant('monthly'))();

  /// 首页一键记录的类型与顺序。
  TextColumn get quickTypes => text()
      .map(const CodedEnumListConverter(EntryType.values))
      .withDefault(const Constant('["meal","water","potty","brushing"]'))();

  @override
  Set<Column<Object>> get primaryKey => {petId};
}

@DataClassName('EntryRow')
@TableIndex(name: 'entries_pet_occurred', columns: {#petId, #occurredAt})
@TableIndex(
  name: 'entries_pet_type_occurred',
  columns: {#petId, #type, #occurredAt},
)
@TableIndex(name: 'entries_plan', columns: {#planId})
@TableIndex.sql(
  'CREATE UNIQUE INDEX one_active_walk_per_pet ON entries (pet_id) '
  "WHERE type = 'walk' AND ended_at IS NULL",
)
class Entries extends Table {
  TextColumn get id => text()();
  TextColumn get petId =>
      text().references(Pets, #id, onDelete: KeyAction.cascade)();
  TextColumn get type =>
      text().map(const CodedEnumConverter(EntryType.values))();
  DateTimeColumn get occurredAt => dateTime()();

  /// 完成了哪个计划；计划删除后记录保留，只是不再关联。
  TextColumn get planId =>
      text().nullable().references(Plans, #id, onDelete: KeyAction.setNull)();

  /// 能换算的量按标准单位存（体重 kg、饮水 ml），此时 [unit] 为空；
  /// 饮食和用药按用户选的单位原样存。
  RealColumn get amount => real().nullable()();
  TextColumn get unit =>
      text().map(const CodedEnumConverter(PortionUnit.values)).nullable()();

  DateTimeColumn get startedAt => dateTime().nullable()();

  /// 遛狗为空表示正在进行。
  DateTimeColumn get endedAt => dateTime().nullable()();
  IntColumn get durationSec => integer().nullable()();
  RealColumn get distanceM => real().nullable()();

  /// 只存 code，见 EntryDetails。
  TextColumn get details =>
      text().map(const JsonMapConverter()).withDefault(const Constant('{}'))();

  /// 用户填写的名称：药品、疫苗、自定义事项。引擎不读取。
  TextColumn get label => text().nullable()();

  /// 用户写的备注。引擎不读取。
  TextColumn get note => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// 计划，同时承担提醒。
@DataClassName('PlanRow')
@TableIndex(name: 'plans_pet', columns: {#petId})
class Plans extends Table {
  TextColumn get id => text()();
  TextColumn get petId =>
      text().references(Pets, #id, onDelete: KeyAction.cascade)();
  TextColumn get entryType =>
      text().map(const CodedEnumConverter(EntryType.values))();

  /// 细分到具体项，比如 other_care 下的 nails。
  TextColumn get entryKind => text().nullable()();

  /// 只有 custom 计划才填；内置类型的名称来自翻译文件。
  TextColumn get title => text().nullable()();
  TextColumn get schedule =>
      text().map(const CodedEnumConverter(PlanScheduleKind.values))();
  IntColumn get intervalDays => integer().nullable()();

  /// 星期几位掩码，见 Weekdays。
  IntColumn get weekdays => integer().nullable()();

  /// 一次性事项的时间。
  DateTimeColumn get dueAt => dateTime().nullable()();

  /// 当天几点提醒，按距离零点的分钟数存；为空表示不发通知。
  IntColumn get notifyMinute => integer().nullable()();
  DateTimeColumn get snoozedUntil => dateTime().nullable()();
  IntColumn get notificationId => integer().nullable()();
  TextColumn get source => text()
      .map(const CodedEnumConverter(PlanSource.values))
      .withDefault(const Constant('user'))();
  BoolColumn get paused => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    // SQLite 的 CHECK 只在结果为假时拒绝，NULL 会放行，所以要显式写 IS NOT NULL。
    "CHECK (schedule <> 'every_n_days' OR "
        '(interval_days IS NOT NULL AND interval_days > 0))',
    "CHECK (schedule <> 'weekdays' OR "
        '(weekdays IS NOT NULL AND weekdays BETWEEN 1 AND 127))',
    "CHECK (schedule <> 'once' OR due_at IS NOT NULL)",
    'CHECK (notify_minute IS NULL OR notify_minute BETWEEN 0 AND 1439)',
  ];
}

/// 每天出过哪些卡片：同一天内保持不变，贴士在冷却期内不重复。
@DataClassName('CardHistoryRow')
@TableIndex(
  name: 'card_history_pet_day_key',
  columns: {#petId, #day, #cardKey},
  unique: true,
)
class CardHistory extends Table {
  TextColumn get id => text()();
  TextColumn get petId =>
      text().references(Pets, #id, onDelete: KeyAction.cascade)();
  TextColumn get day => text().map(const LocalDateConverter())();
  TextColumn get cardKey => text()();
  TextColumn get category =>
      text().map(const CodedEnumConverter(CardCategory.values))();
  TextColumn get params =>
      text().map(const JsonMapConverter()).withDefault(const Constant('{}'))();
  BoolColumn get dismissed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// 天气预报缓存；更换城市时清空。温度一律按 °C 存。
@DataClassName('WeatherDayRow')
class WeatherDays extends Table {
  TextColumn get day => text().map(const LocalDateConverter())();
  RealColumn get maxC => real()();
  RealColumn get minC => real()();
  IntColumn get precipProb => integer()();
  RealColumn get uvMax => real()();
  DateTimeColumn get fetchedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {day};
}

@DataClassName('SettingRow')
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

// 以下三张表沿用旧版结构。

@DataClassName('PetPhotoRow')
@TableIndex(name: 'pet_photos_pet_created', columns: {#petId, #createdAt})
@TableIndex.sql(
  'CREATE UNIQUE INDEX one_avatar_per_pet ON pet_photos (pet_id) '
  'WHERE is_avatar = 1',
)
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

@DataClassName('MemoryEntryRow')
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

@DataClassName('MemoryMediaRefRow')
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

@DriftDatabase(
  tables: [
    Pets,
    PetPresets,
    Entries,
    Plans,
    CardHistory,
    WeatherDays,
    AppSettings,
    PetPhotos,
    MemoryEntries,
    MemoryMediaRefs,
  ],
)
class PetHealthDatabase extends _$PetHealthDatabase {
  PetHealthDatabase(super.executor);

  PetHealthDatabase.defaults()
    : super(
        driftDatabase(
          name: 'pet_health',
          web: DriftWebOptions(
            sqlite3Wasm: Uri.parse('sqlite3.wasm'),
            driftWorker: Uri.parse('drift_worker.js'),
          ),
        ),
      );

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    // 之后每次修改表结构：先提升 schemaVersion，再运行
    // `dart run drift_dev make-migrations` 生成快照与逐版本升级步骤，
    // 在这里通过 stepByStep 接入，并补充迁移测试。
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
