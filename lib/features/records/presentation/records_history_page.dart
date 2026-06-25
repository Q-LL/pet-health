import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/page_frame.dart';
import '../../care/data/care_repository.dart';
import '../../care/domain/care_activity_filter.dart';
import '../../care/domain/care_activity_spec.dart';
import '../../care/domain/care_models.dart';
import '../../pets/data/pet_repository.dart';
import '../data/health_record_repository.dart';
import '../domain/health_record.dart';
import '../domain/health_record_filter.dart';
import '../domain/health_record_spec.dart';
import 'add_record_sheet.dart';

const _pageStep = 20;

enum _RecordFilter { all, health, care }

class RecordsHistoryPage extends ConsumerStatefulWidget {
  const RecordsHistoryPage({super.key});

  @override
  ConsumerState<RecordsHistoryPage> createState() => _RecordsHistoryPageState();
}

class _RecordsHistoryPageState extends ConsumerState<RecordsHistoryPage> {
  var _filter = _RecordFilter.all;
  var _keyword = '';
  String? _healthType;
  String? _careType;
  var _limit = _pageStep;

  String? get _searchKeyword =>
      _keyword.trim().isEmpty ? null : _keyword.trim();

  void _resetLimit() => _limit = _pageStep;

  @override
  Widget build(BuildContext context) {
    final petId = ref.watch(selectedPetIdProvider).value;

    final healthFilter = petId == null
        ? null
        : HealthRecordFilter(
            petId: petId,
            type: _filter == _RecordFilter.health ? _healthType : null,
            keyword: _searchKeyword,
            limit: _limit,
          );
    final careFilter = petId == null
        ? null
        : CareActivityFilter(
            petId: petId,
            type: _filter == _RecordFilter.care ? _careType : null,
            keyword: _searchKeyword,
            limit: _limit,
          );

    final health = healthFilter == null
        ? const AsyncValue<List<HealthRecord>>.loading()
        : ref.watch(filteredHealthRecordsProvider(healthFilter));
    final care = careFilter == null
        ? const AsyncValue<List<CareActivity>>.loading()
        : ref.watch(filteredCareActivitiesProvider(careFilter));

    return PageFrame(
      title: '历史记录',
      actions: [
        IconButton.filledTonal(
          tooltip: '返回日历',
          onPressed: () => context.go('/calendar'),
          icon: const Icon(Icons.calendar_month_rounded),
        ),
        const SizedBox(width: 12),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: '搜索标题、备注、地点…',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _keyword.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () {
                        setState(() {
                          _keyword = '';
                          _resetLimit();
                        });
                      },
                    )
                  : null,
            ),
            onChanged: (value) => setState(() {
              _keyword = value;
              _resetLimit();
            }),
          ),
          const SizedBox(height: 12),
          SegmentedButton<_RecordFilter>(
            segments: const [
              ButtonSegment(
                value: _RecordFilter.all,
                label: Text('全部'),
                icon: Icon(Icons.all_inbox_rounded),
              ),
              ButtonSegment(
                value: _RecordFilter.health,
                label: Text('健康'),
                icon: Icon(Icons.favorite_outline_rounded),
              ),
              ButtonSegment(
                value: _RecordFilter.care,
                label: Text('护理'),
                icon: Icon(Icons.spa_outlined),
              ),
            ],
            selected: {_filter},
            onSelectionChanged: (value) => setState(() {
              _filter = value.single;
              _resetLimit();
            }),
          ),
          if (_filter == _RecordFilter.health) ...[
            const SizedBox(height: 12),
            _TypeFilterDropdown(
              label: '记录类型',
              allLabel: '全部健康记录',
              labels: healthRecordLabels,
              value: _healthType,
              onChanged: (value) => setState(() {
                _healthType = value;
                _resetLimit();
              }),
            ),
          ],
          if (_filter == _RecordFilter.care) ...[
            const SizedBox(height: 12),
            _TypeFilterDropdown(
              label: '护理类型',
              allLabel: '全部护理记录',
              labels: careActivityLabels,
              value: _careType,
              onChanged: (value) => setState(() {
                _careType = value;
                _resetLimit();
              }),
            ),
          ],
          const SizedBox(height: 16),
          _HistoryList(
            filter: _filter,
            health: health,
            care: care,
            limit: _limit,
            onLoadMore: () => setState(() => _limit += _pageStep),
          ),
        ],
      ),
    );
  }
}

