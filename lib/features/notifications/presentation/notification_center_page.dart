import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/page_frame.dart';
import '../../care/application/care_plan_controller.dart';
import '../../care/application/care_recommendation.dart';
import '../../pets/data/pet_repository.dart';
import '../../records/presentation/add_record_sheet.dart';
import '../../reminders/data/reminder_repository.dart';
import '../../reminders/domain/reminder_models.dart';

class NotificationCenterPage extends ConsumerWidget {
  const NotificationCenterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendations = ref.watch(careRecommendationsProvider);
    final selectedPetId = ref.watch(selectedPetIdProvider).value;
    final reminders = selectedPetId == null
        ? const AsyncValue<List<Reminder>>.loading()
        : ref.watch(todayRemindersProvider(selectedPetId));

    final dueRecommendations = recommendations
        .where((r) => r.isRecommended)
        .toList();

    return PageFrame(
      title: '通知中心',
      subtitle: '护理提醒和系统通知都会出现在这里。',
      child: reminders.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorMessage(error: error),
        data: (reminderItems) {
          final todayReminders = reminderItems.where((r) => r.enabled).toList();
          if (dueRecommendations.isEmpty && todayReminders.isEmpty) {
            return _EmptyNotification();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (dueRecommendations.isNotEmpty) ...[
                _SectionHeader(title: '护理提醒', count: dueRecommendations.length),
                const SizedBox(height: 10),
                for (final rec in dueRecommendations)
                  _CarePlanNotificationCard(recommendation: rec),
                const SizedBox(height: 20),
              ],
              if (todayReminders.isNotEmpty) ...[
                _SectionHeader(title: '今日提醒', count: todayReminders.length),
                const SizedBox(height: 10),
                for (final reminder in todayReminders.take(5))
                  _ReminderNotificationCard(reminder: reminder),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.count});
  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: colors.onSurface,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: colors.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              color: colors.onPrimaryContainer,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _CarePlanNotificationCard extends ConsumerWidget {
  const _CarePlanNotificationCard({required this.recommendation});
  final CareRecommendation recommendation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final isUrgent = recommendation.urgencyLevel == 'urgent';
    final containerColor = isUrgent
        ? colors.errorContainer
        : colors.tertiaryContainer;
    final onContainerColor = isUrgent
        ? colors.onErrorContainer
        : colors.onTertiaryContainer;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: containerColor,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colors.surface.withValues(alpha: .72),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  _iconForCareType(recommendation.plan.careType),
                  color: onContainerColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recommendation.plan.title,
                      style: TextStyle(
                        color: onContainerColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      recommendation.recommendationText,
                      style: TextStyle(color: onContainerColor, height: 1.3),
                    ),
                    if (recommendation.daysSinceLastCare != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        '上次护理：${recommendation.daysSinceLastCare} 天前',
                        style: TextStyle(
                          color: onContainerColor.withValues(alpha: .75),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              FilledButton.tonalIcon(
                onPressed: () async {
                  try {
                    var completed = false;
                    await showCareActivitySheet(
                      context,
                      type: recommendation.plan.careType,
                      beforeSave: (draft) async {
                        await ref
                            .read(carePlanControllerProvider.notifier)
                            .logCompletionWithActivity(
                              recommendation.plan.candidateId,
                              activityDraft: draft,
                            );
                        completed = true;
                        return null;
                      },
                    );
                    if (!context.mounted || !completed) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('已完成「${recommendation.plan.title}」'),
                      ),
                    );
                  } catch (error) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('操作失败：$error')));
                  }
                },
                icon: const Icon(Icons.check_rounded, size: 18),
                label: const Text('完成'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReminderNotificationCard extends StatelessWidget {
  const _ReminderNotificationCard({required this.reminder});
  final Reminder reminder;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.notifications_active_outlined,
                  color: colors.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reminder.title,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatTime(reminder.scheduledAt),
                      style: TextStyle(color: colors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyNotification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(
              Icons.notifications_none_rounded,
              size: 48,
              color: colors.primary,
            ),
            const SizedBox(height: 16),
            Text('暂时没有新通知', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              '护理计划到期和系统提醒都会出现在这里',
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({required this.error});
  final Object error;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Text('加载失败：$error'),
      ),
    );
  }
}

IconData _iconForCareType(String careType) => switch (careType) {
  'oral' => Icons.auto_fix_high_rounded,
  'paw' => Icons.pets_rounded,
  'bath' => Icons.bathtub_outlined,
  'combing' => Icons.brush_rounded,
  'nail' => Icons.content_cut_rounded,
  'ear' => Icons.hearing_rounded,
  'eye' => Icons.visibility_outlined,
  'styling' => Icons.content_cut_rounded,
  'environment' => Icons.cleaning_services_outlined,
  'deworming' => Icons.bug_report_outlined,
  _ => Icons.health_and_safety_outlined,
};

String _formatTime(DateTime date) {
  final local = date.toLocal();
  final h = local.hour.toString().padLeft(2, '0');
  final m = local.minute.toString().padLeft(2, '0');
  return '$h:$m';
}
