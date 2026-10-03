import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/notifications/notification_service.dart';
import '../../../core/ui/ui.dart';
import '../../care/data/care_repository.dart';
import '../../care/domain/care_models.dart';
import '../../records/data/health_record_repository.dart';
import '../../records/domain/health_record.dart';
import '../../records/presentation/add_record_sheet.dart';
import '../data/reminder_repository.dart';
import '../domain/reminder_models.dart';
import 'reminder_presenters.dart';

class TodayReminderTile extends ConsumerStatefulWidget {
  const TodayReminderTile({required this.reminder, super.key});

  final Reminder reminder;

  @override
  ConsumerState<TodayReminderTile> createState() => TodayReminderTileState();
}

class TodayReminderTileState extends ConsumerState<TodayReminderTile> {
  var _isSaving = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            tooltip: '完成',
            onPressed: _isSaving ? null : _complete,
            icon: _isSaving
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(
                    Icons.radio_button_unchecked_rounded,
                    size: 24,
                    color: widget.reminder.scheduledAt.isBefore(DateTime.now())
                        ? AppColors.of(context).overdueMark
                        : colors.primary,
                  ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.reminder.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  '${formatReminderStatus(widget.reminder.scheduledAt)} · ${sourceTypeLabel(widget.reminder.sourceType)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: _isSaving ? null : _snooze,
            child: const Text('稍后'),
          ),
        ],
      ),
    );
  }

  Future<void> _complete() async {
    if (widget.reminder.completionMode == 'ask_record') {
      if (widget.reminder.completionTarget == 'care') {
        await showCareActivitySheet(
          context,
          type: careTypeForReminder(widget.reminder),
          prefill: carePrefillFromReminder(widget.reminder),
          afterSave: (_) => _markCompleted(result: '已完成并记录护理'),
        );
      } else {
        await showHealthRecordSheet(
          context,
          type: recordTypeForReminder(widget.reminder),
          prefill: prefillFromReminder(widget.reminder),
          afterSave: (_) => _markCompleted(result: '已完成并记录健康'),
        );
      }
      return;
    }

    await _runMutation(
      () async {
        if (widget.reminder.completionMode == 'auto_record') {
          final petId = widget.reminder.petId;
          if (widget.reminder.completionTarget == 'care') {
            await ref
                .read(careRepositoryProvider)
                .create(
                  careActivityDraftFromPrefill(
                    petId: petId,
                    type: careTypeForReminder(widget.reminder),
                    occurredAt: DateTime.now(),
                    prefill: carePrefillFromReminder(widget.reminder),
                  ),
                );
          } else {
            await ref
                .read(healthRecordRepositoryProvider)
                .create(
                  healthRecordDraftFromPrefill(
                    petId: petId,
                    type: recordTypeForReminder(widget.reminder),
                    occurredAt: DateTime.now(),
                    prefill: prefillFromReminder(widget.reminder),
                  ),
                );
          }
        }
        await _markCompleted(
          result: widget.reminder.completionMode == 'auto_record'
              ? '已完成并自动记录'
              : '已完成',
        );
      },
      success: widget.reminder.completionMode == 'auto_record'
          ? '已自动记录'
          : '已完成提醒',
    );
  }

  Future<void> _markCompleted({required String result}) async {
    final repository = ref.read(reminderRepositoryProvider);
    await repository.logAction(widget.reminder.id, 'completed', result: result);
    final repeatRule = ReminderRepeatRule.parse(widget.reminder.repeatRule);
    if (repeatRule == null) {
      await repository.disable(widget.reminder.id);
      await notificationService.cancelReminder(widget.reminder);
      return;
    }
    final updated = await repository.update(
      widget.reminder.id,
      draftFromReminder(
        widget.reminder,
        scheduledAt: repeatRule.nextOccurrenceAfter(
          widget.reminder.scheduledAt,
          DateTime.now(),
        ),
      ),
    );
    await notificationService.scheduleReminder(updated);
  }

  Future<void> _snooze() async {
    await _runMutation(() async {
      final repository = ref.read(reminderRepositoryProvider);
      await repository.logAction(
        widget.reminder.id,
        'snoozed',
        result: '稍后 30 分钟',
      );
      final updated = await repository.update(
        widget.reminder.id,
        draftFromReminder(
          widget.reminder,
          scheduledAt: DateTime.now().add(const Duration(minutes: 30)),
        ),
      );
      await notificationService.scheduleReminder(updated);
    }, success: '已延后 30 分钟');
  }

  Future<void> _runMutation(
    Future<void> Function() mutation, {
    required String success,
  }) async {
    setState(() => _isSaving = true);
    try {
      await mutation();
      if (!mounted) return;
      HapticFeedback.lightImpact();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(success)));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(reminderErrorMessage(error))));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
