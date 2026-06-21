import 'package:flutter/material.dart';

import '../../../core/widgets/page_frame.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      title: '日历',
      subtitle: '按日期回顾健康记录和提醒。',
      child: Column(
        children: [
          Card(
            child: CalendarDatePicker(
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2035),
              onDateChanged: (_) {},
            ),
          ),
          const SizedBox(height: 20),
          const SectionHeader('当天时间线'),
          const Card(
            child: ListTile(
              contentPadding: EdgeInsets.all(20),
              leading: Icon(Icons.event_available_rounded),
              title: Text('这一天还没有记录'),
              subtitle: Text('新增内容后会按发生时间排列。'),
            ),
          ),
        ],
      ),
    );
  }
}
