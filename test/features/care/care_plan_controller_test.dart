import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/core/database/app_database.dart';
import 'package:pet_health/core/database/database_provider.dart';
import 'package:pet_health/features/care/application/care_plan_controller.dart';
import 'package:pet_health/features/care/data/care_plan_repository.dart';
import 'package:pet_health/features/care/domain/care_plan_models.dart';
import 'package:pet_health/features/pets/data/pet_repository.dart';

void main() {
  late AppDatabase database;
  late ProviderContainer container;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(database)],
    );
    addTearDown(container.dispose);
    addTearDown(database.close);
  });

  test('care plan repository create and read', () async {
    final petId = await container
        .read(petRepositoryProvider)
        .ensureSelectedPetId();
    final repo = container.read(carePlanRepositoryProvider);

    final plan = await repo.create(
      CarePlanDraft(
        petId: petId,
        candidateId: 'oral_home_care',
        careType: 'oral',
        title: '口腔日常护理',
        scheduleRule: '每天',
        reasonSnapshot: '狗狗需要持续的口腔护理',
      ),
    );
    expect(plan.enabled, isTrue);
    expect(plan.scheduleRule, '每天');
    expect(plan.title, '口腔日常护理');

    final found = await repo.findByCandidate(petId, 'oral_home_care');
    expect(found?.id, plan.id);

    final byId = await repo.getById(plan.id);
    expect(byId?.careType, 'oral');
  });

  test('care plan repository update', () async {
    final petId = await container
        .read(petRepositoryProvider)
        .ensureSelectedPetId();
    final repo = container.read(carePlanRepositoryProvider);

    final plan = await repo.create(
      CarePlanDraft(
        petId: petId,
        candidateId: 'bath_history',
        careType: 'bath',
        title: '洗澡计划',
        scheduleRule: '每 4 周',
      ),
    );

    final updated = await repo.update(
      plan.id,
      CarePlanDraft(
        petId: petId,
        candidateId: 'bath_history',
        careType: 'bath',
        title: '洗澡计划',
        scheduleRule: '每 2 周',
      ),
    );
    expect(updated.scheduleRule, '每 2 周');
  });

  test('care plan pause, resume, enable, disable', () async {
    final petId = await container
        .read(petRepositoryProvider)
        .ensureSelectedPetId();
    final repo = container.read(carePlanRepositoryProvider);

    final plan = await repo.create(
      CarePlanDraft(
        petId: petId,
        candidateId: 'nail_check',
        careType: 'nail',
        title: '指甲检查',
        scheduleRule: '每 4 周',
      ),
    );

    await repo.pause(plan.id);
    expect((await repo.getById(plan.id))?.paused, isTrue);

    await repo.resume(plan.id);
    expect((await repo.getById(plan.id))?.paused, isFalse);

    await repo.disable(plan.id);
    expect((await repo.getById(plan.id))?.enabled, isFalse);

    await repo.enable(plan.id);
    expect((await repo.getById(plan.id))?.enabled, isTrue);
  });

  test('care plan logs: completion and skip', () async {
    final petId = await container
        .read(petRepositoryProvider)
        .ensureSelectedPetId();
    final repo = container.read(carePlanRepositoryProvider);

    final plan = await repo.create(
      CarePlanDraft(
        petId: petId,
        candidateId: 'oral_home_care',
        careType: 'oral',
        title: '口腔日常护理',
        scheduleRule: '每天',
      ),
    );

    final completionLog = await repo.logCompletion(plan.id, note: '刷牙完成');
    expect(completionLog.action, 'completed');
    expect(completionLog.note, '刷牙完成');
    expect(completionLog.planId, plan.id);
    expect(completionLog.petId, petId);

    final skipLog = await repo.logSkip(plan.id, note: '今天跳过');
    expect(skipLog.action, 'skipped');
    expect(skipLog.note, '今天跳过');

    final logs = await repo.findLogs(plan.id);
    expect(logs, hasLength(2));
    // 包含两种动作
    final actions = logs.map((l) => l.action).toSet();
    expect(actions, {'completed', 'skipped'});
  });

  test('care plan delete and cascade logs', () async {
    final petId = await container
        .read(petRepositoryProvider)
        .ensureSelectedPetId();
    final repo = container.read(carePlanRepositoryProvider);

    final plan = await repo.create(
      CarePlanDraft(
        petId: petId,
        candidateId: 'ear_observation',
        careType: 'ear',
        title: '耳部观察',
        scheduleRule: '每周 1 次',
      ),
    );
    await repo.logCompletion(plan.id);

    expect(await repo.delete(plan.id), isTrue);
    expect(await repo.delete(plan.id), isFalse);
    expect(await repo.getById(plan.id), isNull);
    // 日志级联删除
    expect(await repo.findLogs(plan.id), isEmpty);
  });

  test('dismiss creates a disabled placeholder', () async {
    final petId = await container
        .read(petRepositoryProvider)
        .ensureSelectedPetId();
    final repo = container.read(carePlanRepositoryProvider);

    final dismissed = await repo.dismiss(petId, 'bath_history');
    expect(dismissed.enabled, isFalse);
    expect(dismissed.reasonSnapshot, 'dismissed');

    // 重复 dismiss 返回同一条
    final again = await repo.dismiss(petId, 'bath_history');
    expect(again.id, dismissed.id);
  });

  test('create reuses dismissed candidate instead of duplicating it', () async {
    final petId = await container
        .read(petRepositoryProvider)
        .ensureSelectedPetId();
    final repo = container.read(carePlanRepositoryProvider);

    final dismissed = await repo.dismiss(petId, 'combing_regular');
    final enabled = await repo.create(
      CarePlanDraft(
        petId: petId,
        candidateId: 'combing_regular',
        careType: 'combing',
        title: '梳毛计划',
        scheduleRule: '每周 3 次',
        reasonSnapshot: '根据毛发情况建立定期梳毛习惯',
      ),
    );

    expect(enabled.id, dismissed.id);
    expect(enabled.enabled, isTrue);
    expect(enabled.reasonSnapshot, isNot('dismissed'));
    expect(await repo.findForPet(petId), hasLength(1));
  });

  test('recalculates next due for weekly frequency schedules', () async {
    final petId = await container
        .read(petRepositoryProvider)
        .ensureSelectedPetId();
    final repo = container.read(carePlanRepositoryProvider);

    final plan = await repo.create(
      CarePlanDraft(
        petId: petId,
        candidateId: 'combing_regular',
        careType: 'combing',
        title: '梳毛计划',
        scheduleRule: '每周 3 次',
      ),
    );

    final log = await repo.logCompletion(plan.id);
    await repo.recalculateNextDue(plan.id);

    final updated = await repo.getById(plan.id);
    expect(updated?.nextDueAt, log.occurredAt.add(const Duration(days: 3)));
  });

  test('findForPet with enabled filter', () async {
    final petId = await container
        .read(petRepositoryProvider)
        .ensureSelectedPetId();
    final repo = container.read(carePlanRepositoryProvider);

    await repo.create(
      CarePlanDraft(
        petId: petId,
        candidateId: 'oral_home_care',
        careType: 'oral',
        title: '口腔日常护理',
        scheduleRule: '每天',
      ),
    );
    await repo.dismiss(petId, 'bath_history');

    final all = await repo.findForPet(petId);
    expect(all, hasLength(2));

    final enabledOnly = await repo.findForPet(petId, enabled: true);
    expect(enabledOnly, hasLength(1));
    expect(enabledOnly.first.candidateId, 'oral_home_care');

    final disabledOnly = await repo.findForPet(petId, enabled: false);
    expect(disabledOnly, hasLength(1));
    expect(disabledOnly.first.candidateId, 'bath_history');
  });

  test('candidates provider returns static list', () {
    final candidates = container.read(carePlanCandidatesProvider);
    expect(candidates, isNotEmpty);
    expect(candidates.every((c) => c.id.isNotEmpty), isTrue);
    expect(candidates.every((c) => c.title.isNotEmpty), isTrue);
    expect(candidates.every((c) => c.scheduleOptions.isNotEmpty), isTrue);
  });

  test('rejects empty title and schedule rule', () async {
    final petId = await container
        .read(petRepositoryProvider)
        .ensureSelectedPetId();
    final repo = container.read(carePlanRepositoryProvider);

    expect(
      () => repo.create(
        CarePlanDraft(
          petId: petId,
          candidateId: 'test',
          careType: 'test',
          title: '',
          scheduleRule: '每天',
        ),
      ),
      throwsFormatException,
    );

    expect(
      () => repo.create(
        CarePlanDraft(
          petId: petId,
          candidateId: 'test',
          careType: 'test',
          title: '测试',
          scheduleRule: '',
        ),
      ),
      throwsFormatException,
    );
  });
}
