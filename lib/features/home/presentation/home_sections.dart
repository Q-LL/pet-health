import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../care/application/care_controller.dart';
import '../../care/application/care_coverage.dart';
import '../../care/application/care_recommendation.dart';
import '../../care/presentation/care_page.dart';
import '../../care/presentation/care_sheets.dart';
import '../../memories/data/memory_repository.dart';
import '../../memories/domain/memory_entry.dart';
import '../../records/data/health_record_repository.dart';
import '../../records/domain/health_record.dart';
import '../../records/presentation/add_record_sheet.dart';
import '../../../core/ui/ui.dart';

final homeWeightProvider = StreamProvider.autoDispose
    .family<List<HealthRecord>, String>(
      (ref, petId) => ref
          .watch(healthRecordRepositoryProvider)
          .watchForPet(petId, type: 'weight', limit: 1),
    );
final homeWaterProvider = StreamProvider.autoDispose
    .family<List<HealthRecord>, String>(
      (ref, petId) => ref
          .watch(healthRecordRepositoryProvider)
          .watchForPet(petId, type: 'water', limit: 1),
    );

final homeRecentRecordProvider = StreamProvider.autoDispose
    .family<List<HealthRecord>, String>(
      (ref, petId) => ref
          .watch(healthRecordRepositoryProvider)
          .watchForPet(petId, limit: 1),
    );
final homeMemoryProvider = StreamProvider.autoDispose
    .family<List<PetMemoryEntry>, String>(
      (ref, petId) =>
          ref.watch(memoryRepositoryProvider).watchForPet(petId, limit: 1),
    );
final homeThumbnailProvider = FutureProvider.autoDispose
    .family<Uint8List?, String>(
      (ref, asset) => ref
          .watch(albumAssetServiceProvider)
          .requestThumbnail(asset, size: 512),
    );

class HomeWalkCard extends ConsumerStatefulWidget {
  const HomeWalkCard({super.key});
  @override
  ConsumerState<HomeWalkCard> createState() => _HomeWalkCardState();
}

