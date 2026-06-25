import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/page_frame.dart';
import '../application/care_coverage.dart';

class CareCoveragePage extends ConsumerWidget {
  const CareCoveragePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(careCoverageDetailProvider);
    return PageFrame(
      title: '护理完成率',
      child: detail.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text('读取完成率失败：$error'),
          ),
        ),
        data: (value) => _CoverageDetailView(detail: value),
      ),
    );
  }
}

class _CoverageDetailView extends StatelessWidget {
  const _CoverageDetailView({required this.detail});

  final CareCoverageDetail detail;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TabBar(
            tabs: [
              Tab(text: '本周待完成'),
              Tab(text: '趋势'),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 520,
            child: TabBarView(
              children: [
                _ThisWeekPanel(items: detail.thisWeek),
                _TrendPanel(
                  weekly: detail.weeklyPeriods,
                  monthly: detail.monthlyPeriods,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ThisWeekPanel extends StatelessWidget {
  const _ThisWeekPanel({required this.items});

  final List<CarePlanCoverageProgress> items;

  @override
  Widget build(BuildContext context) {
    final totalExpected = items.fold<int>(
      0,
      (sum, item) => sum + item.expected,
    );
    final totalCompleted = items.fold<int>(
      0,
      (sum, item) => sum + item.completed,
    );
    final remaining = items
        .where((item) => item.expected > 0 && item.remaining > 0)
        .toList();
    final completed = items
        .where((item) => item.expected > 0 && item.remaining == 0)
        .toList();
    if (items.isEmpty || totalExpected == 0) {
      return const _EmptyPanel(
        icon: Icons.event_available_outlined,
        title: '还没有开启固定护理计划',
        message: '开启计划后，这里会显示本周还差哪些护理没有完成。',
      );
    }
    return ListView(
      children: [
        _WeekSummaryCard(
          completed: totalCompleted,
          expected: totalExpected,
          remaining: remaining.fold<int>(
            0,
            (sum, item) => sum + item.remaining,
          ),
        ),
        const SizedBox(height: 14),
        if (remaining.isNotEmpty) ...[
          Text('还差这些', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          for (final item in remaining) ...[
            _ProgressCard(item: item),
            const SizedBox(height: 10),
          ],
        ] else
          const _EmptyPanel(
            icon: Icons.emoji_events_rounded,
            title: '本周护理已完成',
            message: '这一周的计划护理都完成了，可以在趋势里回看节奏。',
          ),
        if (completed.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text('已完成', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          for (final item in completed) ...[
            _ProgressCard(item: item, compact: true),
            const SizedBox(height: 10),
          ],
        ],
      ],
    );
  }
}

class _WeekSummaryCard extends StatelessWidget {
  const _WeekSummaryCard({
    required this.completed,
    required this.expected,
    required this.remaining,
  });

  final int completed;
  final int expected;
  final int remaining;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final rate = expected == 0 ? 0.0 : (completed / expected).clamp(0.0, 1.0);
    return Material(
      color: colors.primaryContainer,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.insights_rounded, color: colors.onPrimaryContainer),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    remaining == 0 ? '本周节奏很好' : '本周还差 $remaining 次护理',
                    style: TextStyle(
                      color: colors.onPrimaryContainer,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  '${(rate * 100).round()}%',
                  style: TextStyle(
                    color: colors.onPrimaryContainer,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: rate.toDouble(),
              backgroundColor: colors.surface.withValues(alpha: .45),
            ),
            const SizedBox(height: 8),
            Text(
              '已完成 $completed / $expected',
              style: TextStyle(color: colors.onPrimaryContainer),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.item, this.compact = false});

  final CarePlanCoverageProgress item;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: colors.surfaceContainer,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: colors.primaryContainer,
              foregroundColor: colors.onPrimaryContainer,
              child: const Icon(Icons.checklist_rounded),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.plan.title,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _progressText,
                    style: TextStyle(color: colors.onSurfaceVariant),
                  ),
                  if (!compact) ...[
                    const SizedBox(height: 8),
                    LinearProgressIndicator(value: item.rate),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _progressText {
    if (item.remaining == 0) {
      return '已完成 ${item.completed}/${item.expected}';
    }
    return '还差 ${item.remaining} 次 · 已完成 ${item.completed}/${item.expected}';
  }
}

class _TrendPanel extends StatelessWidget {
  const _TrendPanel({required this.weekly, required this.monthly});

  final List<CareCoveragePeriod> weekly;
  final List<CareCoveragePeriod> monthly;

  @override
  Widget build(BuildContext context) {
    if (weekly.isEmpty && monthly.isEmpty) {
      return const _EmptyPanel(
        icon: Icons.show_chart_rounded,
        title: '还没有趋势',
        message: '从开启护理计划后的第一周开始，这里才会沉淀真实完成率。',
      );
    }
    return ListView(
      children: [
        if (weekly.isNotEmpty) ...[
          _PeriodSection(title: '最近几周', periods: weekly),
          const SizedBox(height: 18),
        ],
        if (monthly.isNotEmpty)
          _PeriodSection(title: '最近几个月', periods: monthly),
      ],
    );
  }
}

class _PeriodSection extends StatelessWidget {
  const _PeriodSection({required this.title, required this.periods});

  final String title;
  final List<CareCoveragePeriod> periods;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        for (final period in periods) ...[
          Material(
            color: colors.surfaceContainer,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(period.label)),
                      _RateBadge(rate: period.rate),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(value: period.rate),
                  const SizedBox(height: 6),
                  Text(
                    _periodText(period),
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }

  String _periodText(CareCoveragePeriod period) {
    final remaining = (period.expected - period.completed)
        .clamp(0, period.expected)
        .toInt();
    if (remaining == 0) return '完成 ${period.completed}/${period.expected}，已达标';
    return '完成 ${period.completed}/${period.expected}，还差 $remaining 次';
  }
}

class _RateBadge extends StatelessWidget {
  const _RateBadge({required this.rate});

  final double rate;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final good = rate >= .8;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: good ? colors.primaryContainer : colors.secondaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '${(rate * 100).round()}%',
        style: TextStyle(
          color: good ? colors.onPrimaryContainer : colors.onSecondaryContainer,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _EmptyPanel extends StatelessWidget {
  const _EmptyPanel({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 42, color: colors.primary),
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
