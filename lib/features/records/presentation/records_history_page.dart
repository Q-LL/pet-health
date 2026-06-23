import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/page_frame.dart';
import '../../care/data/care_repository.dart';
import '../../care/domain/care_models.dart';
import '../../pets/data/pet_repository.dart';
import '../data/health_record_repository.dart';
import '../domain/health_record.dart';
import 'add_record_sheet.dart';

final _allHealthRecordsProvider = StreamProvider.autoDispose
    .family<List<HealthRecord>, String>((ref, petId) {
      return ref
          .watch(healthRecordRepositoryProvider)
          .watchForPet(petId, limit: 300);
    });

final _allCareRecordsProvider = StreamProvider.autoDispose
    .family<List<CareActivity>, String>((ref, petId) {
      return ref.watch(careRepositoryProvider).watchForPet(petId, limit: 300);
    });

enum _RecordFilter { all, health, care }

class RecordsHistoryPage extends ConsumerStatefulWidget {
  const RecordsHistoryPage({super.key});

  @override
  ConsumerState<RecordsHistoryPage> createState() => _RecordsHistoryPageState();
}

class _RecordsHistoryPageState extends ConsumerState<RecordsHistoryPage> {
  var _filter = _RecordFilter.all;

  @override
  Widget build(BuildContext context) {
    final petId = ref.watch(selectedPetIdProvider).value;
    final health = petId == null
        ? const AsyncValue<List<HealthRecord>>.loading()
        : ref.watch(_allHealthRecordsProvider(petId));
    final care = petId == null
        ? const AsyncValue<List<CareActivity>>.loading()
        : ref.watch(_allCareRecordsProvider(petId));

    return PageFrame(
      title: '历史记录',
      subtitle: '按日期向下浏览当前狗狗的全部健康和护理记录。',
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
            onSelectionChanged: (value) =>
                setState(() => _filter = value.single),
          ),
          const SizedBox(height: 16),
          _HistoryList(filter: _filter, health: health, care: care),
        ],
      ),
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList({
    required this.filter,
    required this.health,
    required this.care,
  });

  final _RecordFilter filter;
  final AsyncValue<List<HealthRecord>> health;
  final AsyncValue<List<CareActivity>> care;

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
                '还没有历史记录',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
              SizedBox(height: 6),
              Text('新增健康或护理记录后，会按日期排列在这里。'),
            ],
          ),
        ),
      );
    }

    final sections = _groupByDay(entries);
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
    if (entry.health != null) {
      await ref.read(healthRecordRepositoryProvider).delete(entry.health!.id);
    } else {
      await ref.read(careRepositoryProvider).delete(entry.care!.id);
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
  'food_water' => Icons.restaurant_outlined,
  'elimination' => Icons.water_drop_outlined,
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
  'grooming' => Icons.content_cut_rounded,
  'nail' => Icons.back_hand_outlined,
  'ear' => Icons.hearing_outlined,
  'eye' => Icons.visibility_outlined,
  'paw' => Icons.pets_outlined,
  'environment' => Icons.cleaning_services_outlined,
  _ => Icons.note_add_outlined,
};
