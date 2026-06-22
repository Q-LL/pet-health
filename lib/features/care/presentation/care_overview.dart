import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/motion.dart';
import '../application/care_controller.dart';
import '../domain/care_models.dart';
import 'care_sheets.dart';

class CareOverview extends ConsumerWidget {
  const CareOverview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(careControllerProvider);
    return Column(
      children: [
        _BathCard(record: state.lastBath),
        const SizedBox(height: 14),
        _WalkCard(state: state),
      ],
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
        gradient: isWalking
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [colors.primary, colors.tertiary],
              )
            : null,
        color: isWalking ? null : colors.surfaceContainer,
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
        : '上次 ${formatDuration(lastWalk!.duration)}${lastWalk!.place.isEmpty ? '' : ' · ${lastWalk!.place}'}';
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