class _TypeFilterDropdown extends StatelessWidget {
  const _TypeFilterDropdown({
    required this.label,
    required this.allLabel,
    required this.labels,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String allLabel;
  final Map<String, String> labels;
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String?>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.filter_list_rounded),
      ),
      items: [
        DropdownMenuItem<String?>(value: null, child: Text(allLabel)),
        for (final entry in labels.entries)
          DropdownMenuItem<String?>(value: entry.key, child: Text(entry.value)),
      ],
      onChanged: onChanged,
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList({
    required this.filter,
    required this.health,
    required this.care,
    required this.limit,
    required this.onLoadMore,
  });

  final _RecordFilter filter;
  final AsyncValue<List<HealthRecord>> health;
  final AsyncValue<List<CareActivity>> care;
  final int limit;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    final loading =
        (filter != _RecordFilter.care && health.isLoading) ||
        (filter != _RecordFilter.health && care.isLoading);
    if (loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(36),
          child: CircularProgressIndicator(),
        ),
      );
    }

    final error = filter == _RecordFilter.health
        ? health.error
        : filter == _RecordFilter.care
        ? care.error
        : health.error ?? care.error;
    if (error != null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text('读取历史记录失败：$error'),
        ),
      );
    }

    final entries = <_HistoryEntry>[
      if (filter != _RecordFilter.care)
        for (final record in health.value ?? const <HealthRecord>[])
          _HistoryEntry.health(record),
      if (filter != _RecordFilter.health)
        for (final activity in care.value ?? const <CareActivity>[])
          _HistoryEntry.care(activity),
    ]..sort((a, b) => b.sortTime.compareTo(a.sortTime));

    if (entries.isEmpty) {
      return Card(
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: const Padding(
          padding: EdgeInsets.all(28),
          child: Column(
            children: [
              Icon(Icons.list_alt_rounded, size: 36),
              SizedBox(height: 12),
              Text(
                '没有匹配的记录',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
              SizedBox(height: 6),
              Text('尝试更换关键词或筛选条件，或新增一条记录。'),
            ],
          ),
        ),
      );
    }

    final sections = _groupByDay(entries);

    // 判断是否还有更多数据可加载
    final healthCount = health.value?.length ?? 0;
    final careCount = care.value?.length ?? 0;
    final showLoadMore =
        (filter != _RecordFilter.care && healthCount >= limit) ||
        (filter != _RecordFilter.health && careCount >= limit);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _HistorySummary(entries: entries),
        const SizedBox(height: 12),
        for (final section in sections) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 14, 4, 8),
            child: Text(
              _formatDayHeader(section.day),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Card(
            child: Column(
              children: [
                for (
                  var index = 0;
                  index < section.entries.length;
                  index++
                ) ...[
                  _HistoryTile(entry: section.entries[index]),
                  if (index < section.entries.length - 1)
                    const Divider(height: 1),
                ],
              ],
            ),
          ),
        ],
        if (showLoadMore) ...[
          const SizedBox(height: 16),
          Center(
            child: FilledButton.tonalIcon(
              onPressed: onLoadMore,
              icon: const Icon(Icons.expand_more_rounded),
              label: const Text('加载更多'),
            ),
          ),
        ],
      ],
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.entry});

  final _HistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      onTap: () => _showRecordDetail(context, entry),
      leading: CircleAvatar(
        backgroundColor: entry.isHealth
            ? colors.primaryContainer
            : colors.tertiaryContainer,
        foregroundColor: entry.isHealth
            ? colors.onPrimaryContainer
            : colors.onTertiaryContainer,
        child: Icon(entry.icon, size: 20),
      ),
      title: Text(
        entry.title,
        style: const TextStyle(fontWeight: FontWeight.w800),
      ),
      subtitle: entry.subtitle.isEmpty ? null : Text(entry.subtitle),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            entry.trailing,
            style: TextStyle(color: colors.onSurfaceVariant, fontSize: 12),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}

class _HistorySummary extends StatelessWidget {
  const _HistorySummary({required this.entries});

