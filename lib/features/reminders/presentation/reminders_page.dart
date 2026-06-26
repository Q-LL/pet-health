import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/notifications/notification_service.dart';
import '../../../core/widgets/page_frame.dart';
import '../../care/data/care_repository.dart';
import '../../care/domain/care_activity_spec.dart';
import '../../care/domain/care_models.dart';
import '../../home/presentation/home_page.dart';
import '../../pets/data/pet_repository.dart';
import '../../records/data/health_record_repository.dart';
import '../../records/domain/health_record.dart';
import '../../records/domain/health_record_spec.dart';
import '../../records/presentation/add_record_sheet.dart';
import '../data/reminder_repository.dart';
import '../domain/reminder_models.dart';

final reminderSnapshotsProvider = StreamProvider.autoDispose
    .family<List<ReminderSnapshot>, String>((ref, petId) {
      final repository = ref.watch(reminderRepositoryProvider);
      return repository.watchForPet(petId).asyncMap((reminders) async {
        final snapshots = <ReminderSnapshot>[];
        for (final reminder in reminders) {
          final logs = await repository.findLogs(reminder.id, limit: 20);
          snapshots.add(ReminderSnapshot(reminder: reminder, logs: logs));
        }
        return snapshots;
      });
    });

class ReminderSnapshot {
  const ReminderSnapshot({required this.reminder, required this.logs});

  final Reminder reminder;
  final List<ReminderLog> logs;

  ReminderLog? get latestLog => logs.firstOrNull;

  ReminderLog? get latestCompletedLog =>
      logs.where((log) => log.action == 'completed').firstOrNull;

  bool get isOpen => reminder.enabled;

  bool get hasHistory => !reminder.enabled || latestCompletedLog != null;
}

class RemindersPage extends ConsumerWidget {
  const RemindersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPetId = ref.watch(selectedPetIdProvider).value;
    final snapshots = selectedPetId == null
        ? const AsyncValue<List<ReminderSnapshot>>.loading()
        : ref.watch(reminderSnapshotsProvider(selectedPetId));

