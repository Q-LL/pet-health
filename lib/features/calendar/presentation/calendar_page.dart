import 'package:flutter/material.dart';

import '../../../core/widgets/motion.dart';
import '../../../core/widgets/page_frame.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      title: '日历',
      subtitle: '按日期回顾健康记录和提醒。',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            children: [
              Expanded(
                child: _SummaryChip(
                  icon: Icons.check_circle_outline_rounded,
                  value: '0',
                  label: '已完成',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _SummaryChip(
                  icon: Icons.notifications_none_rounded,
                  value: '0',
                  label: '待提醒',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          PressableScale(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: CalendarDatePicker(
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2035),
                  onDateChanged: (_) {},
                ),
              ),
            ),
          ),
          const SizedBox(height: 22),
          const SectionHeader('当天时间线'),
          Card(
            color: Theme.of(
              context,
            ).colorScheme.secondaryContainer.withValues(alpha: .55),
            child: const Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(Icons.event_available_rounded, size: 34),
                  SizedBox(height: 12),
                  Text(
                    '这一天还没有记录',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  SizedBox(height: 5),
                  Text('新增内容后，会按照发生时间组成清晰的时间线。', textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Icon(icon, color: colors.primary),
          const SizedBox(width: 10),
          Text(value, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: colors.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}