  final List<_HistoryEntry> entries;

  @override
  Widget build(BuildContext context) {
    final healthCount = entries.where((entry) => entry.isHealth).length;
    final careCount = entries.length - healthCount;
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _CountPill(
          icon: Icons.all_inbox_rounded,
          label: '全部 ${entries.length}',
        ),
        _CountPill(
          icon: Icons.favorite_outline_rounded,
          label: '健康 $healthCount',
        ),
        _CountPill(icon: Icons.spa_outlined, label: '护理 $careCount'),
      ],
    );
  }
}

class _CountPill extends StatelessWidget {
  const _CountPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: colors.primary),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }
}

class _RecordDetailSheet extends ConsumerWidget {
  const _RecordDetailSheet({required this.pageContext, required this.entry});

  final BuildContext pageContext;
  final _HistoryEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          20,
          4,
          20,
          24 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: colors.primaryContainer,
                  foregroundColor: colors.onPrimaryContainer,
                  child: Icon(entry.icon),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_formatDayHeader(_startOfDay(entry.sortTime.toLocal()))} · ${entry.trailing}',
                        style: TextStyle(color: colors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            if (entry.subtitle.isNotEmpty)
              _InfoRow(label: '摘要', value: entry.subtitle),
            if (entry.note.isNotEmpty) _InfoRow(label: '备注', value: entry.note),
            if (entry.place.isNotEmpty)
              _InfoRow(label: '地点', value: entry.place),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      if (!pageContext.mounted) return;
                      if (entry.health != null) {
                        showHealthRecordSheet(
                          pageContext,
                          type: entry.health!.type,
                          record: entry.health,
                        );
                      } else {
                        showCareActivitySheet(
                          pageContext,
                          type: entry.care!.type,
                          activity: entry.care,
                        );
                      }
                    },
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('编辑'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: () =>
                        _deleteFromDetail(context, pageContext, ref),
                    icon: const Icon(Icons.delete_outline_rounded),
                    label: const Text('删除'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteFromDetail(
    BuildContext sheetContext,
    BuildContext pageContext,
    WidgetRef ref,
  ) async {
    final healthRepository = ref.read(healthRecordRepositoryProvider);
    final careRepository = ref.read(careRepositoryProvider);
    Navigator.pop(sheetContext);
    if (!pageContext.mounted) return;
    final confirmed = await showDialog<bool>(
      context: pageContext,
      builder: (context) => AlertDialog(
        title: Text('删除「${entry.title}」？'),
        content: const Text('删除后会从本机档案移除，此操作无法撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('确认删除'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      final deleted = entry.health != null
          ? await healthRepository.delete(entry.health!.id)
          : await careRepository.delete(entry.care!.id);
      if (!pageContext.mounted) return;
      ScaffoldMessenger.of(
        pageContext,
      ).showSnackBar(SnackBar(content: Text(deleted ? '已删除记录' : '这条记录已经不存在')));
    } on Object catch (error) {
      if (!pageContext.mounted) return;
      ScaffoldMessenger.of(
        pageContext,
      ).showSnackBar(SnackBar(content: Text('删除失败：$error')));
    }
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: colors.onSurfaceVariant)),
            const SizedBox(height: 4),
            Text(value),
          ],
        ),
      ),
    );
  }
}

class _HistoryEntry {
  const _HistoryEntry._({this.health, this.care});

  factory _HistoryEntry.health(HealthRecord record) =>
      _HistoryEntry._(health: record);

  factory _HistoryEntry.care(CareActivity activity) =>
      _HistoryEntry._(care: activity);

  final HealthRecord? health;
  final CareActivity? care;

  bool get isHealth => health != null;

  DateTime get sortTime =>
      health?.occurredAt ?? care!.startedAt ?? care!.occurredAt;

  IconData get icon =>
      health == null ? _careIcon(care!.type) : _healthIcon(health!.type);

  String get title {
    final record = health;
    if (record != null) return record.title;
    final activity = care!;
    if (activity.type == 'walk') return _formatWalkWindow(activity);
    return careActivityLabels[activity.type] ?? '护理记录';
  }

