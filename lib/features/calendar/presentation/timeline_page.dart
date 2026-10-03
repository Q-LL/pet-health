import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/ui/ui.dart';
import '../../care/data/care_repository.dart';
import '../../care/domain/care_activity_filter.dart';
import '../../care/domain/care_activity_spec.dart';
import '../../care/domain/care_models.dart';
import '../../memories/data/memory_repository.dart';
import '../../memories/domain/memory_entry.dart';
import '../../memories/presentation/memories_page.dart';
import '../../pets/data/pet_repository.dart';
import '../../records/data/health_record_repository.dart';
import '../../records/domain/health_record.dart';
import '../../records/domain/health_record_filter.dart';
import '../../records/domain/health_record_spec.dart';
import '../../records/presentation/add_record_sheet.dart';
import '../../records/presentation/record_sheet_components.dart';

enum TimelineFilter {
  all('all', '全部'),
  health('health', '健康'),
  care('care', '护理'),
  walk('walk', '遛狗'),
  memory('memory', '时光');

  const TimelineFilter(this.query, this.label);
  final String query;
  final String label;

  static TimelineFilter fromQuery(String? value) =>
      values.firstWhere((item) => item.query == value, orElse: () => all);
}

/// One journal for health, care, walks and memories, scoped to the current pet.
class TimelinePage extends ConsumerStatefulWidget {
  const TimelinePage({this.filter = TimelineFilter.all, super.key});
  final TimelineFilter filter;