    return PageFrame(
      title: '提醒管理',
      subtitle: '查看未完成和已完成提醒，调整重复提醒或取消不再需要的提醒。',
      child: snapshots.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorMessage(error: error),
        data: (items) {
          final open = items.where((item) => item.isOpen).toList();
          final history = items.where((item) => item.hasHistory).toList();
          return DefaultTabController(
            length: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TabBar(
                        tabs: [
                          Tab(text: '未完成 ${open.length}'),
                          Tab(text: '已完成 ${history.length}'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton.filledTonal(
                      tooltip: '新增提醒',
                      onPressed: () => showReminderSheet(context),
                      icon: const Icon(Icons.add_alarm_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * .68,
                  child: TabBarView(
                    children: [
                      _ReminderList(
                        items: open,
                        emptyIcon: Icons.task_alt_rounded,
                        emptyTitle: '没有未完成提醒',
                        emptyMessage: '新的健康和护理提醒会出现在这里。',
                      ),
                      _ReminderList(
                        items: history,
                        historyMode: true,
                        emptyIcon: Icons.history_rounded,
                        emptyTitle: '还没有完成记录',
                        emptyMessage: '完成或取消提醒后，会保留在这里回看。',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ReminderList extends StatelessWidget {
  const _ReminderList({
    required this.items,
    required this.emptyIcon,
    required this.emptyTitle,
    required this.emptyMessage,
    this.historyMode = false,
  });

  final List<ReminderSnapshot> items;
  final IconData emptyIcon;
  final String emptyTitle;
  final String emptyMessage;
  final bool historyMode;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return _EmptyState(
        icon: emptyIcon,
        title: emptyTitle,
        message: emptyMessage,
      );
    }
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) => _ManagedReminderCard(
        snapshot: items[index],
        historyMode: historyMode,
      ),
    );
  }
}

class _ManagedReminderCard extends ConsumerStatefulWidget {
  const _ManagedReminderCard({
    required this.snapshot,
    required this.historyMode,
  });

  final ReminderSnapshot snapshot;
  final bool historyMode;

  @override
  ConsumerState<_ManagedReminderCard> createState() =>
      _ManagedReminderCardState();
}

class _ManagedReminderCardState extends ConsumerState<_ManagedReminderCard> {
  var _saving = false;

  Reminder get reminder => widget.snapshot.reminder;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final completedLog = widget.snapshot.latestCompletedLog;
    return Card(
      color: colors.surfaceContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: colors.primaryContainer,
              child: Icon(
                _reminderIcon(reminder.sourceType),
                color: colors.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          reminder.title,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                      _StatusChip(snapshot: widget.snapshot),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.historyMode && completedLog != null
                        ? '完成于 ${_formatDateTime(completedLog.occurredAt)}'
                        : '${_formatReminderStatus(reminder.scheduledAt)} · ${_repeatLabel(reminder.repeatRule)}',
                    style: TextStyle(color: colors.onSurfaceVariant),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _sourceTypeLabel(reminder.sourceType),
                    style: TextStyle(color: colors.onSurfaceVariant),
                  ),
                  const SizedBox(height: 12),
                  if (widget.historyMode)
                    _HistoryActions(reminder: reminder)
                  else
                    _OpenActions(
                      saving: _saving,
                      reminder: reminder,
                      onComplete: _complete,
                      onSnooze: _snooze,
                      onPauseToggle: _togglePause,
                      onCancel: _cancel,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _complete() async {
    if (reminder.completionMode == 'ask_record') {
      if (reminder.completionTarget == 'care') {
        await showCareActivitySheet(
          context,
          type: _careTypeForReminder(reminder),
          prefill: _carePrefillFromReminder(reminder),
          afterSave: (_) => _markCompleted(result: '已完成并记录护理'),
        );
      } else {
        await showHealthRecordSheet(
          context,
          type: _recordTypeForReminder(reminder),
          prefill: _prefillFromReminder(reminder),
          afterSave: (_) => _markCompleted(result: '已完成并记录健康'),
        );
      }
      return;
    }

    await _runMutation(() async {
      if (reminder.completionMode == 'auto_record') {
        if (reminder.completionTarget == 'care') {
          await ref
              .read(careRepositoryProvider)
              .create(
                careActivityDraftFromPrefill(
                  petId: reminder.petId,
                  type: _careTypeForReminder(reminder),
                  occurredAt: DateTime.now(),
                  prefill: _carePrefillFromReminder(reminder),
                ),
              );
        } else {
          await ref
              .read(healthRecordRepositoryProvider)
              .create(
                healthRecordDraftFromPrefill(
                  petId: reminder.petId,
                  type: _recordTypeForReminder(reminder),
                  occurredAt: DateTime.now(),
                  prefill: _prefillFromReminder(reminder),
                ),
              );
        }
      }
      await _markCompleted(
        result: reminder.completionMode == 'auto_record' ? '已完成并自动记录' : '已完成',
      );
    }, success: reminder.completionMode == 'auto_record' ? '已自动记录' : '已完成提醒');
  }

  Future<void> _markCompleted({required String result}) async {
    final repository = ref.read(reminderRepositoryProvider);
    await repository.logAction(reminder.id, 'completed', result: result);
    final repeatRule = ReminderRepeatRule.parse(reminder.repeatRule);
    if (repeatRule == null) {
      await repository.disable(reminder.id);
      await notificationService.cancelReminder(reminder);
      return;
    }
    final updated = await repository.update(
      reminder.id,
      _draftFromReminder(
        reminder,
        scheduledAt: repeatRule.nextOccurrenceAfter(
          reminder.scheduledAt,
          DateTime.now(),
        ),
      ),
    );
    await notificationService.scheduleReminder(updated);
  }

  Future<void> _snooze() async {
    await _runMutation(() async {
      final repository = ref.read(reminderRepositoryProvider);
      await repository.logAction(reminder.id, 'snoozed', result: '稍后 30 分钟');
      final updated = await repository.update(
        reminder.id,
        _draftFromReminder(
          reminder,
          scheduledAt: DateTime.now().add(const Duration(minutes: 30)),
        ),
      );
      await notificationService.scheduleReminder(updated);
    }, success: '已延后 30 分钟');
  }

  Future<void> _togglePause() async {
    await _runMutation(() async {
      final repository = ref.read(reminderRepositoryProvider);
      if (reminder.paused) {
        await repository.resume(reminder.id);
        final updated = await repository.getById(reminder.id);
        if (updated != null) {
          await notificationService.scheduleReminder(updated);
        }
      } else {
        await repository.pause(reminder.id);
        await notificationService.cancelReminder(reminder);
      }
    }, success: reminder.paused ? '已恢复提醒' : '已暂停提醒');
  }

  Future<void> _cancel() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('取消提醒'),
        content: Text(
          reminder.repeatRule == null
              ? '这个提醒会停止并保留在已完成列表中。'
              : '这个重复提醒会停止后续所有提醒，并保留历史记录。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('返回'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('取消提醒'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await _runMutation(() async {
      final repository = ref.read(reminderRepositoryProvider);
      await repository.logAction(reminder.id, 'skipped', result: '已取消提醒');
      await repository.disable(reminder.id);
      await notificationService.cancelReminder(reminder);
    }, success: '已取消提醒');
  }

  Future<void> _runMutation(
    Future<void> Function() mutation, {
    required String success,
  }) async {
    setState(() => _saving = true);
    try {
      await mutation();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(success)));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_errorMessage(error))));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

class _OpenActions extends StatelessWidget {
  const _OpenActions({
    required this.saving,
    required this.reminder,
    required this.onComplete,
    required this.onSnooze,
    required this.onPauseToggle,
    required this.onCancel,
  });

  final bool saving;
  final Reminder reminder;
  final VoidCallback onComplete;
  final VoidCallback onSnooze;
  final VoidCallback onPauseToggle;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        FilledButton.icon(
          onPressed: saving ? null : onComplete,
          icon: const Icon(Icons.check_rounded, size: 18),
          label: const Text('完成'),
        ),
        IconButton.filledTonal(
          tooltip: '编辑提醒',
          onPressed: saving
              ? null
              : () => showReminderSheet(context, reminder: reminder),
          icon: const Icon(Icons.edit_outlined),
        ),
        IconButton.filledTonal(
          tooltip: '稍后提醒',
          onPressed: saving ? null : onSnooze,
          icon: const Icon(Icons.snooze_rounded),
        ),
        IconButton.filledTonal(
          tooltip: reminder.paused ? '恢复提醒' : '暂停提醒',
          onPressed: saving ? null : onPauseToggle,
          icon: Icon(
            reminder.paused ? Icons.play_arrow_rounded : Icons.pause_rounded,
          ),
        ),
        IconButton.filledTonal(
          tooltip: '取消提醒',
          onPressed: saving ? null : onCancel,
          icon: const Icon(Icons.close_rounded),
        ),
      ],
    );
  }
}

class _HistoryActions extends StatelessWidget {
  const _HistoryActions({required this.reminder});

  final Reminder reminder;

  @override
  Widget build(BuildContext context) {
    if (reminder.enabled) {
      return Text(
        '重复提醒仍会按下一次时间继续。',
        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
      );
    }
    return Text(
      '提醒已停止。',
      style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.snapshot});

  final ReminderSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final label = !snapshot.reminder.enabled
        ? snapshot.latestLog?.action == 'skipped'
              ? '已取消'
              : '已完成'
        : snapshot.reminder.paused
        ? '已暂停'
        : '进行中';
    final color = !snapshot.reminder.enabled
        ? colors.surfaceContainerHighest
        : snapshot.reminder.paused
        ? colors.tertiaryContainer
        : colors.primaryContainer;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 44, color: colors.primary),
            const SizedBox(height: 14),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(
              message,
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
        child: Text('加载失败：${_errorMessage(error)}'),
      ),
    );
  }
}

