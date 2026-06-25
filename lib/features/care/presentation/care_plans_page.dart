import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/motion.dart';
import '../../../core/widgets/page_frame.dart';
import '../application/care_controller.dart';
import '../application/care_plan_controller.dart';
import '../data/care_plan_repository.dart';
import '../../records/presentation/add_record_sheet.dart';
import '../domain/care_activity_spec.dart';
import '../domain/care_models.dart';
import '../domain/care_plan_models.dart';

class CarePlansPage extends ConsumerStatefulWidget {
  const CarePlansPage({super.key});

  @override
  ConsumerState<CarePlansPage> createState() => _CarePlansPageState();
}

class _CarePlansPageState extends ConsumerState<CarePlansPage> {
  var _selectedSegment = 0;

  @override
  Widget build(BuildContext context) {
    final planState = ref.watch(carePlanControllerProvider);
    final candidates = ref.watch(carePlanCandidatesProvider);

    return PageFrame(
      title: '护理中心',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SegmentedButton<int>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment(
                value: 0,
                icon: const Icon(Icons.event_available_outlined),
                label: Text('已开启 ${planState.enabledPlans.length}'),
              ),
              const ButtonSegment(
                value: 1,
                icon: Icon(Icons.history_rounded),
                label: Text('记录'),
              ),
              ButtonSegment(
                value: 2,
                icon: const Icon(Icons.auto_awesome_outlined),
                label: Text('建议 ${_visibleCount(candidates, planState)}'),
              ),
            ],
            selected: {_selectedSegment},
            onSelectionChanged: (selection) {
              setState(() => _selectedSegment = selection.single);
            },
          ),
          const SizedBox(height: 22),
          AnimatedSwitcher(
            duration: AppMotion.medium,
            switchInCurve: AppMotion.emphasized,
            child: switch (_selectedSegment) {
              0 => _EnabledList(
                key: const ValueKey('enabled'),
                candidates: candidates,
                state: planState,
              ),
              1 => const _CareHistory(key: ValueKey('history')),
              _ => _CandidateList(
                key: const ValueKey('candidates'),
                candidates: candidates,
                state: planState,
              ),
            },
          ),
          if (_selectedSegment == 0) ...[
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => showCreateCustomPlanSheet(context),
              icon: const Icon(Icons.add_circle_outline_rounded),
              label: const Text('自建计划'),
            ),
          ],
        ],
      ),
    );
  }
}

int _visibleCount(List<CarePlanCandidate> candidates, CarePlanState state) {
  return candidates
      .where(
        (candidate) =>
            !state.dismissedCandidateIds.contains(candidate.id) &&
            !state.enabledPlans.containsKey(candidate.id),
      )
      .length;
}

class _CandidateList extends StatelessWidget {
  const _CandidateList({
    required this.candidates,
    required this.state,
    super.key,
  });

  final List<CarePlanCandidate> candidates;
  final CarePlanState state;

  @override
  Widget build(BuildContext context) {
    final visible = candidates
        .where(
          (candidate) =>
              !state.dismissedCandidateIds.contains(candidate.id) &&
              !state.enabledPlans.containsKey(candidate.id),
        )
        .toList();
    if (visible.isEmpty) {
      return const _EmptyState(
        icon: Icons.task_alt_rounded,
        title: '所有建议都处理好了',
        message: '新的档案、记录或生活事件可能产生新的护理候选。',
      );
    }
    return Column(
      children: [
        for (var index = 0; index < visible.length; index++) ...[
          _SuggestionCard(candidate: visible[index]),
          if (index != visible.length - 1) const SizedBox(height: 14),
        ],
      ],
    );
  }
}

class _SuggestionCard extends ConsumerWidget {
  const _SuggestionCard({required this.candidate});

