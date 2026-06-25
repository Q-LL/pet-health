import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/motion.dart';
import '../application/care_controller.dart';
import '../application/care_coverage.dart';
import '../application/care_plan_controller.dart';
import '../application/care_recommendation.dart';
import '../domain/care_models.dart';
import '../../records/presentation/add_record_sheet.dart';
import 'care_sheets.dart';

class CareOverview extends ConsumerWidget {
  const CareOverview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(careControllerProvider);
    final recommendations = ref.watch(careRecommendationsProvider);
    final coverage = ref.watch(careCoverageProvider);

    return Column(
      children: [
        if (recommendations.isNotEmpty) ...[
          _PlanRecommendationList(recommendations: recommendations),
          const SizedBox(height: 14),
        ],
        if (coverage.value != null && coverage.value!.totalActivePlans > 0) ...[
          _CareCoverageBadge(coverage: coverage.value!),
          const SizedBox(height: 14),
        ],
        _BathCard(record: state.lastBath),
        const SizedBox(height: 14),
        _WalkCard(state: state),
        const SizedBox(height: 14),
        _CareCenterLink(),
      ],
    );
  }
}

class _PlanRecommendationList extends ConsumerWidget {
  const _PlanRecommendationList({required this.recommendations});
  final List<CareRecommendation> recommendations;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    // 只显示推荐的计划（urgent + recommended）
    final recommended = recommendations.where((r) => r.isRecommended).toList();
    if (recommended.isEmpty) {
      return const SizedBox.shrink();
    }

    return Material(
      color: colors.surfaceContainer,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome_rounded, color: colors.primary),
                const SizedBox(width: 8),
                Text(
                  '推荐护理',
                  style: TextStyle(
                    color: colors.onSurface,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${recommended.length}',
                    style: TextStyle(
                      color: colors.onPrimaryContainer,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            for (var i = 0; i < recommended.take(3).length; i++) ...[
              _RecommendationTile(recommendation: recommended[i]),
              if (i < recommended.take(3).length - 1) const Divider(height: 16),
            ],
            if (recommended.length > 3) ...[
              const SizedBox(height: 8),
              Text(
                '还有 ${recommended.length - 3} 项推荐护理',
                style: TextStyle(color: colors.onSurfaceVariant, fontSize: 13),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RecommendationTile extends ConsumerWidget {
  const _RecommendationTile({required this.recommendation});
  final CareRecommendation recommendation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final isUrgent = recommendation.urgencyLevel == 'urgent';
    final tagColor = isUrgent ? colors.error : colors.tertiary;
    final tagText = isUrgent ? '尽快' : '推荐';

    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            _iconForCareType(recommendation.plan.careType),
            size: 20,
            color: colors.primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    recommendation.plan.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: tagColor.withValues(alpha: .15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      tagText,
                      style: TextStyle(
                        color: tagColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                recommendation.recommendationText,
                style: TextStyle(color: colors.onSurfaceVariant, fontSize: 12),
              ),
            ],
          ),
        ),
        FilledButton.tonalIcon(
          onPressed: () async {
            try {
              var completed = false;
              await showCareActivitySheet(
                context,
                type: recommendation.plan.careType,
                beforeSave: (draft) async {
                  await ref
                      .read(carePlanControllerProvider.notifier)
                      .logCompletionWithActivity(
                        recommendation.plan.candidateId,
                        activityDraft: draft,
                      );
                  completed = true;
                  return null;
                },
              );
              if (!context.mounted || !completed) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('已完成「${recommendation.plan.title}」')),
              );
            } catch (error) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('操作失败：$error')));
            }
          },
          icon: const Icon(Icons.check_rounded, size: 16),
          label: const Text('完成'),
        ),
      ],
    );
  }
}

class _CareCoverageBadge extends StatelessWidget {
  const _CareCoverageBadge({required this.coverage});
  final CareCoverage coverage;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final ratePercent = (coverage.weeklyRate * 100).round();

    Color badgeColor;
    String levelText;
    IconData levelIcon;
    switch (coverage.coverageLevel) {
      case 'excellent':
        badgeColor = colors.primary;
        levelText = '护理达人';
        levelIcon = Icons.emoji_events_rounded;
        break;
      case 'good':
        badgeColor = colors.tertiary;
        levelText = '状态良好';
        levelIcon = Icons.thumb_up_rounded;
        break;
      default:
        badgeColor = colors.onSurfaceVariant;
        levelText = '继续加油';
        levelIcon = Icons.fitness_center_rounded;
    }