ReminderDraft _draftFromReminder(
  Reminder reminder, {
  required DateTime scheduledAt,
}) {
  return ReminderDraft(
    petId: reminder.petId,
    sourceType: reminder.sourceType,
    sourceId: reminder.sourceId,
    title: reminder.title,
    scheduledAt: scheduledAt,
    repeatRule: reminder.repeatRule,
    notificationId: reminder.notificationId,
    completionMode: reminder.completionMode,
    completionTarget: reminder.completionTarget,
    recordType: reminder.recordType,
    recordTitle: reminder.recordTitle,
    recordNumericValue: reminder.recordNumericValue,
    recordUnit: reminder.recordUnit,
    recordNote: reminder.recordNote,
    recordDetails: reminder.recordDetails,
    careType: reminder.careType,
    carePlace: reminder.carePlace,
    careNote: reminder.careNote,
    careDetails: reminder.careDetails,
    enabled: reminder.enabled,
    paused: reminder.paused,
  );
}

String _careTypeForReminder(Reminder reminder) {
  final type = reminder.careType;
  if (type != null && careActivityTypes.contains(type) && type != 'walk') {
    return type;
  }
  if (isCareReminderSource(reminder.sourceType)) return reminder.sourceType;
  return 'custom';
}

CareActivityPrefill _carePrefillFromReminder(Reminder reminder) {
  return CareActivityPrefill(
    place: reminder.carePlace,
    note: reminder.careNote,
    details: reminder.careDetails,
  );
}