  final CarePlanCandidate candidate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    return PressableScale(
      child: Card(
        color: colors.surfaceContainerLow,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: _containerColor(candidate, colors),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(_icon(candidate.iconKey)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          candidate.title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          candidate.summary,
                          style: TextStyle(color: colors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colors.surfaceContainer,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lightbulb_outline_rounded,
                      size: 19,
                      color: colors.primary,
                    ),
                    const SizedBox(width: 9),
                    Expanded(child: Text(candidate.reason)),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Chip(label: Text(_sourceLabel(candidate.source))),
                  const Spacer(),
                  FilledButton.tonalIcon(
                    onPressed: () =>
                        showEnableCarePlanSheet(context, candidate),
                    icon: const Icon(Icons.add_task_rounded),
                    label: const Text('选择开启'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EnabledList extends StatelessWidget {
  const _EnabledList({
    required this.candidates,
    required this.state,
    super.key,
  });

  final List<CarePlanCandidate> candidates;
  final CarePlanState state;

  @override
  Widget build(BuildContext context) {
    if (state.enabledPlans.isEmpty) {
      return const _EmptyState(
        icon: Icons.event_available_outlined,
        title: '还没有开启护理计划',
        message: '建议不会自动打开。选择适合自己的项目和周期后，它才会出现在这里。',
      );
    }
    final byId = {for (final candidate in candidates) candidate.id: candidate};
    return Column(
      children: [
        for (final plan in state.enabledPlans.values) ...[
          _EnabledPlanCard(
            candidate: byId[plan.candidateId] ?? _candidateFromPlan(plan),
            plan: plan,
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

CarePlanCandidate _candidateFromPlan(CarePlan plan) {
  final rule = scheduleRuleCodec.decodeAny(plan.scheduleRule);
  return CarePlanCandidate(
    id: plan.candidateId,
    title: plan.title.isEmpty ? '护理计划' : plan.title,
    summary: '已保存的护理计划',
    reason: plan.reasonSnapshot.isEmpty ? '这是已保存的护理计划。' : plan.reasonSnapshot,
    source: CareSuggestionSource.general,
    scheduleOptions: [
      ?rule,
      const DailyRule(),
      const WeeklyTimesRule(1),
      const CustomCycleRule(14),
      const CustomCycleRule(28),
    ],
    defaultSchedule: rule ?? const CustomCycleRule(14),
    iconKey: plan.careType,
  );
}

class _EnabledPlanCard extends ConsumerStatefulWidget {
  const _EnabledPlanCard({required this.candidate, required this.plan});

  final CarePlanCandidate candidate;
  final CarePlan plan;

  @override
  ConsumerState<_EnabledPlanCard> createState() => _EnabledPlanCardState();
}

class _EnabledPlanCardState extends ConsumerState<_EnabledPlanCard> {
  var _isSaving = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final logs = ref.watch(carePlanLogsProvider(widget.plan.id)).value;
    final latestLog = logs?.firstOrNull;
    final statusText = [
      _scheduleLabel(widget.plan.scheduleRule),
      if (widget.plan.nextDueAt != null)
        '下次 ${_formatDate(widget.plan.nextDueAt!)}',
      if (widget.plan.paused) '已暂停',
      if (latestLog != null)
        '${_logActionLabel(latestLog.action)} ${_formatDateTime(latestLog.occurredAt)}',
    ].join(' · ');

    return Card(
      color: widget.plan.paused
          ? colors.surfaceContainerHigh
          : colors.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: colors.surface.withValues(alpha: .72),
                  child: Icon(
                    _icon(widget.candidate.iconKey),
                    color: colors.primary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.candidate.title,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        statusText,
                        style: TextStyle(color: colors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: widget.plan.paused ? '恢复计划' : '暂停计划',
                  onPressed: _isSaving ? null : _togglePaused,
                  icon: Icon(
                    widget.plan.paused
                        ? Icons.play_arrow_rounded
                        : Icons.pause_rounded,
                  ),
                ),
                IconButton(
                  tooltip: '调整计划',
                  onPressed: _isSaving
                      ? null
                      : () =>
                            showEnableCarePlanSheet(context, widget.candidate),
                  icon: const Icon(Icons.tune_rounded),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.tonalIcon(
                  onPressed: _isSaving || widget.plan.paused
                      ? null
                      : _completeWithDetails,
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('完成'),
                ),
                OutlinedButton.icon(
                  onPressed: _isSaving || widget.plan.paused
                      ? null
                      : () => _writeLog(completed: false),
                  icon: const Icon(Icons.next_plan_outlined),
                  label: const Text('跳过'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _togglePaused() async {
    await _runMutation(() {
      final controller = ref.read(carePlanControllerProvider.notifier);
      return widget.plan.paused
          ? controller.resume(widget.candidate.id)
          : controller.pause(widget.candidate.id);
    }, success: widget.plan.paused ? '已恢复计划' : '已暂停计划');
  }

  Future<void> _completeWithDetails() async {
    if (!careActivityTypes.contains(widget.plan.careType) ||
        widget.plan.careType == 'walk') {
      return _writeLog(completed: true);
    }
    var completed = false;
    await showCareActivitySheet(
      context,
      type: widget.plan.careType,
      beforeSave: (draft) async {
        await ref
            .read(carePlanControllerProvider.notifier)
            .logCompletionWithActivity(
              widget.candidate.id,
              activityDraft: draft,
            );
        completed = true;
        return null;
      },
    );
    if (!mounted || !completed) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('已记录完成')));
  }

  Future<void> _writeLog({required bool completed}) {
    return _runMutation(() {
      final controller = ref.read(carePlanControllerProvider.notifier);
      return completed
          ? controller.logCompletionWithActivity(widget.candidate.id)
          : controller.logSkip(widget.candidate.id);
    }, success: completed ? '已记录完成' : '已记录跳过');
  }

  Future<void> _runMutation(
    Future<void> Function() mutation, {
    required String success,
  }) async {
    setState(() => _isSaving = true);
    try {
      await mutation();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(success)));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_errorMessage(error))));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}

class _CareHistory extends ConsumerWidget {
  const _CareHistory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(careControllerProvider);
    final planState = ref.watch(carePlanControllerProvider);
    final candidates = ref.watch(carePlanCandidatesProvider);
    final byId = {for (final candidate in candidates) candidate.id: candidate};
    final items = <_HistoryItem>[];
    if (state.lastBath != null) {
      items.add(
        _HistoryItem(
          occurredAt: state.lastBath!.occurredAt,
          child: _HistoryTile(
            icon: Icons.bathtub_outlined,
            title: '洗澡护理',
            subtitle: state.lastBath!.place.isEmpty
                ? '未填写地点'
                : state.lastBath!.place,
          ),
        ),
      );
    }
    for (final walk in state.walks) {
      items.add(
        _HistoryItem(
          occurredAt: walk.startedAt,
          child: _HistoryTile(
            icon: Icons.directions_walk_rounded,
            title: '遛狗 · ${_formatWalkWindow(walk)}',
            subtitle: walk.place.isEmpty ? '未填写场所' : walk.place,
          ),
        ),
      );
    }
    for (final plan in planState.enabledPlans.values) {
      final logs = ref.watch(carePlanLogsProvider(plan.id)).value ?? const [];
      final candidate = byId[plan.candidateId] ?? _candidateFromPlan(plan);
      for (final log in logs) {
        items.add(
          _HistoryItem(
            occurredAt: log.occurredAt,
            child: _HistoryTile(
              icon: log.action == 'completed'
                  ? Icons.check_circle_outline_rounded
                  : Icons.next_plan_outlined,
              title: '${candidate.title} · ${_logActionLabel(log.action)}',
              subtitle: log.note.isEmpty
                  ? _formatDateTime(log.occurredAt)
                  : '${_formatDateTime(log.occurredAt)} · ${log.note}',
            ),
          ),
        );
      }
    }
    items.sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
    if (items.isEmpty) {
      return const _EmptyState(
        icon: Icons.history_rounded,
        title: '还没有护理记录',
        message: '洗澡、遛狗和完成的护理计划会统一出现在这里。',
      );
    }
    return Card(
      child: Column(children: items.map((item) => item.child).toList()),
    );
  }
}

class _HistoryItem {
  const _HistoryItem({required this.occurredAt, required this.child});

  final DateTime occurredAt;
  final Widget child;
}

String _formatWalkWindow(WalkRecord walk) {
  return '${_formatClock(walk.startedAt)}-${_formatClock(walk.endedAt)}（${walk.duration.inMinutes} 分钟）';
}

String _formatClock(DateTime date) {
  final local = date.toLocal();
  return '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
}

String _formatDate(DateTime date) {
  final local = date.toLocal();
  return '${local.month}/${local.day}';
}

String _formatDateTime(DateTime date) {
  final local = date.toLocal();
  return '${local.month}/${local.day} ${_formatClock(local)}';
}

String _logActionLabel(String action) => switch (action) {
  'completed' => '已完成',
  'skipped' => '已跳过',
  _ => action,
};

String _scheduleLabel(String raw) {
  return scheduleRuleCodec.decodeAny(raw)?.toString() ?? raw;
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            Icon(icon, size: 38, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 14),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

Future<void> showEnableCarePlanSheet(
  BuildContext context,
  CarePlanCandidate candidate,
) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    sheetAnimationStyle: const AnimationStyle(
      duration: AppMotion.medium,
      reverseDuration: AppMotion.fast,
    ),
    builder: (_) => _EnableCarePlanSheet(candidate: candidate),
  );
}

class _EnableCarePlanSheet extends ConsumerStatefulWidget {
  const _EnableCarePlanSheet({required this.candidate});

  final CarePlanCandidate candidate;

  @override
  ConsumerState<_EnableCarePlanSheet> createState() =>
      _EnableCarePlanSheetState();
}

class _EnableCarePlanSheetState extends ConsumerState<_EnableCarePlanSheet> {
  late ScheduleRule _schedule;
  late final TextEditingController _customDaysController;
  var _isSaving = false;
  var _usingCustomSchedule = false;

  @override
  void initState() {
    super.initState();
    final enabled = ref
        .read(carePlanControllerProvider)
        .enabledPlans[widget.candidate.id];
    if (enabled != null) {
      _schedule =
          scheduleRuleCodec.decodeAny(enabled.scheduleRule) ??
          widget.candidate.defaultSchedule;
    } else {
      _schedule = widget.candidate.defaultSchedule;
    }
    final optionCodes = widget.candidate.scheduleOptions
        .map(scheduleRuleCodec.encode)
        .toSet();
    _usingCustomSchedule = !optionCodes.contains(
      scheduleRuleCodec.encode(_schedule),
    );
    _customDaysController = TextEditingController(
      text: (_schedule.intervalDays ?? 14).toString(),
    );
  }

  @override
  void dispose() {
    _customDaysController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = ref.watch(
      carePlanControllerProvider.select(
        (state) => state.enabledPlans.containsKey(widget.candidate.id),
      ),
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.candidate.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 6),
          Text(
            widget.candidate.reason,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 20),
          Text('选择计划', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final option in widget.candidate.scheduleOptions)
                ChoiceChip(
                  label: Text(option.toString()),
                  selected:
                      !_usingCustomSchedule &&
                      scheduleRuleCodec.encode(_schedule) ==
                          scheduleRuleCodec.encode(option),
                  onSelected: (_) => setState(() {
                    _usingCustomSchedule = false;
                    _schedule = option;
                    final days = option.intervalDays;
                    if (days != null) _customDaysController.text = '$days';
                  }),
                ),
              ChoiceChip(
                label: const Text('自定义'),
                selected: _usingCustomSchedule,
                onSelected: (_) => setState(() {
                  _usingCustomSchedule = true;
                  _schedule = CustomCycleRule(_customCycleDays);
                }),
              ),
            ],
          ),
          if (_usingCustomSchedule) ...[
            const SizedBox(height: 12),
            TextField(
              controller: _customDaysController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '自定义频率',
                prefixIcon: Icon(Icons.repeat_rounded),
                suffixText: '天一次',
              ),
              onChanged: (_) {
                setState(() => _schedule = CustomCycleRule(_customCycleDays));
              },
            ),
          ],
          const SizedBox(height: 22),
          FilledButton.icon(
            onPressed: _isSaving ? null : _savePlan,
            icon: Icon(isEnabled ? Icons.save_rounded : Icons.add_task_rounded),
            label: Text(_isSaving ? '保存中...' : (isEnabled ? '保存计划' : '确认开启')),
          ),
          const SizedBox(height: 8),
          if (isEnabled)
            TextButton(
              onPressed: _isSaving ? null : _disablePlan,
              child: const Text('关闭这个计划'),
            )
          else
            TextButton(
              onPressed: _isSaving ? null : _dismissPlan,
              child: const Text('暂不需要，不再显示'),
            ),
        ],
      ),
    );
  }

  Future<void> _savePlan() {
    return _runMutation(
      () => ref
          .read(carePlanControllerProvider.notifier)
          .enable(widget.candidate, _selectedSchedule),
    );
  }

  Future<void> _disablePlan() {
    return _runMutation(
      () => ref
          .read(carePlanControllerProvider.notifier)
          .disable(widget.candidate.id),
    );
  }

  Future<void> _dismissPlan() {
    return _runMutation(
      () => ref
          .read(carePlanControllerProvider.notifier)
          .dismiss(widget.candidate.id),
    );
  }

  Future<void> _runMutation(Future<void> Function() mutation) async {
    setState(() => _isSaving = true);
    try {
      await mutation();
      if (!mounted) return;
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_errorMessage(error))));
    }
  }

  int get _customCycleDays {
    final parsed = int.tryParse(_customDaysController.text.trim());
    if (parsed == null) return 14;
    return parsed.clamp(1, 365).toInt();
  }

  ScheduleRule get _selectedSchedule =>
      _usingCustomSchedule ? CustomCycleRule(_customCycleDays) : _schedule;
}

String _sourceLabel(CareSuggestionSource source) => switch (source) {
  CareSuggestionSource.profile => '档案驱动',
  CareSuggestionSource.history => '历史驱动',
  CareSuggestionSource.event => '事件驱动',
  CareSuggestionSource.general => '基础候选',
};

IconData _icon(String key) => switch (key) {
  'oral' => Icons.auto_fix_high_rounded,
  'paw' => Icons.pets_rounded,
  'bath' => Icons.bathtub_outlined,
  'coat' => Icons.brush_rounded,
  'combing' => Icons.brush_rounded,
  'nail' => Icons.content_cut_rounded,
  'ear' => Icons.hearing_rounded,
  'eye' => Icons.visibility_outlined,
  'styling' => Icons.content_cut_rounded,
  'environment' => Icons.cleaning_services_outlined,
  'deworming' => Icons.bug_report_outlined,
  _ => Icons.health_and_safety_outlined,
};

String _errorMessage(Object error) {
  if (error is FormatException) return error.message;
  if (error is StateError) return error.message;
  return '保存失败，请稍后重试';
}

Color _containerColor(CarePlanCandidate candidate, ColorScheme colors) {
  return switch (candidate.source) {
    CareSuggestionSource.profile => colors.primaryContainer,
    CareSuggestionSource.history => colors.secondaryContainer,
    CareSuggestionSource.event => colors.tertiaryContainer,
    CareSuggestionSource.general => colors.surfaceContainerHighest,
  };
}

// ---------------------------------------------------------------------------
// 自建计划 Sheet
// ---------------------------------------------------------------------------

Future<void> showCreateCustomPlanSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    sheetAnimationStyle: const AnimationStyle(
      duration: AppMotion.medium,
      reverseDuration: AppMotion.fast,
    ),
    builder: (_) => const _CreateCustomPlanSheet(),
  );
}

