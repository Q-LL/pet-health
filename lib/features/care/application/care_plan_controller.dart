import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/care_plan_models.dart';

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
      id: 'coat_brushing',
      title: '梳毛护理',
      summary: '减少打结，并持续观察毛发和皮肤变化',
      reason: '补充毛长、毛型和生活方式后，可以得到更适合的候选周期。',
      source: CareSuggestionSource.profile,
      scheduleOptions: ['每天', '每周 3 次', '每周一次', '自定义周期'],
      defaultSchedule: '每周 3 次',
      iconKey: 'coat',
    ),
    CarePlanCandidate(
      id: 'nail_check',
      title: '指甲检查',
      summary: '记录磨损速度，再决定是否需要修剪',
      reason: '建议先检查而不是直接修剪；狗狗抗拒或主人不熟悉时应交给专业人员。',
      source: CareSuggestionSource.history,
      scheduleOptions: ['每 2 周检查', '每 4 周检查', '自定义周期'],
      defaultSchedule: '每 2 周检查',
      iconKey: 'nail',
    ),
    CarePlanCandidate(
      id: 'ear_observation',
      title: '耳部观察',
      summary: '观察气味、分泌物、红肿和抓挠等事实',
      reason: '这是观察计划，不默认建议深度清洁；发现异常时转为健康记录。',
      source: CareSuggestionSource.general,
      scheduleOptions: ['每周观察', '每 2 周观察', '自定义周期'],
      defaultSchedule: '每周观察',
      iconKey: 'ear',
    ),
  ];
});

final carePlanControllerProvider =
    NotifierProvider<CarePlanController, CarePlanState>(CarePlanController.new);

class CarePlanController extends Notifier<CarePlanState> {
  @override
  CarePlanState build() => const CarePlanState();

  void enable(CarePlanCandidate candidate, String schedule) {
    state = state.copyWith(
      enabledPlans: {
        ...state.enabledPlans,
        candidate.id: EnabledCarePlan(
          candidateId: candidate.id,
          schedule: schedule,
          enabledAt: DateTime.now(),
        ),
      },
      dismissedCandidateIds: {...state.dismissedCandidateIds}
        ..remove(candidate.id),
    );
  }

  void disable(String candidateId) {
    state = state.copyWith(
      enabledPlans: {...state.enabledPlans}..remove(candidateId),
    );
  }

  void dismiss(String candidateId) {
    state = state.copyWith(
      dismissedCandidateIds: {...state.dismissedCandidateIds, candidateId},
    );
  }
}
