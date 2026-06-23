import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/motion.dart';
import '../../../core/widgets/page_frame.dart';
import '../application/care_controller.dart';
import '../application/care_plan_controller.dart';
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
      subtitle: '建议由你决定是否开启，护理和健康一起形成长期履历。',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _ControlBanner(),
          const SizedBox(height: 20),
          SegmentedButton<int>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment(
                value: 0,
                icon: const Icon(Icons.auto_awesome_outlined),
                label: Text('建议 ${_visibleCount(candidates, planState)}'),
              ),
              ButtonSegment(
                value: 1,
                icon: const Icon(Icons.event_available_outlined),
                label: Text('已开启 ${planState.enabledPlans.length}'),
              ),
              const ButtonSegment(
                value: 2,
                icon: Icon(Icons.history_rounded),
                label: Text('记录'),
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
              0 => _CandidateList(
                key: const ValueKey('candidates'),
                candidates: candidates,
                state: planState,
              ),
              1 => _EnabledList(
                key: const ValueKey('enabled'),
                candidates: candidates,
                state: planState,
              ),
              _ => const _CareHistory(key: ValueKey('history')),
            },
          ),
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

class _ControlBanner extends StatelessWidget {
  const _ControlBanner();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colors.surface.withValues(alpha: .72),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.tune_rounded, color: colors.primary),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '所有建议默认关闭',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                SizedBox(height: 5),
                Text('开启前可以查看原因并调整周期；之后也能暂停或关闭。'),
              ],
            ),
          ),
        ],
      ),
    );
  }
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
          _EnabledPlanCard(candidate: byId[plan.candidateId]!, plan: plan),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _EnabledPlanCard extends StatelessWidget {
  const _EnabledPlanCard({required this.candidate, required this.plan});

  final CarePlanCandidate candidate;
  final EnabledCarePlan plan;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      color: colors.primaryContainer,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),
        leading: CircleAvatar(
          backgroundColor: colors.surface.withValues(alpha: .72),
          child: Icon(_icon(candidate.iconKey), color: colors.primary),
        ),
        title: Text(candidate.title),
        subtitle: Text(plan.schedule),
        trailing: const Icon(Icons.tune_rounded),
        onTap: () => showEnableCarePlanSheet(context, candidate),
      ),
    );
  }
}

class _CareHistory extends ConsumerWidget {
  const _CareHistory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(careControllerProvider);
    final items = <Widget>[];
    if (state.lastBath != null) {
      items.add(
        _HistoryTile(
          icon: Icons.bathtub_outlined,
          title: '洗澡护理',
          subtitle: state.lastBath!.place.isEmpty
              ? '未填写地点'
              : state.lastBath!.place,
        ),
      );
    }
    for (final walk in state.walks) {
      items.add(
        _HistoryTile(
          icon: Icons.directions_walk_rounded,
          title: '遛狗 · ${_formatWalkWindow(walk)}',
          subtitle: walk.place.isEmpty ? '未填写场所' : walk.place,
        ),
      );
    }
    if (items.isEmpty) {
      return const _EmptyState(
        icon: Icons.history_rounded,
        title: '还没有护理记录',
        message: '洗澡、遛狗和完成的护理计划会统一出现在这里。',
      );
    }
    return Card(child: Column(children: items));
  }
}

String _formatWalkWindow(WalkRecord walk) {
  return '${_formatClock(walk.startedAt)}-${_formatClock(walk.endedAt)}（${walk.duration.inMinutes} 分钟）';
}

String _formatClock(DateTime date) {
  final local = date.toLocal();
  return '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
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
  late String _schedule;

  @override
  void initState() {
    super.initState();
    final enabled = ref
        .read(carePlanControllerProvider)
        .enabledPlans[widget.candidate.id];
    _schedule = enabled?.schedule ?? widget.candidate.defaultSchedule;
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
                  label: Text(option),
                  selected: _schedule == option,
                  onSelected: (_) => setState(() => _schedule = option),
                ),
            ],
          ),
          const SizedBox(height: 22),
          FilledButton.icon(
            onPressed: () {
              ref
                  .read(carePlanControllerProvider.notifier)
                  .enable(widget.candidate, _schedule);
              Navigator.pop(context);
            },
            icon: Icon(isEnabled ? Icons.save_rounded : Icons.add_task_rounded),
            label: Text(isEnabled ? '保存计划' : '确认开启'),
          ),
          const SizedBox(height: 8),
          if (isEnabled)
            TextButton(
              onPressed: () {
                ref
                    .read(carePlanControllerProvider.notifier)
                    .disable(widget.candidate.id);
                Navigator.pop(context);
              },
              child: const Text('关闭这个计划'),
            )
          else
            TextButton(
              onPressed: () {
                ref
                    .read(carePlanControllerProvider.notifier)
                    .dismiss(widget.candidate.id);
                Navigator.pop(context);
              },
              child: const Text('暂不需要，不再显示'),
            ),
        ],
      ),
    );
  }
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
  'nail' => Icons.content_cut_rounded,
  'ear' => Icons.hearing_rounded,
  _ => Icons.health_and_safety_outlined,
};

Color _containerColor(CarePlanCandidate candidate, ColorScheme colors) {
  return switch (candidate.source) {
    CareSuggestionSource.profile => colors.primaryContainer,
    CareSuggestionSource.history => colors.secondaryContainer,
    CareSuggestionSource.event => colors.tertiaryContainer,
    CareSuggestionSource.general => colors.surfaceContainerHighest,
  };
}
