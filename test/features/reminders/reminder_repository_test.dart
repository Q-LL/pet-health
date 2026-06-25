import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/core/database/app_database.dart';
import 'package:pet_health/core/database/database_provider.dart';
import 'package:pet_health/features/care/data/care_repository.dart';
import 'package:pet_health/features/reminders/data/reminder_repository.dart';
import 'package:pet_health/features/reminders/domain/reminder_models.dart';

void main() {
  late AppDatabase database;
  late ProviderContainer container;
  late ReminderRepository repository;
  late String petId;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(database)],
    );
    addTearDown(container.dispose);
    addTearDown(database.close);

    repository = container.read(reminderRepositoryProvider);
    petId = await CareRepository(database).ensureDefaultPet();
  });

  test('creates and reads a reminder', () async {
    final reminder = await repository.create(
      ReminderDraft(
        petId: petId,
        sourceType: 'manual',
        title: '下午遛狗',
        scheduledAt: DateTime.utc(2026, 6, 24, 14),
      ),
    );

    expect(reminder.title, '下午遛狗');
    expect(reminder.enabled, isTrue);
    expect(reminder.sourceType, 'manual');

    final found = await repository.getById(reminder.id);
    expect(found?.id, reminder.id);
  });

  test('updates a reminder', () async {
    final reminder = await repository.create(
      ReminderDraft(
        petId: petId,
        sourceType: 'manual',
        title: '原始标题',
        scheduledAt: DateTime.utc(2026, 6, 24, 14),
      ),
    );

    final updated = await repository.update(
      reminder.id,
      ReminderDraft(
        petId: petId,
        sourceType: 'manual',
        title: '新标题',
        scheduledAt: DateTime.utc(2026, 6, 25, 10),
        repeatRule: 'daily',
      ),
    );

    expect(updated.title, '新标题');
    expect(updated.repeatRule, 'daily');
  });

  test('persists completion record template', () async {
    final reminder = await repository.create(
      ReminderDraft(
        petId: petId,
        sourceType: 'food',
        title: '早餐喂食',
        scheduledAt: DateTime.utc(2026, 6, 24, 8),
        repeatRule: 'daily',
        completionMode: 'auto_record',
        recordType: 'food',
        recordTitle: '早餐',
        recordNumericValue: 80,
        recordUnit: 'g',
        recordDetails: const {'foodName': '低敏犬粮', 'meal': '早餐'},
      ),
    );

    final found = await repository.getById(reminder.id);

    expect(found?.completionMode, 'auto_record');
    expect(found?.recordType, 'food');
    expect(found?.recordNumericValue, 80);
    expect(found?.recordDetails['foodName'], '低敏犬粮');
  });

  test('persists care completion template', () async {
    final reminder = await repository.create(
      ReminderDraft(
        petId: petId,
        sourceType: 'paw',
        title: '雨后擦爪',
        scheduledAt: DateTime.utc(2026, 6, 24, 20),
        completionMode: 'auto_record',
        completionTarget: 'care',
        careType: 'paw',
        carePlace: '玄关',
        careDetails: const {'action': '擦爪', 'status': '未见异常'},
      ),
    );

    final found = await repository.getById(reminder.id);

    expect(found?.completionTarget, 'care');
    expect(found?.careType, 'paw');
    expect(found?.carePlace, '玄关');
    expect(found?.careDetails['action'], '擦爪');
  });

  test('weekly day repeat rule preserves chosen weekdays', () {
    final rule = ReminderRepeatRule.parse('weekly_days:1,3,5');

    expect(rule?.format(), 'weekly_days:1,3,5');
    expect(
      rule?.nextOccurrence(DateTime.utc(2026, 6, 22, 8)),
      DateTime.utc(2026, 6, 24, 8),
    );
  });

  test('enable/disable/pause/resume transitions', () async {
    final reminder = await repository.create(
      ReminderDraft(
        petId: petId,
        sourceType: 'care_plan',
        title: '口腔护理提醒',
        scheduledAt: DateTime.utc(2026, 6, 24, 9),
      ),
    );

    await repository.pause(reminder.id);
    expect((await repository.getById(reminder.id))?.paused, isTrue);

    await repository.resume(reminder.id);
    expect((await repository.getById(reminder.id))?.paused, isFalse);

    await repository.disable(reminder.id);
    expect((await repository.getById(reminder.id))?.enabled, isFalse);

    await repository.enable(reminder.id);
    expect((await repository.getById(reminder.id))?.enabled, isTrue);
  });

  test('delete removes reminder', () async {
    final reminder = await repository.create(
      ReminderDraft(
        petId: petId,
        sourceType: 'manual',
        title: '临时提醒',
        scheduledAt: DateTime.utc(2026, 6, 24),
      ),
    );

    expect(await repository.delete(reminder.id), isTrue);
    expect(await repository.delete(reminder.id), isFalse);
    expect(await repository.getById(reminder.id), isNull);
  });

  test('count respects filters', () async {
    await repository.create(
      ReminderDraft(
        petId: petId,
        sourceType: 'manual',
        title: '手动提醒 1',
        scheduledAt: DateTime.utc(2026, 6, 24),
      ),
    );
    await repository.create(
      ReminderDraft(
        petId: petId,
        sourceType: 'care_plan',
        title: '计划提醒',
        scheduledAt: DateTime.utc(2026, 6, 25),
      ),
    );
    await repository.create(
      ReminderDraft(
        petId: petId,
        sourceType: 'manual',
        title: '手动提醒 2',
        scheduledAt: DateTime.utc(2026, 6, 26),
      ),
    );

    expect(await repository.count(petId), 3);
    expect(await repository.count(petId, sourceType: 'manual'), 2);
    expect(await repository.count(petId, sourceType: 'care_plan'), 1);
  });

  test('log actions are persisted', () async {
    final reminder = await repository.create(
      ReminderDraft(
        petId: petId,
        sourceType: 'manual',
        title: '吃药提醒',
        scheduledAt: DateTime.utc(2026, 6, 24, 8),
      ),
    );

    final firedLog = await repository.logAction(reminder.id, 'fired');
    expect(firedLog.action, 'fired');

    final completedLog = await repository.logAction(
      reminder.id,
      'completed',
      result: '已完成',
    );
    expect(completedLog.action, 'completed');
    expect(completedLog.result, '已完成');

    final logs = await repository.findLogs(reminder.id);
    expect(logs, hasLength(2));
  });

  test('today reminders use local day boundaries', () async {
    final now = DateTime.now();
    final earlyToday = DateTime(now.year, now.month, now.day, 1);
    final reminder = await repository.create(
      ReminderDraft(
        petId: petId,
        sourceType: 'manual',
        title: '凌晨提醒',
        scheduledAt: earlyToday,
      ),
    );
    await repository.create(
      ReminderDraft(
        petId: petId,
        sourceType: 'manual',
        title: '暂停提醒',
        scheduledAt: earlyToday.add(const Duration(hours: 1)),
        paused: true,
      ),
    );

    final reminders = await repository.watchTodayReminders(petId).first;
    expect(reminders.map((r) => r.id), contains(reminder.id));
    expect(reminders.every((r) => !r.paused), isTrue);
  });

  test('rejects invalid source type', () async {
    expect(
      () => repository.create(
        ReminderDraft(
          petId: petId,
          sourceType: 'invalid',
          title: '无效提醒',
          scheduledAt: DateTime.utc(2026, 6, 24),
        ),
      ),
      throwsFormatException,
    );
  });

  test('rejects invalid repeat rule', () async {
    expect(
      () => repository.create(
        ReminderDraft(
          petId: petId,
          sourceType: 'manual',
          title: '无效重复',
          scheduledAt: DateTime.utc(2026, 6, 24),
          repeatRule: 'sometimes',
        ),
      ),
      throwsFormatException,
    );
  });

  test('rejects incomplete auto record template', () async {
    expect(
      () => repository.create(
        ReminderDraft(
          petId: petId,
          sourceType: 'food',
          title: '早餐喂食',
          scheduledAt: DateTime.utc(2026, 6, 24, 8),
          completionMode: 'auto_record',
          recordType: 'food',
          recordUnit: 'g',
        ),
      ),
      throwsFormatException,
    );
    expect(
      () => repository.create(
        ReminderDraft(
          petId: petId,
          sourceType: 'medication',
          title: '用药',
          scheduledAt: DateTime.utc(2026, 6, 24, 8),
          completionMode: 'auto_record',
          recordType: 'medication',
          recordNumericValue: 1,
          recordUnit: '片',
        ),
      ),
      throwsFormatException,
    );
  });

  test('rejects invalid log action', () async {
    final reminder = await repository.create(
      ReminderDraft(
        petId: petId,
        sourceType: 'manual',
        title: '测试',
        scheduledAt: DateTime.utc(2026, 6, 24),
      ),
    );

    expect(
      () => repository.logAction(reminder.id, 'invalid_action'),
      throwsFormatException,
    );
  });

  test('update throws StateError for missing reminder', () {
    expect(
      () => repository.update(
        'nonexistent-id',
        ReminderDraft(
          petId: petId,
          sourceType: 'manual',
          title: '测试',
          scheduledAt: DateTime.utc(2026, 6, 24),
        ),
      ),
      throwsStateError,
    );
  });
}
