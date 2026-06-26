import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/notifications/notification_service.dart';
import '../../pets/data/pet_repository.dart';
import '../data/care_plan_repository.dart';
import '../data/care_repository.dart';
import '../domain/care_models.dart';
import '../domain/care_plan_models.dart';
import 'care_reminder_engine.dart';

const _uuid = Uuid();
const carePlanLogDetailKey = '_carePlanLogId';
const carePlanIdDetailKey = '_carePlanId';

/// 静态护理候选列表，不入库。
final carePlanCandidatesProvider = Provider<List<CarePlanCandidate>>((ref) {
  return const [
    CarePlanCandidate(
      id: 'oral_home_care',
      title: '口腔日常护理',
      summary: '建立刷牙或其他家庭口腔护理习惯',
      reason: '狗狗需要持续的口腔护理；具体方式应结合狗狗接受程度和兽医建议。',
      source: CareSuggestionSource.general,
      scheduleOptions: [DailyRule(), WeeklyTimesRule(3), WeeklyTimesRule(1)],
      defaultSchedule: DailyRule(),
      iconKey: 'oral',
    ),
    CarePlanCandidate(
      id: 'paw_after_walk',
      title: '遛狗后足爪检查',
      summary: '结束遛狗后询问是否检查和清洁足爪',
      reason: '这是由遛狗事件触发的护理候选，不需要开启 GPS，也不会自动生成健康结论。',
      source: CareSuggestionSource.event,
      scheduleOptions: [EventDrivenRule('walk')],
      defaultSchedule: EventDrivenRule('walk'),
      iconKey: 'paw',
    ),
    CarePlanCandidate(
      id: 'bath_history',
      title: '洗澡计划',
      summary: '继续记录后，根据自己的洗澡间隔提醒',
      reason: '不同狗狗的洗澡频率差异很大，优先使用这只狗狗自己的护理历史，而不是统一周期。',
      source: CareSuggestionSource.history,
      scheduleOptions: [
        CustomCycleRule(14),
        CustomCycleRule(28),
        CustomCycleRule(42),
      ],
      defaultSchedule: CustomCycleRule(14),
      iconKey: 'bath',
    ),
    CarePlanCandidate(
      id: 'nail_check',
      title: '指甲检查与修剪',
      summary: '定期检查指甲磨损和长度',
      reason: '指甲过长会影响步态和关节；修剪频率取决于日常磨损速度。',
      source: CareSuggestionSource.general,
      scheduleOptions: [
        CustomCycleRule(14),
        CustomCycleRule(28),
        CustomCycleRule(42),
      ],
      defaultSchedule: CustomCycleRule(28),
      iconKey: 'nail',
    ),
    CarePlanCandidate(
      id: 'combing_regular',
      title: '梳毛计划',
      summary: '根据毛发情况建立定期梳毛习惯',
      reason: '梳毛频率应根据犬种、毛型和季节调整，不套用统一周期。',
      source: CareSuggestionSource.profile,
      scheduleOptions: [
        DailyRule(),
        WeeklyTimesRule(3),
        WeeklyTimesRule(1),
        CustomCycleRule(7),
      ],
      defaultSchedule: WeeklyTimesRule(3),
      iconKey: 'combing',
    ),
    CarePlanCandidate(
      id: 'ear_observation',
      title: '耳部观察',
      summary: '定期检查耳朵气味和分泌物',
      reason: '耳部问题早期通常没有明显症状，定期观察有助于及时发现问题。',
      source: CareSuggestionSource.general,
      scheduleOptions: [
        WeeklyTimesRule(1),
        CustomCycleRule(14),
        CustomCycleRule(30),
      ],
      defaultSchedule: WeeklyTimesRule(1),
      iconKey: 'ear',
    ),
    CarePlanCandidate(
      id: 'eye_care',
      title: '眼部护理',
      summary: '定期清洁眼周、观察泪痕和分泌物',
      reason: '眼部问题容易被忽视，定期观察可以及时发现结膜炎、泪痕异常等问题。',
      source: CareSuggestionSource.general,
      scheduleOptions: [
        WeeklyTimesRule(1),
        CustomCycleRule(14),
        CustomCycleRule(30),
      ],
      defaultSchedule: WeeklyTimesRule(1),
      iconKey: 'eye',
    ),
    CarePlanCandidate(
      id: 'styling_regular',
      title: '美容计划',
      summary: '定期修剪毛发、清洁造型',
      reason: '美容不仅关乎外形，定期修剪也有助于皮肤健康和卫生。',
      source: CareSuggestionSource.general,
      scheduleOptions: [
        CustomCycleRule(28),
        CustomCycleRule(42),
        CustomCycleRule(14),
      ],
      defaultSchedule: CustomCycleRule(28),
      iconKey: 'styling',
    ),
    CarePlanCandidate(
      id: 'environment_clean',
      title: '环境清洁',
      summary: '定期清洗食盆、水碗、狗窝等用品',
      reason: '狗狗的用品容易滋生细菌，定期清洁有助于预防皮肤病和消化问题。',
      source: CareSuggestionSource.general,
      scheduleOptions: [
        WeeklyTimesRule(1),
        CustomCycleRule(14),
        CustomCycleRule(3),
      ],
      defaultSchedule: WeeklyTimesRule(1),
      iconKey: 'environment',
    ),
    CarePlanCandidate(
      id: 'deworming_plan',
      title: '驱虫计划',
      summary: '按时进行体内外驱虫',
      reason: '驱虫是狗狗健康管理的重要环节，一般建议每月一次体外驱虫、每三个月一次体内驱虫。',
      source: CareSuggestionSource.general,
      scheduleOptions: [
        CustomCycleRule(30),
        CustomCycleRule(90),
        CustomCycleRule(14),
      ],
      defaultSchedule: CustomCycleRule(30),
      iconKey: 'deworming',
    ),
  ];
});

