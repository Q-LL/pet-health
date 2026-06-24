import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/page_frame.dart';
import '../../care/data/care_repository.dart';
import '../../care/domain/care_models.dart';
import '../../memories/presentation/memories_page.dart';
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

class _CalendarPageState extends ConsumerState<CalendarPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  var _selectedDay = _startOfDay(DateTime.now());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Row(
                  children: [
                    Text(
                      '日历',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const Spacer(),
                    IconButton.filledTonal(
                      tooltip: '全部记录',
                      onPressed: () => context.go('/calendar/records'),
                      icon: const Icon(Icons.list_alt_rounded),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '记录回看与成长时光。',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: '日历', icon: Icon(Icons.calendar_month_rounded)),
                    Tab(text: '爱宠时光', icon: Icon(Icons.auto_awesome_rounded)),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _CalendarTab(
                  selectedDay: _selectedDay,
                  onDayChanged: (day) =>
                      setState(() => _selectedDay = _startOfDay(day)),
                ),
                const MemoriesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecordsEntryCard extends StatelessWidget {
  const _RecordsEntryCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: colors.primaryContainer,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: colors.surface.withValues(alpha: .72),
                child: const Icon(Icons.list_alt_rounded),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  '查看全部历史记录',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

/// 日历 Tab 内容：包含记录入口、统计、日历和当天时间线。
class _CalendarTab extends ConsumerWidget {
  const _CalendarTab({required this.selectedDay, required this.onDayChanged});

  final DateTime selectedDay;
  final ValueChanged<DateTime> onDayChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petId = ref.watch(selectedPetIdProvider).value;
    final query = petId == null ? null : (petId: petId, day: selectedDay);
    final health = query == null
        ? const AsyncValue<List<HealthRecord>>.loading()
        : ref.watch(_healthForDayProvider(query));
    final care = query == null
        ? const AsyncValue<List<CareActivity>>.loading()
        : ref.watch(_careForDayProvider(query));

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _RecordsEntryCard(onTap: () => context.go('/calendar/records')),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _SummaryChip(
                      icon: Icons.favorite_outline_rounded,
                      value: '${health.value?.length ?? 0}',
                      label: '健康',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SummaryChip(
                      icon: Icons.spa_outlined,
                      value: '${care.value?.length ?? 0}',
                      label: '护理',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: SizedBox(
                    height: 360,
                    child: CalendarDatePicker(
                      initialDate: selectedDay,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2035),
                      onDateChanged: onDayChanged,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              SectionHeader('${selectedDay.month} 月 ${selectedDay.day} 日时间线'),
              _DayTimeline(health: health, care: care),
            ],
          ),
        ),
      ),
    );
  }
}

class _DayTimeline extends StatelessWidget {
  const _DayTimeline({required this.health, required this.care});

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

    final entries = <_DayEntry>[
      for (final record in health.value ?? const <HealthRecord>[])
        _DayEntry(
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
        _DayEntry(
          occurredAt: activity.startedAt ?? activity.occurredAt,
          icon: _careIcon(activity.type),
          title: activity.type == 'walk'
              ? _formatWalkWindow(activity)
              : careActivityLabels[activity.type] ?? '护理记录',
          subtitle: [
            if (activity.type != 'walk') careActivityLabels[activity.type],
            if (activity.place.isNotEmpty) activity.place,
            if (activity.note.isNotEmpty) activity.note,
          ].whereType<String>().join(' · '),
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
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 6,
              ),
              leading: CircleAvatar(child: Icon(entries[index].icon, size: 20)),
              title: Text(entries[index].title),
              subtitle: entries[index].subtitle.isEmpty
                  ? null
                  : Text(entries[index].subtitle),
              trailing: Text(_formatTime(entries[index].occurredAt)),
            ),
            if (index < entries.length - 1) const Divider(height: 1),
          ],
        ],
      ),
    );
  }
}

class _DayEntry {
  const _DayEntry({
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
  _ => Icons.note_add_outlined,
};
