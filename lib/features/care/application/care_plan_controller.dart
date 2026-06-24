import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../pets/data/pet_repository.dart';
import '../data/care_plan_repository.dart';
import '../domain/care_plan_models.dart';

/// 静态护理候选列表，不入库。
final carePlanCandidatesProvider = Provider<List<CarePlanCandidate>>((ref) {
  return const [
    CarePlanCandidate(
      id: 'oral_home_care',
      title: '口腔日常护理',
      summary: '建立刷牙或其他家庭口腔护理习惯',
      reason: '狗狗需要持续的口腔护理；具体方式应结合狗狗接受程度和兽医建议。',
      source: CareSuggestionSource.general,
      scheduleOptions: ['每天', '每周 3 次', '自定义周期'],
      defaultSchedule: '每天',
      iconKey: 'oral',
    ),
    CarePlanCandidate(
      id: 'paw_after_walk',
      title: '遛狗后足爪检查',
      summary: '结束遛狗后询问是否检查和清洁足爪',
      reason: '这是由遛狗事件触发的护理候选，不需要开启 GPS，也不会自动生成健康结论。',
      source: CareSuggestionSource.event,
      scheduleOptions: ['每次遛狗后询问', '仅雨雪天询问', '不固定提醒'],
      defaultSchedule: '每次遛狗后询问',
      iconKey: 'paw',
    ),
    CarePlanCandidate(
      id: 'bath_history',
      title: '洗澡计划',
      summary: '继续记录后，根据自己的洗澡间隔提醒',
      reason: '不同狗狗的洗澡频率差异很大，优先使用这只狗狗自己的护理历史，而不是统一周期。',
      source: CareSuggestionSource.history,
      scheduleOptions: ['根据历史间隔', '每 4 周', '自定义周期'],
      defaultSchedule: '根据历史间隔',
      iconKey: 'bath',
    ),
    CarePlanCandidate(
      id: 'nail_check',
      title: '指甲检查与修剪',
      summary: '定期检查指甲磨损和长度',
      reason: '指甲过长会影响步态和关节；修剪频率取决于日常磨损速度。',
      source: CareSuggestionSource.general,
      scheduleOptions: ['每 2 周', '每 4 周', '自定义周期'],
      defaultSchedule: '每 4 周',
      iconKey: 'nail',
    ),
    CarePlanCandidate(
      id: 'combing_regular',
      title: '梳毛计划',
      summary: '根据毛发情况建立定期梳毛习惯',
      reason: '梳毛频率应根据犬种、毛型和季节调整，不套用统一周期。',
      source: CareSuggestionSource.profile,
      scheduleOptions: ['每天', '每周 3 次', '每周 1 次', '自定义周期'],
      defaultSchedule: '每周 3 次',
      iconKey: 'combing',
    ),
    CarePlanCandidate(
      id: 'ear_observation',
      title: '耳部观察',
      summary: '定期检查耳朵气味和分泌物',
      reason: '耳部问题早期通常没有明显症状，定期观察有助于及时发现问题。',
      source: CareSuggestionSource.general,
      scheduleOptions: ['每周 1 次', '每 2 周', '自定义周期'],
      defaultSchedule: '每周 1 次',
      iconKey: 'ear',
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

  Future<void> enable(CarePlanCandidate candidate, String schedule) async {
    final petId = await ref.read(petRepositoryProvider).ensureSelectedPetId();
    final repository = ref.read(carePlanRepositoryProvider);

    final existing = await repository.findByCandidate(petId, candidate.id);
    if (existing != null) {
      await repository.update(
        existing.id,
        CarePlanDraft(
          petId: petId,
          candidateId: candidate.id,
          careType: candidate.iconKey,
          title: candidate.title,
          scheduleRule: schedule,
          reasonSnapshot: candidate.reason,
        ),
      );
    } else {
      await repository.create(
        CarePlanDraft(
          petId: petId,
          candidateId: candidate.id,
          careType: candidate.iconKey,
          title: candidate.title,
          scheduleRule: schedule,
          reasonSnapshot: candidate.reason,
        ),
      );
    }
  }

  Future<void> disable(String candidateId) async {
    final petId = await ref.read(petRepositoryProvider).ensureSelectedPetId();
    final repository = ref.read(carePlanRepositoryProvider);
    final existing = await repository.findByCandidate(petId, candidateId);
    if (existing != null) {
      await repository.disable(existing.id);
    }
  }

  Future<void> pause(String candidateId) async {
    final plan = state.enabledPlans[candidateId];
    if (plan == null) throw StateError('护理计划未开启：$candidateId');
    await ref.read(carePlanRepositoryProvider).pause(plan.id);
  }

  Future<void> resume(String candidateId) async {
    final plan = state.enabledPlans[candidateId];
    if (plan == null) throw StateError('护理计划未开启：$candidateId');
    await ref.read(carePlanRepositoryProvider).resume(plan.id);
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
    return log;
  }

  Future<CarePlanLog> logSkip(String candidateId, {String note = ''}) async {
    final plan = state.enabledPlans[candidateId];
    if (plan == null) throw StateError('护理计划未开启：$candidateId');
    return ref.read(carePlanRepositoryProvider).logSkip(plan.id, note: note);
  }
}