final carePlanControllerProvider =
    NotifierProvider<CarePlanController, CarePlanState>(CarePlanController.new);

class CarePlanController extends Notifier<CarePlanState> {
  @override
  CarePlanState build() {
    _subscribe();
    return const CarePlanState(isLoading: true);
  }

  void _subscribe() {
    final petId = ref.watch(selectedPetIdProvider).value;
    if (petId == null) return;

    ref.listen(carePlansForPetProvider(petId), (_, next) {
      next.whenData((plans) => _syncFromDatabase(plans));
    }, fireImmediately: true);
  }

  void _syncFromDatabase(List<CarePlan> plans) {
    final enabled = <String, CarePlan>{};
    final dismissed = <String>{};
    for (final plan in plans) {
      if (plan.enabled) {
        enabled[plan.candidateId] = plan;
      } else if (plan.reasonSnapshot == 'dismissed') {
        dismissed.add(plan.candidateId);
      }
    }
    state = state.copyWith(
      enabledPlans: enabled,
      dismissedCandidateIds: dismissed,
      isLoading: false,
    );
  }

  Future<void> enable(
    CarePlanCandidate candidate,
    ScheduleRule schedule,
  ) async {
    final petId = await ref.read(petRepositoryProvider).ensureSelectedPetId();
    final repository = ref.read(carePlanRepositoryProvider);
    final ruleString = scheduleRuleCodec.encode(schedule);
    final nextDueAt = await _initialNextDueAt(
      petId: petId,
      careType: candidate.iconKey,
      schedule: schedule,
    );

    final existing = await repository.findByCandidate(petId, candidate.id);
    if (existing != null) {
      final updated = await repository.update(
        existing.id,
        CarePlanDraft(
          petId: petId,
          candidateId: candidate.id,
          careType: candidate.iconKey,
          title: candidate.title,
          scheduleRule: ruleString,
          nextDueAt: nextDueAt,
          reasonSnapshot: candidate.reason,
        ),
      );
      await _schedulePlanNotification(updated);
      _upsertEnabledPlan(updated);
    } else {
      final created = await repository.create(
        CarePlanDraft(
          petId: petId,
          candidateId: candidate.id,
          careType: candidate.iconKey,
          title: candidate.title,
          scheduleRule: ruleString,
          nextDueAt: nextDueAt,
          reasonSnapshot: candidate.reason,
        ),
      );
      await _schedulePlanNotification(created);
      _upsertEnabledPlan(created);
    }
  }