    return Material(
      color: colors.surfaceContainer,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/home/care-coverage'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: .15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(levelIcon, color: badgeColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$levelText · 本周覆盖率 $ratePercent%',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '完成 ${coverage.completedThisWeek}/${coverage.expectedThisWeek} 项'
                      '${coverage.currentStreak > 0 ? ' · 连续达标 ${coverage.currentStreak} 周' : ''}',
                      style: TextStyle(
                        color: colors.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: colors.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

class _CareCenterLink extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () => context.push('/home/care-plans'),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.tune_rounded, size: 18, color: colors.onSurfaceVariant),
            const SizedBox(width: 6),
            Text(
              '护理计划',
              style: TextStyle(color: colors.onSurfaceVariant, fontSize: 14),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 12,
              color: colors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _BathCard extends StatelessWidget {
  const _BathCard({required this.record});

  final BathRecord? record;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final days = record == null
        ? null
        : DateTime.now().difference(record!.occurredAt).inDays.clamp(0, 9999);
    final when = days == null
        ? '还没有记录'
        : days == 0
        ? '今天'
        : '$days 天前';
    final place = record == null
        ? '记录时间和地点，之后一眼就能回想起来'
        : record!.place.isEmpty
        ? '没有填写洗澡地点'
        : record!.place;

    return PressableScale(
      child: Material(
        color: colors.secondaryContainer,
        borderRadius: BorderRadius.circular(28),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => showBathRecordSheet(context),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: colors.surface.withValues(alpha: .72),
                    borderRadius: BorderRadius.circular(19),
                  ),
                  child: Icon(Icons.bathtub_outlined, color: colors.secondary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '上一次洗澡 · $when',
                        style: TextStyle(
                          color: colors.onSecondaryContainer,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: colors.onSecondaryContainer,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              place,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: colors.onSecondaryContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.edit_outlined, color: colors.onSecondaryContainer),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WalkCard extends ConsumerWidget {
  const _WalkCard({required this.state});

  final CareState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final isWalking = state.activeWalkStartedAt != null;
    final elapsed = ref
        .watch(walkElapsedProvider)
        .when(
          data: (value) => value,
          error: (_, _) => Duration.zero,
          loading: () => Duration.zero,
        );

    return AnimatedContainer(
      duration: AppMotion.medium,
      curve: AppMotion.emphasized,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: isWalking ? colors.primary : colors.surfaceContainer,
        borderRadius: BorderRadius.circular(30),
      ),
      child: AnimatedSwitcher(
        duration: AppMotion.medium,
        switchInCurve: AppMotion.emphasized,
        switchOutCurve: Curves.easeInCubic,
        child: isWalking
            ? _ActiveWalk(key: const ValueKey('active-walk'), elapsed: elapsed)
            : _IdleWalk(
                key: const ValueKey('idle-walk'),
                lastWalk: state.lastWalk,
              ),
      ),
    );
  }
}

class _IdleWalk extends ConsumerWidget {
  const _IdleWalk({required this.lastWalk, super.key});

  final WalkRecord? lastWalk;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final detail = lastWalk == null
        ? '出门时点一下，回来后自动算好时长'
        : '上次 ${_formatWalkWindow(lastWalk!)}${lastWalk!.place.isEmpty ? '' : ' · ${lastWalk!.place}'}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: BorderRadius.circular(19),
              ),
              child: Icon(Icons.directions_walk_rounded, color: colors.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '准备去遛狗？',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    detail,
                    style: TextStyle(color: colors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        FilledButton.icon(
          onPressed: () =>
              ref.read(careControllerProvider.notifier).startWalk(),
          icon: const Icon(Icons.play_arrow_rounded),
          label: const Text('一键开始遛狗'),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.route_outlined,
              size: 16,
              color: colors.onSurfaceVariant,
            ),
            const SizedBox(width: 5),
            Text(
              'GPS 路线后续可选开启',
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: colors.onSurfaceVariant),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActiveWalk extends StatelessWidget {
  const _ActiveWalk({required this.elapsed, super.key});

  final Duration elapsed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: colors.onPrimary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colors.onPrimary.withValues(alpha: .45),
                    blurRadius: 0,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '正在遛狗',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: colors.onPrimary),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          formatDuration(elapsed),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: colors.onPrimary,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '已按实际开始时间持续计算',
          textAlign: TextAlign.center,
          style: TextStyle(color: colors.onPrimary.withValues(alpha: .78)),
        ),
        const SizedBox(height: 22),
        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: colors.surface,
            foregroundColor: colors.primary,
          ),
          onPressed: () => showFinishWalkSheet(context),
          icon: const Icon(Icons.stop_rounded),
          label: const Text('结束遛狗'),
        ),
      ],
    );
  }
}

String _formatWalkWindow(WalkRecord walk) {
  return '${_formatClock(walk.startedAt)}-${_formatClock(walk.endedAt)}（${walk.duration.inMinutes} 分钟）';
}

String _formatClock(DateTime date) {
  final local = date.toLocal();
  return '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
}

IconData _iconForCareType(String careType) => switch (careType) {
  'oral' => Icons.auto_fix_high_rounded,
  'paw' => Icons.pets_rounded,
  'bath' => Icons.bathtub_outlined,
  'combing' => Icons.brush_rounded,
  'nail' => Icons.content_cut_rounded,
  'ear' => Icons.hearing_rounded,
  'eye' => Icons.visibility_outlined,
  'styling' => Icons.content_cut_rounded,
  'environment' => Icons.cleaning_services_outlined,
  'deworming' => Icons.bug_report_outlined,
  _ => Icons.health_and_safety_outlined,
};
