import 'package:flutter/material.dart';

import '../../../core/widgets/motion.dart';

Future<void> showAddRecordSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    showDragHandle: true,
    isScrollControlled: true,
    sheetAnimationStyle: const AnimationStyle(
      duration: AppMotion.medium,
      reverseDuration: AppMotion.fast,
    ),
    builder: (context) => const _AddRecordSheet(),
  );
}

class _AddRecordSheet extends StatelessWidget {
  const _AddRecordSheet();

  @override
  Widget build(BuildContext context) {
    const records = [
      (Icons.monitor_weight_outlined, '体重'),
      (Icons.restaurant_outlined, '饮食 / 饮水'),
      (Icons.water_drop_outlined, '排泄'),
      (Icons.healing_outlined, '症状'),
      (Icons.medication_outlined, '用药'),
      (Icons.vaccines_outlined, '疫苗'),
      (Icons.bug_report_outlined, '驱虫'),
      (Icons.local_hospital_outlined, '就诊 / 复诊'),
      (Icons.bathtub_outlined, '洗澡护理'),
      (Icons.directions_walk_rounded, '遛狗'),
    ];

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 760),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('新增记录', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 6),
            Text(
              '选择本次要记录的内容',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 18),
            LayoutBuilder(
              builder: (context, constraints) => GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: constraints.maxWidth > 520 ? 4 : 2,
                  mainAxisExtent: 92,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: records.length,
                itemBuilder: (context, index) => PressableScale(
                  child: Material(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(20),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Icon(records[index].$1),
                            const SizedBox(width: 12),
                            Expanded(child: Text(records[index].$2)),
                            const Icon(Icons.chevron_right_rounded, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
