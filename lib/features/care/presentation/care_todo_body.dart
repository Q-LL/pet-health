import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/ui/ui.dart';
import '../../pets/data/pet_repository.dart';
import '../../records/presentation/add_record_sheet.dart';
import '../../reminders/data/reminder_repository.dart';
import '../../reminders/domain/reminder_filter.dart';
import '../../reminders/presentation/today_reminder_tile.dart';
import '../application/care_coverage.dart';
import '../application/care_plan_controller.dart';
import '../application/care_recommendation.dart';

class DueCareRow extends ConsumerWidget {
  const DueCareRow({required this.recommendation, super.key});
  final CareRecommendation recommendation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = recommendation;
    final colors = Theme.of(context).colorScheme;
    final accent = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            Icons.radio_button_unchecked_rounded,
            color: item.isOverdue ? accent.overdueMark : colors.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.plan.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 3),
                Text(
                  item.recommendationText,
                  style: TextStyle(
                    fontSize: 12,
                    color: item.isOverdue
                        ? accent.onApricot
                        : colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          FilledButton.tonal(
            style: item.isOverdue
                ? FilledButton.styleFrom(
                    backgroundColor: accent.apricot,
                    foregroundColor: accent.onApricot,
                  )
                : null,
            onPressed: () => showCareActivitySheet(
              context,
              type: item.plan.careType,
              beforeSave: (draft) async {
                await ref
                    .read(carePlanControllerProvider.notifier)
                    .logCompletionWithActivity(
                      item.plan.candidateId,
                      activityDraft: draft,
                    );
                return null;
              },
            ),
            child: const Text('去记录'),
          ),
        ],
      ),
    );
  }
}

class CareTodoBody extends ConsumerWidget {
  const CareTodoBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = ref.watch(selectedPetIdProvider).value;
    if (id == null) return const LoadingView();
    final reminders = ref.watch(todayRemindersProvider(id));
    final care = ref.watch(careRecommendationsProvider);
    final overdue = care
        .where((item) => item.isOverdue && item.isRecommended)
        .toList();
    final todayCare = care
        .where((item) => !item.isOverdue && item.isRecommended)
        .toList();
    final upcoming = care
        .where((item) => !item.isRecommended && (item.daysUntilDue ?? 999) <= 7)
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (overdue.isNotEmpty) ...[
          Text(
            '已逾期',
            style: TextStyle(
              color: AppColors.of(context).onApricot,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          SectionCard.rows(
            children: [
              for (final item in overdue) DueCareRow(recommendation: item),
            ],
          ),
          const SizedBox(height: 20),
        ],
        const SectionHeader('今天'),
        AsyncValueView(
          value: reminders,
          errorTitle: '提醒暂时没有读到',
          onRetry: () => ref.invalidate(todayRemindersProvider(id)),
          data: (items) => items.isEmpty && todayCare.isEmpty
              ? const EmptyState(
                  icon: Icons.task_alt_rounded,
                  title: '今天轻轻松松',
                  message: '暂时没有待完成事项。',
                )
              : SectionCard.rows(
                  children: [
                    for (final item in items)
                      TodayReminderTile(key: ValueKey(item.id), reminder: item),
                    for (final item in todayCare)
                      DueCareRow(recommendation: item),
                  ],
                ),
        ),
        if (upcoming.isNotEmpty) ...[
          const SizedBox(height: 20),
          const SectionHeader('本周'),
          SectionCard.rows(
            children: [
              for (final item in upcoming) DueCareRow(recommendation: item),
            ],
          ),
        ],
        const SizedBox(height: 16),
        const CareProgressPreview(),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: () => context.push('/reminders'),
          icon: const Icon(Icons.list_alt_rounded),
          label: const Text('管理全部提醒'),
        ),
        _NextReminders(petId: id),
      ],
    );
  }
}

class _NextReminders extends ConsumerWidget {
  const _NextReminders({required this.petId});
  final String petId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tomorrow = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day + 1,
    );
    final value = ref.watch(
      filteredRemindersProvider(
        ReminderFilter(petId: petId, enabled: true, from: tomorrow.toUtc()),
      ),
    );
    final items =
        value.value?.where((item) => !item.paused).take(3).toList() ?? [];
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        const SectionHeader('接下来'),
        SectionCard.rows(
          children: [
            for (final item in items)
              ListRow(
                title: item.title,
                subtitle:
                    '${item.scheduledAt.toLocal().month}月${item.scheduledAt.toLocal().day}日',
                leading: const IconBadge(Icons.schedule_outlined),
                onTap: () => context.push('/reminders'),
              ),
          ],
        ),
      ],
    );
  }
}

class CareProgressPreview extends ConsumerWidget {
  const CareProgressPreview({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(careCoverageProvider);
    final progress = value.value;
    return SectionCard(
      color: Theme.of(context).colorScheme.primaryContainer,
      padding: const EdgeInsets.all(16),
      onTap: () => context.push('/care/coverage'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  '本周护理覆盖',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                progress == null
                    ? '—'
                    : '${progress.completedThisWeek} / ${progress.expectedThisWeek} 次',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (progress != null && progress.expectedThisWeek > 0)
            ClipRRect(
              borderRadius: AppRadius.chipAll,
              child: LinearProgressIndicator(
                value: progress.weeklyRate,
                minHeight: 5,
              ),
            ),
          const SizedBox(height: 8),
          Text(
            value.hasError
                ? '读取失败，点击重试查看'
                : progress == null
                ? '正在汇总护理记录'
                : progress.totalActivePlans == 0
                ? '开启计划后，在这里回顾每周进度'
                : '查看每项护理的完成情况',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