class _HomeWalkCardState extends ConsumerState<HomeWalkCard> {
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(careControllerProvider);
    final active = state.activeWalkStartedAt != null;
    final colors = Theme.of(context).colorScheme;
    return SectionCard(
      color: colors.primaryContainer,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          const IconBadge(Icons.directions_walk_rounded),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              '一起出去走走',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          TextButton(
            onPressed: _saving ? null : () => _act(active),
            child: Text(active ? '结束遛狗' : '一键开始遛狗'),
          ),
        ],
      ),
    );
  }

  Future<void> _act(bool active) async {
    setState(() => _saving = true);
    try {
      if (active) {
        await showFinishWalkSheet(context);
      } else {
        await ref.read(careControllerProvider.notifier).startWalk();
        HapticFeedback.lightImpact();
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('遛狗状态更新失败，请重试')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

class HomeHealthPreview extends ConsumerWidget {
  const HomeHealthPreview({required this.petId, super.key});
  final String petId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weight = ref.watch(homeWeightProvider(petId));
    final latest = ref.watch(homeRecentRecordProvider(petId));
    final colors = Theme.of(context).colorScheme;
    return AppSection(
      title: '最近的变化',
      action: '健康动态',
      onTap: () => context.go(CareSegment.insight.location),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final items = [
                _Metric(
                  icon: Icons.monitor_weight_outlined,
                  title: '最近体重',
                  value: weight.hasError
                      ? '读取失败'
                      : weight.isLoading
                      ? '读取中'
                      : weight.value?.firstOrNull?.numericValue?.toString() ??
                            '还未记录',
                  unit: weight.value?.firstOrNull?.unit ?? '',
                  detail: weight.value?.firstOrNull == null
                      ? '记录每一点小变化'
                      : _date(weight.value!.first.occurredAt),
                  onTap: () => showHealthRecordSheet(context, type: 'weight'),
                ),
                _Metric(
                  icon: Icons.history_rounded,
                  title: '最近记录',
                  value: latest.hasError
                      ? '读取失败'
                      : latest.isLoading
                      ? '读取中'
                      : latest.value?.firstOrNull?.title ?? '等待第一笔',
                  detail: latest.value?.firstOrNull == null
                      ? '慢慢积累，清晰回顾'
                      : _date(latest.value!.first.occurredAt),
                  onTap: () => context.push('/records'),
                ),
              ];
              if (MediaQuery.textScalerOf(context).scale(16) > 23) {
                return Column(
                  children: [items[0], const SizedBox(height: 12), items[1]],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: items[0]),
                  const SizedBox(width: 12),
                  Expanded(child: items[1]),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.lock_outline_rounded,
                size: 13,
                color: colors.onSurfaceVariant,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  '每一笔真实记录，都安心留在本机。',
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.onSurfaceVariant,
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

class _Metric extends StatelessWidget {
  const _Metric({
    required this.icon,
    required this.title,
    required this.value,
    required this.detail,
    required this.onTap,
    this.unit = '',
  });
  final IconData icon;
  final String title, value, detail, unit;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: colors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(22),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 21, color: colors.primary),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(color: colors.onSurfaceVariant, fontSize: 12),
              ),
              const SizedBox(height: 6),
              Text(
                '$value${unit.isEmpty ? '' : ' $unit'}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 21,
                  height: 1.3,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                detail,
                style: TextStyle(color: colors.onSurfaceVariant, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeCareLinks extends ConsumerWidget {
  const HomeCareLinks({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coverage = ref.watch(careCoverageProvider);
    final recommendations = ref
        .watch(careRecommendationsProvider)
        .where((item) => item.isRecommended)
        .toList();
    return AppSection(
      title: '日常护理',
      child: SectionCard.rows(
        children: [
          ListRow(
            leading: const IconBadge(Icons.spa_outlined),
            title: '护理计划',
            subtitle: recommendations.isEmpty
                ? '按自己的节奏，安排日常照护'
                : '${recommendations.length} 项护理值得留意 · ${recommendations.first.plan.title}',
            onTap: () => context.go(CareSegment.plans.location),
          ),
          ListRow(
            leading: const IconBadge(Icons.donut_large_rounded),
            title: '本周覆盖率',
            subtitle: coverage.hasError
                ? '暂时无法读取，点击重试查看'
                : coverage.isLoading
                ? '正在读取护理记录'
                : coverage.value == null ||
                      coverage.value!.totalActivePlans == 0
                ? '开启计划后，在这里回顾完成情况'
                : '已完成 ${coverage.value!.completedThisWeek} 次 · ${(coverage.value!.weeklyRate * 100).round()}% 覆盖',
            onTap: () => context.push('/care/coverage'),
          ),
        ],
      ),
    );
  }
}

class HomeMemoryPreview extends ConsumerWidget {
  const HomeMemoryPreview({required this.petId, super.key});
  final String petId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memories = ref.watch(homeMemoryProvider(petId));
    final memory = memories.value?.firstOrNull;
    final media = memory?.media.firstOrNull;
    final thumbnail = media == null
        ? null
        : ref.watch(homeThumbnailProvider(media.platformRef)).value;
    return SectionCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      onTap: () => context.push('/memories'),
      child: Row(
        children: [
          if (thumbnail == null)
            const IconBadge(Icons.photo_library_outlined, size: 40)
          else
            ClipRRect(
              borderRadius: AppRadius.chipAll,
              child: Image.memory(
                thumbnail,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    const IconBadge(Icons.photo_library_outlined, size: 40),
              ),
            ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  memory == null
                      ? '爱宠时光'
                      : '最近时光 · ${_date(memory.occurredAt)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  memories.hasError
                      ? '时光暂时没有读到，点击再看看'
                      : memory?.note.isNotEmpty == true
                      ? memory!.note
                      : memory == null
                      ? '留下属于你们的第一段时光'
                      : '珍藏这段陪伴',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => context.push('/memories'),
            child: const Text('全部'),
          ),
        ],
      ),
    );
  }
}

class HomeSignalPreview extends ConsumerWidget {
  const HomeSignalPreview({required this.petId, super.key});
  final String petId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final water = ref.watch(homeWaterProvider(petId));
    final latest = water.value?.firstOrNull;
    final message = water.hasError
        ? '饮水记录暂时没有读到'
        : water.isLoading
        ? '正在读取记录'
        : latest == null
        ? '还没有饮水记录'
        : DateTime.now().difference(latest.occurredAt).inDays >= 3
        ? '最近 3 天没有饮水记录'
        : '最近饮水记录：${_date(latest.occurredAt)}';
    return SectionCard(
      color: Theme.of(context).colorScheme.primaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: ListRow(
        title: '健康信号',
        subtitle: message,
        leading: const IconBadge(Icons.water_drop_outlined),
        onTap: () => context.go(CareSegment.insight.location),
      ),
    );
  }
}

String _date(DateTime value) {
  final local = value.toLocal();
  return '${local.year}.${local.month.toString().padLeft(2, '0')}.${local.day.toString().padLeft(2, '0')}';
}
