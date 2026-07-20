import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/motion.dart';
import '../../care/application/care_controller.dart';
import '../../care/presentation/care_sheets.dart';
import '../../records/presentation/add_record_sheet.dart';
import '../../settings/data/app_settings_repository.dart';

class HomeQuickActions extends ConsumerWidget {
  const HomeQuickActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final isWalking = ref.watch(
      careControllerProvider.select(
        (state) => state.activeWalkStartedAt != null,
      ),
    );
    final selectedIds =
        ref.watch(quickActionIdsProvider).value ?? defaultQuickActionIds;
    final actions = [
      for (final id in selectedIds)
        _quickActionForId(
          context,
          ref,
          id,
          isWalking: isWalking,
          colors: colors,
        ),
      _quickActionForId(
        context,
        ref,
        fixedMoreRecordActionId,
        isWalking: isWalking,
        colors: colors,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 420;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: compact ? 2 : 4,
            mainAxisExtent: 104,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            return PressableScale(
              child: Material(
                color: action.color,
                borderRadius: BorderRadius.circular(24),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: action.action,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(action.icon, color: action.onColor, size: 26),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                action.label,
                                style: TextStyle(
                                  color: action.onColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.add_rounded,
                              color: action.onColor,
                              size: 18,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

({IconData icon, String label, Color color, Color onColor, VoidCallback action})
_quickActionForId(
  BuildContext context,
  WidgetRef ref,
  String id, {
  required bool isWalking,
  required ColorScheme colors,
}) {
  return switch (id) {
    'health:water' => _healthAction(
      context,
      colors,
      type: 'water',
      icon: Icons.water_drop_rounded,
      label: '饮水',
    ),
    'health:elimination' => _healthAction(
      context,
      colors,
      type: 'elimination',
      icon: Icons.wc_outlined,
      label: '排泄',
    ),
    'health:symptom' => _healthAction(
      context,
      colors,
      type: 'symptom',
      icon: Icons.healing_outlined,
      label: '症状',
    ),
    'health:food' => _healthAction(
      context,
      colors,
      type: 'food',
      icon: Icons.restaurant_outlined,
      label: '喂食',
    ),
    'health:medication' => _healthAction(
      context,
      colors,
      type: 'medication',
      icon: Icons.medication_outlined,
      label: '用药',
    ),
    'health:vaccine' => _healthAction(
      context,
      colors,
      type: 'vaccine',
      icon: Icons.vaccines_outlined,
      label: '疫苗',
    ),
    'health:deworming' => _healthAction(
      context,
      colors,
      type: 'deworming',
      icon: Icons.bug_report_outlined,
      label: '驱虫',
    ),
    'health:custom' => _healthAction(
      context,
      colors,
      icon: Icons.note_add_outlined,
      label: '自定义健康',
    ),
    'care:bath' => (
      icon: Icons.bathtub_outlined,
      label: '洗澡',
      color: colors.secondaryContainer,
      onColor: colors.onSecondaryContainer,
      action: () => showBathRecordSheet(context),
    ),
    'care:oral' => _careAction(
      context,
      colors,
      type: 'oral',
      icon: Icons.medical_services_outlined,
      label: '口腔护理',
    ),
    'care:combing' => _careAction(
      context,
      colors,
      type: 'combing',
      icon: Icons.brush_outlined,
      label: '梳毛',
    ),
    'care:styling' => _careAction(
      context,
      colors,
      type: 'styling',
      icon: Icons.content_cut_rounded,
      label: '美容',
    ),
    'care:nail' => _careAction(
      context,
      colors,
      type: 'nail',
      icon: Icons.back_hand_outlined,
      label: '指甲护理',
    ),
    'care:ear' => _careAction(
      context,
      colors,
      type: 'ear',
      icon: Icons.hearing_outlined,
      label: '耳部护理',
    ),
    'care:eye' => _careAction(
      context,
      colors,
      type: 'eye',
      icon: Icons.visibility_outlined,
      label: '眼部护理',
    ),
    'care:paw' => _careAction(
      context,
      colors,
      type: 'paw',
      icon: Icons.pets_outlined,
      label: '足爪护理',
    ),
    'care:environment' => _careAction(
      context,
      colors,
      type: 'environment',
      icon: Icons.cleaning_services_outlined,
      label: '环境清洁',
    ),
    'care:walk' => (
      icon: Icons.directions_walk_rounded,
      label: isWalking ? '结束遛狗' : '快速遛狗',
      color: colors.tertiaryContainer,
      onColor: colors.onTertiaryContainer,
      action: () {
        if (isWalking) {
          showFinishWalkSheet(context);
        } else {
          ref.read(careControllerProvider.notifier).startWalk();
        }
      },
    ),
    'care:custom' => _careAction(
      context,
      colors,
      icon: Icons.spa_outlined,
      label: '自定义护理',
    ),
    'more:records' => (
      icon: Icons.grid_view_rounded,
      label: '更多记录',
      color: colors.surfaceContainerHigh,
      onColor: colors.onSurface,
      action: () => showAddRecordSheet(context),
    ),
    _ => _healthAction(
      context,
      colors,
      type: 'weight',
      icon: Icons.monitor_weight_outlined,
      label: '体重',
    ),
  };
}

({IconData icon, String label, Color color, Color onColor, VoidCallback action})
_healthAction(
  BuildContext context,
  ColorScheme colors, {
  String? type,
  required IconData icon,
  required String label,
}) => (
  icon: icon,
  label: label,
  color: colors.primaryContainer,
  onColor: colors.onPrimaryContainer,
  action: type == null
      ? () => showHealthRecordSheet(context)
      : () => showHealthRecordSheet(context, type: type),
);

({IconData icon, String label, Color color, Color onColor, VoidCallback action})
_careAction(
  BuildContext context,
  ColorScheme colors, {
  String? type,
  required IconData icon,
  required String label,
}) => (
  icon: icon,
  label: label,
  color: colors.secondaryContainer,
  onColor: colors.onSecondaryContainer,
  action: type == null
      ? () => showCareActivitySheet(context)
      : () => showCareActivitySheet(context, type: type),
);
