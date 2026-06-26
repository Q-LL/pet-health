import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/page_frame.dart';
import '../application/health_dynamics_provider.dart';
import '../domain/health_dynamics.dart';
import '../domain/health_summary.dart';
import '../domain/health_tip.dart';

class HealthDynamicsPage extends ConsumerWidget {
  const HealthDynamicsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dynamics = ref.watch(healthDynamicsProvider);

    return PageFrame(
      title: '详细动态',
      subtitle: '基于体重、饮食、饮水、排泄、症状和护理记录生成的本地洞察。',
      child: dynamics.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _StateCard(
          icon: Icons.error_outline_rounded,
          title: '读取动态失败',
          message: '$error',
        ),
        data: (value) {
          if (!value.hasContent) {
            return const _StateCard(
              icon: Icons.insights_outlined,
              title: '还没有足够的数据',
              message: '持续记录体重、饮食、排泄和护理后，这里会展示更完整的健康变化。',
            );
          }
          return _DynamicsView(dynamics: value);
        },
      ),
    );
  }
}

class _DynamicsView extends StatelessWidget {
  const _DynamicsView({required this.dynamics});

  final HealthDynamics dynamics;

  @override
  Widget build(BuildContext context) {
    final priority = dynamics.priorityInsights.take(3).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _OverviewPanel(dynamics: dynamics),
        if (priority.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text('优先关注', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          for (final insight in priority) ...[
            _InsightCard(insight: insight, emphasized: true),
            const SizedBox(height: 12),
          ],
        ],
        const SizedBox(height: 8),
        Text('数据变化时间线', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        if (dynamics.insights.isEmpty)
          const _StateCard(
            icon: Icons.check_circle_outline_rounded,
            title: '目前没有明显波动',
            message: '继续保持记录，系统会在趋势变化时自动补充动态。',
          )
        else
          for (var i = 0; i < dynamics.insights.length; i++) ...[
            _TimelineInsight(
              insight: dynamics.insights[i],
              isLast: i == dynamics.insights.length - 1,
            ),
          ],
        if (dynamics.recommendations.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text('相关建议', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          for (final tip in dynamics.recommendations) ...[
            _TipRecommendation(tip: tip),
            const SizedBox(height: 10),
          ],
        ],
      ],
    );
  }
}

class _OverviewPanel extends StatelessWidget {
  const _OverviewPanel({required this.dynamics});

  final HealthDynamics dynamics;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final metrics = dynamics.summary.visibleMetrics.take(5).toList();
    final alertCount = dynamics.insights
        .where((item) => item.tone == 'alert')
        .length;
    final watchCount = dynamics.insights
        .where((item) => item.tone == 'watch')
        .length;

    return Material(
      color: colors.primaryContainer,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.auto_graph_rounded,
                  color: colors.onPrimaryContainer,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    dynamics.petName.isEmpty
                        ? '健康动态'
                        : '${dynamics.petName} 的健康动态',
                    style: TextStyle(
                      color: colors.onPrimaryContainer,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              alertCount > 0
                  ? '发现 $alertCount 个高优先级信号，建议先处理优先关注里的项目。'
                  : watchCount > 0
                  ? '有 $watchCount 个变化值得继续观察，当前没有明显高风险信号。'
                  : '整体变化平稳，继续保持记录和护理节奏。',
              style: TextStyle(
                color: colors.onPrimaryContainer.withValues(alpha: .82),
                height: 1.45,
              ),
            ),
            if (metrics.isNotEmpty) ...[
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final metric in metrics) _MetricPill(metric: metric),
                ],
              ),
            ],
            if (dynamics.summary.crossInsight != null) ...[
              const SizedBox(height: 14),
              Text(
                dynamics.summary.crossInsight!,
                style: TextStyle(
                  color: colors.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                  height: 1.45,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MetricPill extends StatelessWidget {
  const _MetricPill({required this.metric});

  final MetricItem metric;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final color = metric.trendColor(
      colors,
      positiveIsGood: metric.positiveTrend,
    );
    return Container(
      width: 126,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: .58),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            metric.label,
            style: TextStyle(
              color: colors.onPrimaryContainer.withValues(alpha: .7),
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            metric.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: colors.onPrimaryContainer,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Icon(metric.trendIcon(), size: 14, color: color),
              const SizedBox(width: 2),
              Expanded(
                child: Text(
                  metric.comparison,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimelineInsight extends StatelessWidget {
  const _TimelineInsight({required this.insight, required this.isLast});

  final HealthDynamicInsight insight;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final accent = _toneColor(insight.tone, colors);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 34,
            child: Column(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: accent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _categoryIcon(insight.category),
                    color: colors.onPrimary,
                    size: 15,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: colors.outlineVariant,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
              child: _InsightCard(insight: insight),
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({required this.insight, this.emphasized = false});

  final HealthDynamicInsight insight;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final accent = _toneColor(insight.tone, colors);
    return Material(
      color: emphasized
          ? accent.withValues(alpha: .12)
          : colors.surfaceContainer,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_categoryIcon(insight.category), size: 18, color: accent),
                const SizedBox(width: 8),
                Text(
                  _categoryLabel(insight.category),
                  style: TextStyle(
                    color: accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Text(
                  _dateLabel(insight.occurredAt),
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              insight.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              insight.body,
              style: TextStyle(color: colors.onSurfaceVariant, height: 1.45),
            ),
            const SizedBox(height: 10),
            Text(
              insight.suggestion,
              style: TextStyle(
                color: colors.onSurface,
                fontWeight: FontWeight.w600,
                height: 1.45,
              ),
            ),
            if (insight.evidence.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final item in insight.evidence)
                    Chip(
                      label: Text(item),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TipRecommendation extends StatelessWidget {
  const _TipRecommendation({required this.tip});

  final HealthTip tip;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: colors.surfaceContainer,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: colors.secondaryContainer,
              foregroundColor: colors.onSecondaryContainer,
              child: Icon(tip.icon, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tip.title,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tip.body,
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tip.reason,
                    style: TextStyle(
                      color: colors.onSurfaceVariant.withValues(alpha: .72),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StateCard extends StatelessWidget {
  const _StateCard({
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
    return Material(
      color: colors.surfaceContainer,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(icon, color: colors.onSurfaceVariant),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color _toneColor(String tone, ColorScheme colors) {
  return switch (tone) {
    'alert' => colors.error,
    'watch' => colors.tertiary,
    'positive' => colors.primary,
    _ => colors.secondary,
  };
}

IconData _categoryIcon(String category) {
  return switch (category) {
    'weight' => Icons.monitor_weight_outlined,
    'diet' => Icons.restaurant_outlined,
    'water' => Icons.water_drop_outlined,
    'elimination' => Icons.eco_outlined,
    'symptom' => Icons.healing_outlined,
    'care' => Icons.checklist_rounded,
    'preventive' => Icons.verified_outlined,
    'data_quality' => Icons.edit_note_rounded,
    'positive' => Icons.favorite_border_rounded,
    _ => Icons.insights_rounded,
  };
}

String _categoryLabel(String category) {
  return switch (category) {
    'weight' => '体重',
    'diet' => '饮食消化',
    'water' => '饮水',
    'elimination' => '排泄',
    'symptom' => '症状',
    'care' => '护理',
    'preventive' => '预防',
    'data_quality' => '记录质量',
    'positive' => '保持良好',
    _ => '动态',
  };
}

String _dateLabel(DateTime date) => '${date.month}/${date.day}';