class _CreateCustomPlanSheet extends ConsumerStatefulWidget {
  const _CreateCustomPlanSheet();

  @override
  ConsumerState<_CreateCustomPlanSheet> createState() =>
      _CreateCustomPlanSheetState();
}

class _CreateCustomPlanSheetState
    extends ConsumerState<_CreateCustomPlanSheet> {
  final _titleController = TextEditingController();
  String _careType = 'oral';
  int _cycleDays = 7;
  var _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        4,
        20,
        24 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('自建护理计划', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 6),
          Text(
            '创建自定义的护理计划，周期由你决定。',
            style: TextStyle(color: colors.onSurfaceVariant, height: 1.4),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _titleController,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: '计划名称',
              hintText: '例如：每月体检、换季护理',
              prefixIcon: Icon(Icons.edit_note_rounded),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _careType,
            decoration: const InputDecoration(labelText: '护理类型'),
            items: careActivityLabels.entries
                .where((entry) => entry.key != 'walk')
                .map(
                  (entry) => DropdownMenuItem(
                    value: entry.key,
                    child: Text(entry.value),
                  ),
                )
                .toList(),
            onChanged: (value) => setState(() => _careType = value!),
          ),
          const SizedBox(height: 16),
          Text('护理周期', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 10),
          Row(
            children: [
              const Expanded(child: Text('每隔多少天护理一次')),
              IconButton(
                tooltip: '减少',
                onPressed: _cycleDays <= 1
                    ? null
                    : () => setState(() => _cycleDays--),
                icon: const Icon(Icons.remove_rounded),
              ),
              Text(
                '$_cycleDays 天',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              IconButton(
                tooltip: '增加',
                onPressed: () => setState(() => _cycleDays++),
                icon: const Icon(Icons.add_rounded),
              ),
            ],
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _isSaving ? null : _save,
            icon: const Icon(Icons.add_task_rounded),
            label: Text(_isSaving ? '创建中...' : '创建计划'),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请填写计划名称')));
      return;
    }
    setState(() => _isSaving = true);
    try {
      await ref
          .read(carePlanControllerProvider.notifier)
          .createCustomPlan(
            title: title,
            careType: _careType,
            cycleDays: _cycleDays,
          );
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('已创建「$title」')));
    } catch (error) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('创建失败：$error')));
    }
  }
}