  @override
  ConsumerState<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends ConsumerState<TimelinePage> {
  var _selectedDay = _day(DateTime.now());
  var _calendar = false;
  var _days = 7;

  void _selectDay(DateTime value) => setState(() {
    _selectedDay = _day(value);
    _days = 7;
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final petId = ref.watch(selectedPetIdProvider).value;
    final filter = widget.filter;
    final from = _dayOffset(_selectedDay, _calendar ? 0 : 1 - _days);
    final to = _dayOffset(_selectedDay, 1);
    final healthFilter = HealthRecordFilter(
      petId: petId ?? '',
      from: from.toUtc(),
      to: to.toUtc(),
    );
    final careFilter = CareActivityFilter(
      petId: petId ?? '',
      from: from.toUtc(),
      to: to.toUtc(),
      type: filter == TimelineFilter.walk ? 'walk' : null,
    );
    final health =
        petId != null &&
            (filter == TimelineFilter.all || filter == TimelineFilter.health)
        ? ref.watch(filteredHealthRecordsProvider(healthFilter))
        : const AsyncData<List<HealthRecord>>([]);
    final care =
        petId != null &&
            (filter == TimelineFilter.all ||
                filter == TimelineFilter.care ||
                filter == TimelineFilter.walk)
        ? ref.watch(filteredCareActivitiesProvider(careFilter))
        : const AsyncData<List<CareActivity>>([]);
    final memories =
        petId != null &&
            (filter == TimelineFilter.all || filter == TimelineFilter.memory)
        ? ref.watch(memoriesForPetProvider(petId))
        : const AsyncData<List<PetMemoryEntry>>([]);
    final entries = <_JournalEntry>[
      for (final record in health.value ?? const <HealthRecord>[])
        _JournalEntry(record.occurredAt, health: record),
      for (final activity in care.value ?? const <CareActivity>[])
        if (filter != TimelineFilter.care || activity.type != 'walk')
          _JournalEntry(activity.occurredAt, care: activity),
      for (final memory in memories.value ?? const <PetMemoryEntry>[])
        if (!memory.occurredAt.isBefore(from) && memory.occurredAt.isBefore(to))
          _JournalEntry(memory.occurredAt, memory: memory),
    ]..sort((a, b) => b.at.compareTo(a.at));
    final error = health.error ?? care.error ?? memories.error;

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        key: const PageStorageKey('timeline-journal'),
        padding: const EdgeInsets.only(top: 12, bottom: 24),
        child: AppContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '时间线',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  IconButton(
                    tooltip: '全部记录',
                    onPressed: () => context.push('/records'),
                    icon: const Icon(Icons.search_rounded),
                  ),
                  IconButton.filledTonal(
                    tooltip: '爱宠时光',
                    onPressed: () => context.push('/memories'),
                    icon: const Icon(Icons.photo_library_outlined),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _selectedDay,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (date != null && mounted) _selectDay(date);
                      },
                      icon: const Icon(Icons.calendar_today_outlined, size: 16),
                      label: Text(
                        '${_selectedDay.year}年${_selectedDay.month}月',
                      ),
                    ),
                  ),
                  SegmentedButton<bool>(
                    showSelectedIcon: false,
                    segments: const [
                      ButtonSegment(value: false, label: Text('列表')),
                      ButtonSegment(value: true, label: Text('日历')),
                    ],
                    selected: {_calendar},
                    onSelectionChanged: (value) =>
                        setState(() => _calendar = value.single),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (_calendar)
                SectionCard(
                  padding: EdgeInsets.zero,
                  child: MediaQuery.withClampedTextScaling(
                    maxScaleFactor: 1.2,
                    child: CalendarDatePicker(
                      initialDate: _selectedDay,
                      currentDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                      onDateChanged: _selectDay,
                    ),
                  ),
                )
              else
                _WeekStrip(day: _selectedDay, onChanged: _selectDay),
              const SizedBox(height: 16),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final option in TimelineFilter.values)
                    ChoiceChip(
                      label: Text(option.label),
                      showCheckmark: false,
                      selected: filter == option,
                      onSelected: (_) =>
                          context.go('/timeline?type=${option.query}'),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              if (error != null)
                ErrorView(
                  title: '部分记录暂时没有读到',
                  message: describeError(error),
                  onRetry: () {
                    ref.invalidate(filteredHealthRecordsProvider(healthFilter));
                    ref.invalidate(filteredCareActivitiesProvider(careFilter));
                    if (petId != null) {
                      ref.invalidate(memoriesForPetProvider(petId));
                    }
                  },
                ),
              if (health.isLoading || care.isLoading || memories.isLoading)
                const LoadingView(label: '正在翻开记录')
              else if (entries.isEmpty && error == null)
                EmptyState(
                  icon: filter == TimelineFilter.memory
                      ? Icons.photo_library_outlined
                      : Icons.event_note_outlined,
                  title: filter == TimelineFilter.memory
                      ? '还没有爱宠时光'
                      : '这段时间还没有记录',
                  message:
                      filter == TimelineFilter.memory &&
                          !ref.watch(albumAssetServiceProvider).isSupported
                      ? '在 iPhone 或 Android 上写随笔、选择照片，留下你们的时光。'
                      : '点底部“＋”记一笔，或选择其他日期回看。',
                )
              else
                for (var i = 0; i < entries.length; i++) ...[
                  if (i == 0 || _day(entries[i].at) != _day(entries[i - 1].at))
                    Padding(
                      padding: const EdgeInsets.only(top: 6, bottom: 10),
                      child: Text(
                        _dateLabel(entries[i].at),
                        style: TextStyle(
                          color: colors.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  _JournalCard(entry: entries[i]),
                  const SizedBox(height: 10),
                ],
              if (!_calendar)
                TextButton.icon(
                  onPressed: () => setState(() => _days += 7),
                  icon: const Icon(Icons.expand_more_rounded),
                  label: const Text('查看更早的记录'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeekStrip extends StatelessWidget {
  const _WeekStrip({required this.day, required this.onChanged});
  final DateTime day;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final monday = _dayOffset(day, 1 - day.weekday);
    const labels = ['一', '二', '三', '四', '五', '六', '日'];
    return Row(
      children: [
        for (var i = 0; i < 7; i++)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Material(
                color: _dayOffset(monday, i) == day
                    ? colors.primary
                    : Colors.transparent,
                borderRadius: AppRadius.chipAll,
                child: InkWell(
                  borderRadius: AppRadius.chipAll,
                  onTap: () => onChanged(_dayOffset(monday, i)),
                  child: Semantics(
                    selected: _dayOffset(monday, i) == day,
                    label:
                        '${_dayOffset(monday, i).month}月${_dayOffset(monday, i).day}日',
                    button: true,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          Text(
                            labels[i],
                            style: TextStyle(
                              fontSize: 11,
                              color: _dayOffset(monday, i) == day
                                  ? colors.onPrimary
                                  : colors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_dayOffset(monday, i).day}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: _dayOffset(monday, i) == day
                                  ? colors.onPrimary
                                  : colors.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _JournalEntry {
  const _JournalEntry(this.at, {this.health, this.care, this.memory});
  final DateTime at;
  final HealthRecord? health;
  final CareActivity? care;
  final PetMemoryEntry? memory;
}

class _JournalCard extends ConsumerWidget {
  const _JournalCard({required this.entry});
  final _JournalEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memory = entry.memory;
    if (memory != null) {
      return MemoryCard(
        key: ValueKey(memory.id),
        entry: memory,
        onEdit: () =>
            showMemoryEditor(context, ref, memory.petId, entry: memory),
        onDelete: () => deleteMemoryEntry(context, ref, memory),
      );
    }
    final health = entry.health;
    final care = entry.care;
    final walk = care?.type == 'walk';
    final activeWalk = walk && care!.startedAt != null && care.endedAt == null;
    final colors = Theme.of(context).colorScheme;
    final food = health?.type == 'food';
    final meal = health?.details['meal'];
    final healthTitle =
        food && health!.title == healthRecordSpecFor('food').defaultTitle
        ? '饮食${meal == null || meal.isEmpty ? '' : ' · $meal'}'
        : health?.title;
    final title =
        healthTitle ??
        (activeWalk
            ? '正在遛狗'
            : walk
            ? '遛狗 ${care!.duration?.inMinutes ?? 0} 分钟'
            : careActivityLabels[care!.type] ?? '护理');
    final detail = health != null
        ? [
            if (health.numericValue != null)
              '${health.numericValue} ${health.unit ?? ''}',
            ...healthRecordSpecFor(health.type).fields
                .where((field) => field.key != 'meal')
                .map((field) => health.details[field.key] ?? '')
                .where((value) => value.isNotEmpty)
                .take(2),
            if (health.note.isNotEmpty) health.note,
          ].join(' · ')
        : [
            if (care!.place.isNotEmpty) care.place,
            ...careActivitySpecFor(care.type).fields
                .map((field) => care.details[field.key] ?? '')
                .where((value) => value.isNotEmpty)
                .take(2),
            if (care.note.isNotEmpty) care.note,
            if (care.place.isEmpty && care.note.isEmpty)
              activeWalk
                  ? '计时中，可在底部结束'
                  : walk
                  ? '陪伴的每一步'
                  : '日常护理',
          ].join(' · ');
    return SectionCard(
      key: ValueKey(health?.id ?? care!.id),
      padding: const EdgeInsets.all(14),
      onTap: activeWalk
          ? null
          : () => health != null
                ? showHealthRecordSheet(
                    context,
                    type: health.type,
                    record: health,
                  )
                : showCareActivitySheet(
                    context,
                    type: care!.type,
                    activity: care,
                  ),
      child: Row(
        children: [
          IconBadge(
            health != null
                ? healthRecordIcon(health.type)
                : careRecordIcon(care!.type),
            background: walk ? AppColors.of(context).apricot : null,
            foreground: walk ? AppColors.of(context).onApricot : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 3),
                Text(
                  detail.isEmpty
                      ? (healthRecordLabels[health?.type] ?? '日常护理')
                      : detail,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _time(entry.at),
            style: TextStyle(fontSize: 11, color: colors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

DateTime _day(DateTime value) {
  final local = value.toLocal();
  return DateTime(local.year, local.month, local.day);
}

DateTime _dayOffset(DateTime value, int offset) =>
    DateTime(value.year, value.month, value.day + offset);
String _time(DateTime value) {
  final local = value.toLocal();
  return '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
}

String _dateLabel(DateTime value) {
  final local = _day(value);
  final today = _day(DateTime.now());
  final prefix = local == today
      ? '今天 · '
      : local == _dayOffset(today, -1)
      ? '昨天 · '
      : '';
  return '$prefix${local.year == today.year ? '' : '${local.year}年'}${local.month}月${local.day}日';
}