  Future<void> disable(String candidateId) async {
    final petId = await ref.read(petRepositoryProvider).ensureSelectedPetId();
    final repository = ref.read(carePlanRepositoryProvider);
    final existing = await repository.findByCandidate(petId, candidateId);
    if (existing != null) {
      await repository.disable(existing.id);
      await notificationService.cancelCarePlanDue(existing.id);
      _removeEnabledPlan(existing.candidateId);
    }
  }

  Future<void> pause(String candidateId) async {
    final plan = state.enabledPlans[candidateId];
    if (plan == null) throw StateError('护理计划未开启：$candidateId');
    await ref.read(carePlanRepositoryProvider).pause(plan.id);
    await notificationService.cancelCarePlanDue(plan.id);
  }

  Future<void> resume(String candidateId) async {
    final plan = state.enabledPlans[candidateId];
    if (plan == null) throw StateError('护理计划未开启：$candidateId');
    await ref.read(carePlanRepositoryProvider).resume(plan.id);
    await _schedulePlanNotification(plan);
  }

  Future<void> dismiss(String candidateId) async {
    final petId = await ref.read(petRepositoryProvider).ensureSelectedPetId();
    await ref.read(carePlanRepositoryProvider).dismiss(petId, candidateId);
  }

  Future<CarePlanLog> logCompletion(
    String candidateId, {
    String note = '',
  }) async {
    final plan = state.enabledPlans[candidateId];
    if (plan == null) throw StateError('护理计划未开启：$candidateId');
    final repository = ref.read(carePlanRepositoryProvider);
    final log = await repository.logCompletion(plan.id, note: note);
    await repository.recalculateNextDue(plan.id);
    final updatedPlan = await repository.getById(plan.id);
    await _schedulePlanNotification(updatedPlan ?? plan);
    return log;
  }

  Future<CarePlanLog> logSkip(String candidateId, {String note = ''}) async {
    final plan = state.enabledPlans[candidateId];
    if (plan == null) throw StateError('护理计划未开启：$candidateId');
    final repository = ref.read(carePlanRepositoryProvider);
    final log = await repository.logSkip(plan.id, note: note);
    await repository.recalculateNextDue(
      plan.id,
      completedAt: await _completionTimesForPlan(plan),
    );
    final updatedPlan = await repository.getById(plan.id);
    await _schedulePlanNotification(updatedPlan ?? plan);
    return log;
  }

  /// 创建自定义护理计划。
  Future<CarePlan> createCustomPlan({
    required String title,
    required String careType,
    required int cycleDays,
    String reason = '',
  }) async {
    final petId = await ref.read(petRepositoryProvider).ensureSelectedPetId();
    final repository = ref.read(carePlanRepositoryProvider);
    final candidateId = 'custom_${_uuid.v4()}';
    final rule = CustomCycleRule(cycleDays);
    final ruleString = scheduleRuleCodec.encode(rule);
    final nextDueAt = await _initialNextDueAt(
      petId: petId,
      careType: careType,
      schedule: rule,
    );

    final plan = await repository.create(
      CarePlanDraft(
        petId: petId,
        candidateId: candidateId,
        careType: careType,
        title: title,
        scheduleRule: ruleString,
        nextDueAt: nextDueAt,
        reasonSnapshot: reason.isEmpty ? '自定义护理计划' : reason,
      ),
    );
    await _schedulePlanNotification(plan);
    _upsertEnabledPlan(plan);
    return plan;
  }

  /// 更新自定义计划的周期。
  Future<void> updateCustomPlanCycle(String planId, int cycleDays) async {
    final repository = ref.read(carePlanRepositoryProvider);
    final plan = await repository.getById(planId);
    if (plan == null) throw StateError('护理计划不存在：$planId');

    final rule = CustomCycleRule(cycleDays);
    final ruleString = scheduleRuleCodec.encode(rule);
    final nextDueAt = await _initialNextDueAt(
      petId: plan.petId,
      careType: plan.careType,
      schedule: rule,
    );
    final updated = await repository.update(
      planId,
      CarePlanDraft(
        petId: plan.petId,
        candidateId: plan.candidateId,
        careType: plan.careType,
        title: plan.title,
        scheduleRule: ruleString,
        nextDueAt: nextDueAt,
        reasonSnapshot: plan.reasonSnapshot,
      ),
    );
    await _schedulePlanNotification(updated);
  }

