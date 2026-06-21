import 'package:flutter/material.dart';

Future<void> showAddRecordSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    showDragHandle: true,
    isScrollControlled: true,
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
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: .9,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: records.length,
              itemBuilder: (context, index) => InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => Navigator.pop(context),
                child: Ink(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(records[index].$1),
                      const SizedBox(height: 8),
                      Text(records[index].$2, textAlign: TextAlign.center),
                    ],
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