  String get subtitle {
    final record = health;
    if (record != null) {
      return [
        healthRecordLabels[record.type],
        if (record.numericValue != null)
          '${record.numericValue} ${record.unit ?? ''}'.trim(),
        if (record.severity != null) '严重程度 ${record.severity}',
      ].whereType<String>().join(' · ');
    }
    final activity = care!;
    return [
      if (activity.type != 'walk') careActivityLabels[activity.type],
      if (activity.type == 'walk' && activity.place.isNotEmpty) activity.place,
      if (activity.type != 'walk' && activity.place.isNotEmpty) activity.place,
    ].whereType<String>().join(' · ');
  }

  String get trailing {
    final activity = care;
    if (activity?.type == 'walk') return '遛狗';
    return _formatTime(sortTime);
  }

  String get note => health?.note ?? care?.note ?? '';

  String get place => care?.place ?? '';
}

class _HistorySection {
  const _HistorySection({required this.day, required this.entries});

  final DateTime day;
  final List<_HistoryEntry> entries;
}

void _showRecordDetail(BuildContext pageContext, _HistoryEntry entry) {
  showModalBottomSheet<void>(
    context: pageContext,
    useSafeArea: true,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _RecordDetailSheet(pageContext: pageContext, entry: entry),
  );
}

List<_HistorySection> _groupByDay(List<_HistoryEntry> entries) {
  final sections = <_HistorySection>[];
  for (final entry in entries) {
    final day = _startOfDay(entry.sortTime.toLocal());
    if (sections.isEmpty || sections.last.day != day) {
      sections.add(_HistorySection(day: day, entries: [entry]));
    } else {
      sections.last.entries.add(entry);
    }
  }
  return sections;
}

DateTime _startOfDay(DateTime date) =>
    DateTime(date.year, date.month, date.day);

String _formatDayHeader(DateTime day) {
  final now = DateTime.now();
  final today = _startOfDay(now);
  final yesterday = today.subtract(const Duration(days: 1));
  final date = _startOfDay(day.toLocal());
  final prefix = date == today
      ? '今天'
      : date == yesterday
      ? '昨天'
      : '${date.year} 年 ${date.month} 月 ${date.day} 日';
  return '$prefix · ${_weekdayLabel(date.weekday)}';
}

String _weekdayLabel(int weekday) => switch (weekday) {
  DateTime.monday => '周一',
  DateTime.tuesday => '周二',
  DateTime.wednesday => '周三',
  DateTime.thursday => '周四',
  DateTime.friday => '周五',
  DateTime.saturday => '周六',
  _ => '周日',
};

String _formatTime(DateTime date) {
  final local = date.toLocal();
  return '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
}

String _formatWalkWindow(CareActivity activity) {
  final startedAt = activity.startedAt?.toLocal();
  if (startedAt == null) return _formatTime(activity.occurredAt);
  final endedAt = activity.endedAt?.toLocal();
  if (endedAt == null) return '${_formatTime(startedAt)}-进行中';
  final duration = activity.duration ?? endedAt.difference(startedAt);
  final minutes = math.max(0, duration.inMinutes);
  return '${_formatTime(startedAt)}-${_formatTime(endedAt)}（$minutes 分钟）';
}

IconData _healthIcon(String type) => switch (type) {
  'weight' => Icons.monitor_weight_outlined,
  'food' => Icons.restaurant_outlined,
  'water' => Icons.water_drop_rounded,
  'elimination' => Icons.wc_outlined,
  'symptom' => Icons.healing_outlined,
  'medication' => Icons.medication_outlined,
  'vaccine' => Icons.vaccines_outlined,
  'deworming' => Icons.bug_report_outlined,
  _ => Icons.note_add_outlined,
};

IconData _careIcon(String type) => switch (type) {
  'bath' => Icons.bathtub_outlined,
  'walk' => Icons.directions_walk_rounded,
  'oral' => Icons.medical_services_outlined,
  'combing' => Icons.brush_outlined,
  'styling' => Icons.content_cut_rounded,
  'nail' => Icons.back_hand_outlined,
  'ear' => Icons.hearing_outlined,
  'eye' => Icons.visibility_outlined,
  'paw' => Icons.pets_outlined,
  'environment' => Icons.cleaning_services_outlined,
  'deworming' => Icons.bug_report_outlined,
  _ => Icons.note_add_outlined,
};