  /// 删除计划（彻底删除）。
  Future<void> deletePlan(String planId) async {
    await notificationService.cancelCarePlanDue(planId);
    await ref.read(carePlanRepositoryProvider).delete(planId);
  }

  /// 完成计划并同时创建 CareActivity 记录。
  Future<CarePlanLog> logCompletionWithActivity(
    String candidateId, {
    String note = '',
    CareActivityDraft? activityDraft,
  }) async {
    final plan = state.enabledPlans[candidateId];
    if (plan == null) throw StateError('护理计划未开启：$candidateId');

    final repository = ref.read(carePlanRepositoryProvider);
    final log = await repository.logCompletion(plan.id, note: note);

    final careRepo = ref.read(careRepositoryProvider);
    final activityType = plan.careType;
    if (careActivityTypes.contains(activityType) && activityType != 'walk') {
      final details = {
        if (activityDraft != null) ...activityDraft.details,
        carePlanLogDetailKey: log.id,
        carePlanIdDetailKey: plan.id,
      };
      await careRepo.create(
        activityDraft == null
            ? CareActivityDraft(
                petId: plan.petId,
                type: activityType,
                occurredAt: DateTime.now(),
                note: note,
                details: details,
              )
            : CareActivityDraft(
                petId: activityDraft.petId,
                type: activityDraft.type,
                occurredAt: activityDraft.occurredAt,
                startedAt: activityDraft.startedAt,
                endedAt: activityDraft.endedAt,
                place: activityDraft.place,
                note: activityDraft.note,
                details: details,
                routeFilePath: activityDraft.routeFilePath,
              ),
      );
    }

    await repository.recalculateNextDue(
      plan.id,
      completedAt: await _completionTimesForPlan(plan),
    );
    final updatedPlan = await repository.getById(plan.id);
    await _schedulePlanNotification(updatedPlan ?? plan);

    return log;
  }

  Future<List<DateTime>?> _completionTimesForPlan(CarePlan plan) async {
    if (!careActivityTypes.contains(plan.careType) || plan.careType == 'walk') {
      return null;
    }
    final activities = await ref
        .read(careRepositoryProvider)
        .findForPet(plan.petId, type: plan.careType);
    return activities.map((activity) => activity.occurredAt).toList();
  }

  Future<DateTime?> _initialNextDueAt({
    required String petId,
    required String careType,
    required ScheduleRule schedule,
  }) async {
    DateTime? lastCareAt;
    if (careActivityTypes.contains(careType)) {
      final latestActivity = await ref
          .read(careRepositoryProvider)
          .findLatestByType(petId, careType);
      lastCareAt = latestActivity?.occurredAt;
    }
    return careReminderEngine.initialDueAt(
      rule: schedule,
      now: DateTime.now(),
      lastCareAt: lastCareAt,
    );
  }

  Future<void> _schedulePlanNotification(CarePlan plan) async {
    await notificationService.cancelCarePlanDue(plan.id);
    if (!plan.enabled || plan.paused || plan.nextDueAt == null) return;
    await notificationService.scheduleCarePlanDue(
      planId: plan.id,
      title: plan.title,
      dueAt: plan.nextDueAt!,
    );
  }

  void _upsertEnabledPlan(CarePlan plan) {
    if (!plan.enabled) return;
    state = state.copyWith(
      enabledPlans: {...state.enabledPlans, plan.candidateId: plan},
      dismissedCandidateIds: {...state.dismissedCandidateIds}
        ..remove(plan.candidateId),
      isLoading: false,
    );
  }

  void _removeEnabledPlan(String candidateId) {
    final enabled = {...state.enabledPlans}..remove(candidateId);
    state = state.copyWith(enabledPlans: enabled, isLoading: false);
  }
}