String _recordTypeForReminder(Reminder reminder) {
  final type = reminder.recordType;
  if (type != null && healthRecordTypes.contains(type)) return type;
  return defaultHealthRecordTypeForReminder(reminder.sourceType);
}

HealthRecordPrefill _prefillFromReminder(Reminder reminder) {
  final type = _recordTypeForReminder(reminder);
  final spec = healthRecordSpecFor(type);
  return HealthRecordPrefill(
    title: reminder.recordTitle?.trim().isNotEmpty == true
        ? reminder.recordTitle
        : spec.defaultTitle,
    note: reminder.recordNote,
    numericValue: reminder.recordNumericValue,
    unit: reminder.recordUnit ?? spec.defaultUnit,
    details: reminder.recordDetails,
  );
}

String _formatReminderStatus(DateTime scheduledAt) {
  final local = scheduledAt.toLocal();
  final now = DateTime.now();
  if (local.isBefore(now)) {
    return '超时 ${_formatOverdueDuration(now.difference(local))}';
  }
  final today = DateTime(now.year, now.month, now.day);
  final scheduledDay = DateTime(local.year, local.month, local.day);
  if (scheduledDay == today) return '今天 ${_formatTime(local)}';
  return '${local.month}/${local.day} ${_formatTime(local)}';
}

String _formatDateTime(DateTime value) {
  final local = value.toLocal();
  return '${local.month}/${local.day} ${_formatTime(local)}';
}

String _formatTime(DateTime value) {
  return '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
}

String _formatOverdueDuration(Duration duration) {
  if (duration.inDays > 0) return '${duration.inDays} 天';
  if (duration.inHours > 0) return '${duration.inHours} 小时';
  final minutes = duration.inMinutes.clamp(1, 59);
  return '$minutes 分钟';
}

String _repeatLabel(String? repeatRule) {
  if (repeatRule == null || repeatRule.isEmpty) return '一次';
  if (repeatRule == 'daily') return '每天';
  if (repeatRule == 'monthly') return '每月';
  if (repeatRule.startsWith('interval:') && repeatRule.endsWith('d')) {
    return '每隔 ${repeatRule.substring(9, repeatRule.length - 1)} 天';
  }
  if (repeatRule.startsWith('weekly_days:')) {
    return '每周 ${repeatRule.substring(12).split(',').length} 次';
  }
  return '重复提醒';
}

IconData _reminderIcon(String sourceType) => switch (sourceType) {
  'care_plan' => Icons.event_available_outlined,
  'medication' => Icons.medication_outlined,
  'vaccine' => Icons.vaccines_outlined,
  'deworming' => Icons.healing_outlined,
  'bath' => Icons.bathtub_outlined,
  'oral' => Icons.medical_services_outlined,
  'combing' => Icons.brush_outlined,
  'styling' => Icons.content_cut_rounded,
  'nail' => Icons.back_hand_outlined,
  'ear' => Icons.hearing_outlined,
  'eye' => Icons.visibility_outlined,
  'paw' => Icons.pets_outlined,
  'environment' => Icons.cleaning_services_outlined,
  'visit' => Icons.local_hospital_outlined,
  _ => Icons.notifications_none_rounded,
};

String _sourceTypeLabel(String sourceType) => switch (sourceType) {
  'care_plan' => '护理计划',
  'food' => '喂食',
  'water' => '饮水',
  'symptom' => '症状观察',
  'medication' => '用药',
  'vaccine' => '疫苗',
  'deworming' => '驱虫',
  'bath' => '洗澡',
  'oral' => '口腔护理',
  'combing' => '梳毛',
  'styling' => '美容',
  'nail' => '指甲护理',
  'ear' => '耳部护理',
  'eye' => '眼部护理',
  'paw' => '足爪护理',
  'environment' => '环境清洁',
  'visit' => '就诊',
  _ => '手动提醒',
};

String _errorMessage(Object error) {
  if (error is FormatException) return error.message;
  if (error is StateError) return error.message;
  return '操作失败，请稍后重试';
}
