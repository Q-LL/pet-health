import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/ui/ui.dart';
import '../../reminders/presentation/reminder_editor.dart';
import 'care_plans_page.dart';
import 'care_todo_body.dart';

enum CareSegment {
  todo('todo', '待办'),
  plans('plans', '计划'),
  insight('insight', '洞察');

  const CareSegment(this.query, this.label);

  final String query;
  final String label;

  static CareSegment fromQuery(String? value) => CareSegment.values.firstWhere(
    (segment) => segment.query == value,
    orElse: () => todo,
  );

  String get location => '/care?seg=$query';
}

/// The 照护 tab: reminders, care plans and insights in one place.
class CarePage extends StatefulWidget {
  const CarePage({this.segment = CareSegment.todo, super.key});

  final CareSegment segment;

  @override
  State<CarePage> createState() => _CarePageState();
}

class _CarePageState extends State<CarePage> {
  late var _segment = widget.segment;

  /// Segments are built on first visit and kept alive afterwards.
  late final _visited = {widget.segment};

  @override
  void didUpdateWidget(CarePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.segment != oldWidget.segment) _select(widget.segment);
  }

  void _select(CareSegment segment) => setState(() {
    _segment = segment;
    _visited.add(segment);
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppContent(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.page,
              AppSpacing.sm,
              AppSpacing.sm + 4,
              0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text('照护', style: theme.textTheme.headlineMedium),
                  ),
                ),
                IconButton(
                  tooltip: '搜索知识库',
                  onPressed: () => context.push('/knowledge'),
                  icon: const Icon(Icons.search_rounded),
                ),
                IconButton.filledTonal(
                  tooltip: '新增提醒',
                  onPressed: () => showReminderSheet(context),
                  icon: const Icon(Icons.add_alarm_rounded),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppContent(
            child: SegmentedButton<CareSegment>(
              showSelectedIcon: false,
              segments: [
                for (final segment in CareSegment.values)
                  ButtonSegment(value: segment, label: Text(segment.label)),
              ],
              selected: {_segment},
              onSelectionChanged: (selection) =>
                  context.go(selection.single.location),
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _segment.index,
              children: [
                for (final segment in CareSegment.values)
                  _visited.contains(segment)
                      ? TickerMode(
                          enabled: segment == _segment,
                          child: _SegmentBody(segment: segment),
                        )
                      : const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentBody extends StatelessWidget {
  const _SegmentBody({required this.segment});

  final CareSegment segment;

  @override
  Widget build(BuildContext context) {
    final content = switch (segment) {
      CareSegment.todo => const CareTodoBody(),
      CareSegment.plans => const CarePlansPage(),
      CareSegment.insight => const _InsightsOverview(),
    };
    return SingleChildScrollView(
      key: PageStorageKey('care-${segment.query}'),
      padding: const EdgeInsets.only(
        top: AppSpacing.page,
        bottom: AppSpacing.navClearance,
      ),
      child: AppContent(
        child: AppPageEmbed(
          showTitle: segment == CareSegment.insight,
          child: content,
        ),
      ),
    );
  }
}

class _InsightsOverview extends StatelessWidget {
  const _InsightsOverview();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SectionHeader('看懂每一点变化'),
      SectionCard.rows(
        children: [
          ListRow(
            title: '健康动态',
            subtitle: '体重、饮食、饮水与症状的近期变化',
            leading: const IconBadge(Icons.insights_outlined),
            onTap: () => context.push('/care/dynamics'),
          ),
          ListRow(
            title: '护理完成率',
            subtitle: '本周进度，以及每周、每月的护理趋势',
            leading: const IconBadge(Icons.donut_large_rounded),
            onTap: () => context.push('/care/coverage'),
          ),
        ],
      ),
    ],
  );
}
