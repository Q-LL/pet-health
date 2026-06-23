import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/motion.dart';
import '../../../core/widgets/page_frame.dart';
import '../../care/data/care_repository.dart';
import '../../care/domain/care_models.dart';
import '../../pets/data/pet_repository.dart';
import '../../records/data/health_record_repository.dart';
import '../../records/domain/health_record.dart';
import '../../records/presentation/add_record_sheet.dart';

typedef _DayQuery = ({String petId, DateTime day});

final _healthForDayProvider = StreamProvider.autoDispose
    .family<List<HealthRecord>, _DayQuery>((ref, query) {
      return ref
          .watch(healthRecordRepositoryProvider)
          .watchForPet(
            query.petId,
            from: query.day,
            to: query.day.add(const Duration(days: 1)),
          );
    });

final _careForDayProvider = StreamProvider.autoDispose
    .family<List<CareActivity>, _DayQuery>((ref, query) {
      return ref
          .watch(careRepositoryProvider)
          .watchForPet(
            query.petId,
            from: query.day,
            to: query.day.add(const Duration(days: 1)),
          );
    });

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  var _selectedDay = _startOfDay(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final petId = ref.watch(selectedPetIdProvider).value;
    final query = petId == null ? null : (petId: petId, day: _selectedDay);
    final health = query == null
        ? const AsyncValue<List<HealthRecord>>.loading()
        : ref.watch(_healthForDayProvider(query));
    final care = query == null
        ? const AsyncValue<List<CareActivity>>.loading()
        : ref.watch(_careForDayProvider(query));

    return PageFrame(
      title: '日历',
      subtitle: '按日期回顾健康与护理记录。',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: _SummaryChip(
                  icon: Icons.favorite_outline_rounded,
                  value: '${health.value?.length ?? 0}',
                  label: '健康记录',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryChip(
                  icon: Icons.spa_outlined,
                  value: '${care.value?.length ?? 0}',
                  label: '护理记录',
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
                  initialDate: _selectedDay,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2035),
                  onDateChanged: (date) =>
                      setState(() => _selectedDay = _startOfDay(date)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 22),
          SectionHeader('${_selectedDay.month} 月 ${_selectedDay.day} 日时间线'),
          _Timeline(health: health, care: care),
        ],
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({required this.health, required this.care});

  final AsyncValue<List<HealthRecord>> health;
  final AsyncValue<List<CareActivity>> care;

  @override
  Widget build(BuildContext context) {
    if (health.isLoading || care.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(28),
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (health.hasError || care.hasError) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text('读取时间线失败：${health.error ?? care.error}'),
        ),
      );
    }
    final entries = <_TimelineEntry>[
      for (final record in health.value ?? const <HealthRecord>[])
        _TimelineEntry(
          occurredAt: record.occurredAt,
          icon: _healthIcon(record.type),
          title: record.title,
          subtitle: [
            healthRecordLabels[record.type],
            if (record.numericValue != null)
              '${record.numericValue} ${record.unit ?? ''}'.trim(),
            if (record.note.isNotEmpty) record.note,
          ].whereType<String>().join(' · '),
        ),
      for (final activity in care.value ?? const <CareActivity>[])
        _TimelineEntry(
          occurredAt: activity.occurredAt,
          icon: _careIcon(activity.type),
          title: careActivityLabels[activity.type] ?? '护理记录',
          subtitle: [
            if (activity.duration != null) _formatDuration(activity.duration!),
            if (activity.place.isNotEmpty) activity.place,
            if (activity.note.isNotEmpty) activity.note,
          ].join(' · '),
        ),
    ]..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));

    if (entries.isEmpty) {
      return Card(
        color: Theme.of(context).colorScheme.secondaryContainer,
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
              Text('通过底部“＋”新增后，会按发生时间显示在这里。'),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Column(
        children: [
          for (var index = 0; index < entries.length; index++) ...[
            _TimelineTile(entry: entries[index]),
            if (index < entries.length - 1) const Divider(height: 1),
          ],
        ],
      ),
    );
  }
}

class _TimelineEntry {
  const _TimelineEntry({
    required this.occurredAt,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final DateTime occurredAt;
  final IconData icon;
  final String title;
  final String subtitle;
}

class _TimelineTile extends StatelessWidget {
  const _TimelineTile({required this.entry});

  final _TimelineEntry entry;

  @override
  Widget build(BuildContext context) {
    final local = entry.occurredAt.toLocal();
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      leading: CircleAvatar(child: Icon(entry.icon, size: 20)),
      title: Text(entry.title),
      subtitle: entry.subtitle.isEmpty ? null : Text(entry.subtitle),
      trailing: Text(
        '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}',
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
          Expanded(child: Text(label)),
        ],
      ),
    );
  }
}

DateTime _startOfDay(DateTime date) =>
    DateTime(date.year, date.month, date.day);

IconData _healthIcon(String type) => switch (type) {
  'weight' => Icons.monitor_weight_outlined,
  'food_water' => Icons.restaurant_outlined,
  'elimination' => Icons.water_drop_outlined,
  'symptom' => Icons.healing_outlined,
  'medication' => Icons.medication_outlined,
  'vaccine' => Icons.vaccines_outlined,
  'deworming' => Icons.bug_report_outlined,
  _ => Icons.note_outlined,
};

IconData _careIcon(String type) => switch (type) {
  'bath' => Icons.bathtub_outlined,
  'walk' => Icons.directions_walk_rounded,
  'oral' => Icons.medical_services_outlined,
  'grooming' => Icons.content_cut_rounded,
  'environment' => Icons.cleaning_services_outlined,
  _ => Icons.spa_outlined,
};

String _formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  return hours > 0 ? '$hours 小时 $minutes 分钟' : '$minutes 分钟';
}
