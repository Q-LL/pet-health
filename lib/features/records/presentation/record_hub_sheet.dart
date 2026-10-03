import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ui/ui.dart';
import '../../care/application/care_controller.dart';
import '../../care/data/care_repository.dart';
import '../../care/domain/care_activity_filter.dart';
import '../../care/domain/care_activity_spec.dart';
import '../../pets/data/pet_repository.dart';
import '../data/health_record_repository.dart';
import '../domain/health_record_filter.dart';
import '../domain/health_record_spec.dart';
import 'record_sheet_components.dart';

typedef RecordIntent = ({String kind, String type});

/// Returns the chosen action before the caller opens its full-screen editor.
class RecordHubSheet extends ConsumerWidget {
  const RecordHubSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final petId = ref.watch(selectedPetIdProvider).value;
    final pet = ref
        .watch(petsProvider)
        .value
        ?.where((p) => p.id == petId)
        .firstOrNull;
    final walking =
        ref.watch(careControllerProvider).activeWalkStartedAt != null;
    final recent = <({RecordIntent intent, DateTime at})>[];
    if (petId != null) {
      final health =
          ref
              .watch(
                filteredHealthRecordsProvider(
                  HealthRecordFilter(petId: petId, limit: 8),
                ),
              )
              .value ??
          [];
      final care =
          ref
              .watch(
                filteredCareActivitiesProvider(
                  CareActivityFilter(petId: petId, limit: 8),
                ),
              )
              .value ??
          [];
      recent.addAll([
        for (final item in health)
          (intent: (kind: 'health', type: item.type), at: item.occurredAt),
        for (final item in care.where((item) => item.type != 'walk'))
          (intent: (kind: 'care', type: item.type), at: item.occurredAt),
      ]);
      recent.sort((a, b) => b.at.compareTo(a.at));
    }
    final recentTypes = recent
        .map((item) => item.intent)
        .toSet()
        .take(3)
        .toList();
    void select(String kind, String type) =>
        Navigator.pop(context, (kind: kind, type: type));

    Widget lifeAction(
      String label,
      IconData icon,
      VoidCallback onPressed,
      Color background,
      Color foreground,
    ) => Expanded(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.chipAll),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      child: AppContent(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '记录点什么',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                IconButton(
                  tooltip: '关闭记录中心',
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            Text(
              '${pet?.name ?? '当前狗狗'} · 时间默认现在',
              style: TextStyle(color: colors.onSurfaceVariant, fontSize: 12),
            ),
            if (recentTypes.isNotEmpty) ...[
              const SizedBox(height: 16),
              const SectionHeader('最近用过'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final intent in recentTypes)
                    ActionChip(
                      label: Text(
                        (intent.kind == 'health'
                                ? healthRecordLabels[intent.type]
                                : careActivityLabels[intent.type]) ??
                            '自定义',
                      ),
                      onPressed: () => select(intent.kind, intent.type),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 20),
            const SectionHeader('健康'),
            _TypeGrid(
              types: const [
                'weight',
                'food',
                'water',
                'elimination',
                'symptom',
                'medication',
                'vaccine',
                'deworming',
                'custom',
              ],
              health: true,
              onSelected: (type) => select('health', type),
            ),
            const SizedBox(height: 20),
            const SectionHeader('护理'),
            _TypeGrid(
              types: const [
                'bath',
                'oral',
                'combing',
                'styling',
                'nail',
                'ear',
                'eye',
                'paw',
                'environment',
                'custom',
              ],
              health: false,
              onSelected: (type) => select('care', type),
            ),
            const SizedBox(height: 20),
            const SectionHeader('生活'),
            Row(
              children: [
                lifeAction(
                  walking ? '结束遛狗' : '开始遛狗',
                  walking ? Icons.stop_rounded : Icons.timer_outlined,
                  () => select(walking ? 'finishWalk' : 'startWalk', 'walk'),
                  colors.primary,
                  colors.onPrimary,
                ),
                const SizedBox(width: 8),
                lifeAction(
                  '补记遛狗',
                  Icons.edit_outlined,
                  () => select('care', 'walk'),
                  colors.surfaceContainer,
                  colors.primary,
                ),
                const SizedBox(width: 8),
                lifeAction(
                  '写时光',
                  Icons.photo_library_outlined,
                  () => select('memory', 'memory'),
                  AppColors.of(context).apricot,
                  AppColors.of(context).onApricot,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeGrid extends StatelessWidget {
  const _TypeGrid({
    required this.types,
    required this.health,
    required this.onSelected,
  });
  final List<String> types;
  final bool health;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final columns =
          MediaQuery.textScalerOf(context).scale(14) > 20 ||
              constraints.maxWidth < 290
          ? 3
          : 5;
      final width = (constraints.maxWidth - 8 * (columns - 1)) / columns;
      final colors = Theme.of(context).colorScheme;
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final type in types)
            SizedBox(
              width: width,
              child: Material(
                color: colors.surfaceContainer,
                borderRadius: AppRadius.chipAll,
                child: InkWell(
                  borderRadius: AppRadius.chipAll,
                  onTap: () => onSelected(type),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 12,
                    ),
                    child: Column(
                      children: [
                        Icon(
                          health
                              ? healthRecordIcon(type)
                              : careRecordIcon(type),
                          size: 22,
                          color: colors.primary,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _label(type),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      );
    },
  );

  String _label(String type) => switch ((health, type)) {
    (_, 'custom') => '自定义',
    (false, 'oral') => '口腔',
    (false, 'nail') => '指甲',
    (false, 'ear') => '耳部',
    (false, 'eye') => '眼部',
    (false, 'paw') => '足爪',
    (false, 'environment') => '用品清洁',
    _ => (health ? healthRecordLabels[type] : careActivityLabels[type]) ?? type,
  };
}
