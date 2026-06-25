import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/notifications/notification_service.dart';
import '../../../core/widgets/motion.dart';
import '../../../core/widgets/page_frame.dart';
import '../../care/application/care_controller.dart';
import '../../care/application/care_recommendation.dart';
import '../../care/data/care_repository.dart';
import '../../care/domain/care_activity_spec.dart';
import '../../care/domain/care_models.dart';
import '../../care/presentation/care_overview.dart';
import '../../care/presentation/care_sheets.dart';
import '../../pets/data/pet_repository.dart';
import '../../pets/presentation/pet_avatar.dart';
import '../../records/data/health_record_repository.dart';
import '../../records/domain/health_record.dart';
import '../../records/domain/health_record_spec.dart';
import '../../records/presentation/add_record_sheet.dart';
import '../../reminders/data/reminder_repository.dart';
import '../../reminders/domain/reminder_models.dart';
import '../../settings/data/app_settings_repository.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  StreamSubscription<NotificationResponse>? _notificationSubscription;
  var _showingWalkFinishSheet = false;
  DateTime? _lastWalkNotificationStartedAt;

  @override
  void initState() {
    super.initState();
    _notificationSubscription = notificationService.responses.listen(
      _handleNotificationResponse,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final details = await notificationService.getLaunchDetails();
      final response = details?.notificationResponse;
      if (response != null && mounted) _handleNotificationResponse(response);
    });
  }

  @override
  void dispose() {
    _notificationSubscription?.cancel();
    super.dispose();
  }

  void _handleNotificationResponse(NotificationResponse response) {
    final payload = response.payload;
    if (payload == walkFinishPayload ||
        response.actionId == walkFinishActionId) {
      _showPendingWalkFinishSheet();
    }
  }

  void _showPendingWalkFinishSheet() {
    if (_showingWalkFinishSheet || !mounted) return;
    final activeWalkStartedAt = ref.read(
      careControllerProvider.select((state) => state.activeWalkStartedAt),
    );
    if (activeWalkStartedAt == null) return;
    _showingWalkFinishSheet = true;
    context.go('/home');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await showFinishWalkSheet(context);
      _showingWalkFinishSheet = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<DateTime?>(
      careControllerProvider.select((state) => state.activeWalkStartedAt),
      (_, startedAt) {
        if (startedAt == null) {
          _lastWalkNotificationStartedAt = null;
          notificationService.cancelWalkTimer();
          return;
        }
        if (_lastWalkNotificationStartedAt == startedAt) return;
        _lastWalkNotificationStartedAt = startedAt;
        notificationService.showWalkTimer(startedAt: startedAt);
      },
    );
    return PageFrame(
      title: '毛健康',
      subtitle: '专为狗狗记录每一天的小变化。',
      actions: [
        _NotificationButton(),
        const SizedBox(width: 12),
      ],
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          EntranceAnimation(child: _WelcomeHero()),
          SizedBox(height: 28),
          EntranceAnimation(
            delay: Duration(milliseconds: 70),
            child: SectionHeader('快速记录'),
          ),
          EntranceAnimation(
            delay: Duration(milliseconds: 100),
            child: _QuickActions(),
          ),
          SizedBox(height: 28),
          EntranceAnimation(
            delay: Duration(milliseconds: 140),
            child: SectionHeader('日常护理'),
          ),
          EntranceAnimation(
            delay: Duration(milliseconds: 170),
            child: CareOverview(),
          ),
          SizedBox(height: 28),
          EntranceAnimation(
            delay: Duration(milliseconds: 210),
            child: SectionHeader('今天', action: '全部提醒'),
          ),
          EntranceAnimation(
            delay: Duration(milliseconds: 240),
            child: _TodayCard(),
          ),
          SizedBox(height: 28),
          EntranceAnimation(
            delay: Duration(milliseconds: 280),
            child: SectionHeader('健康动态', action: '查看时间线'),
          ),
          EntranceAnimation(
            delay: Duration(milliseconds: 310),
            child: _ActivityCard(),
          ),
          SizedBox(height: 16),
          EntranceAnimation(
            delay: Duration(milliseconds: 340),
            child: _InsightCard(),
          ),
        ],
      ),
    );
  }
}

class _WelcomeHero extends ConsumerWidget {
  const _WelcomeHero();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final pets = ref.watch(petsProvider).value ?? const [];
    final selectedId = ref.watch(selectedPetIdProvider).value;
    final selectedPet = pets.where((pet) => pet.id == selectedId).firstOrNull;
    final hasProfile = selectedPet != null && !selectedPet.isPlaceholder;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -34,
            top: -48,
            child: _SoftCircle(size: 154, color: colors.onTertiaryContainer),
          ),
          Positioned(
            right: 62,
            bottom: -50,
            child: _SoftCircle(size: 104, color: colors.onPrimaryContainer),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: colors.surface.withValues(alpha: .75),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.pets_rounded,
                        color: colors.primary,
                        size: 28,
                      ),
                    ),
                    const Spacer(),
                    if (hasProfile)
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: colors.surface.withValues(alpha: .78),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: colors.shadow.withValues(alpha: .14),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: PetPortrait(pet: selectedPet, size: 86),
                      )
                    else
                      const _LocalBadge(),
                  ],
                ),
                const SizedBox(height: 26),
                Text(
                  hasProfile ? '今天也陪好 ${selectedPet.name}' : '从认识毛孩子开始',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 360),
                  child: Text(
                    hasProfile
                        ? '健康和护理记录都只保存在本机，慢慢积累成属于它的狗狗履历。'
                        : '创建第一份狗狗档案，体重、护理和每次观察都会有迹可循。',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(height: 1.5),
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    FilledButton.icon(
                      onPressed: () => hasProfile
                          ? showAddRecordSheet(context)
                          : context.go('/pets'),
                      icon: Icon(
                        hasProfile ? Icons.add_rounded : Icons.pets_rounded,
                      ),
                      label: Text(hasProfile ? '新增一条记录' : '创建档案'),
                    ),
                    const Spacer(),
                    if (hasProfile) const _LocalBadge(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LocalBadge extends StatelessWidget {
  const _LocalBadge();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: .7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lock_outline_rounded, size: 12, color: colors.onSurface),
          const SizedBox(width: 4),
          Text(
            '本机',
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: colors.onSurface),
          ),
        ],
      ),
    );
  }
}

class _SoftCircle extends StatelessWidget {
  const _SoftCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: color.withValues(alpha: .055),
      shape: BoxShape.circle,
    ),
  );
}

class _QuickActions extends ConsumerWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final isWalking = ref.watch(
      careControllerProvider.select(
        (state) => state.activeWalkStartedAt != null,
      ),
    );
    final selectedIds =
        ref.watch(quickActionIdsProvider).value ?? defaultQuickActionIds;
    final actions = [
      for (final id in selectedIds)
        _quickActionForId(
          context,
          ref,
          id,
          isWalking: isWalking,
          colors: colors,
        ),
      _quickActionForId(
        context,
        ref,
        fixedMoreRecordActionId,
        isWalking: isWalking,
        colors: colors,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 420;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: compact ? 2 : 4,
            mainAxisExtent: 104,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            return PressableScale(
              child: Material(
                color: action.color,
                borderRadius: BorderRadius.circular(24),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: action.action,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(action.icon, color: action.onColor, size: 26),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                action.label,
                                style: TextStyle(
                                  color: action.onColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.add_rounded,
                              color: action.onColor,
                              size: 18,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

({IconData icon, String label, Color color, Color onColor, VoidCallback action})
_quickActionForId(
  BuildContext context,
  WidgetRef ref,
  String id, {
  required bool isWalking,
  required ColorScheme colors,
}) {
  return switch (id) {
    'health:water' => (
      icon: Icons.water_drop_rounded,
      label: '饮水',
      color: colors.primaryContainer,
      onColor: colors.onPrimaryContainer,
      action: () => showHealthRecordSheet(context, type: 'water'),
    ),
    'health:elimination' => (
      icon: Icons.wc_outlined,
      label: '排泄',
      color: colors.primaryContainer,
      onColor: colors.onPrimaryContainer,
      action: () => showHealthRecordSheet(context, type: 'elimination'),
    ),
    'health:symptom' => (
      icon: Icons.healing_outlined,
      label: '症状',
      color: colors.primaryContainer,
      onColor: colors.onPrimaryContainer,
      action: () => showHealthRecordSheet(context, type: 'symptom'),
    ),
    'health:food' => (
      icon: Icons.restaurant_outlined,
      label: '喂食',
      color: colors.primaryContainer,
      onColor: colors.onPrimaryContainer,
      action: () => showHealthRecordSheet(context, type: 'food'),
    ),
    'health:medication' => (
      icon: Icons.medication_outlined,
      label: '用药',
      color: colors.primaryContainer,
      onColor: colors.onPrimaryContainer,
      action: () => showHealthRecordSheet(context, type: 'medication'),
    ),
    'health:vaccine' => (
      icon: Icons.vaccines_outlined,
      label: '疫苗',
      color: colors.primaryContainer,
      onColor: colors.onPrimaryContainer,
      action: () => showHealthRecordSheet(context, type: 'vaccine'),
    ),
    'health:deworming' => (
      icon: Icons.bug_report_outlined,
      label: '驱虫',
      color: colors.primaryContainer,
      onColor: colors.onPrimaryContainer,
      action: () => showHealthRecordSheet(context, type: 'deworming'),
    ),
    'health:custom' => (
      icon: Icons.note_add_outlined,
      label: '自定义健康',
      color: colors.primaryContainer,
      onColor: colors.onPrimaryContainer,
      action: () => showHealthRecordSheet(context),
    ),
    'care:bath' => (
      icon: Icons.bathtub_outlined,
      label: '洗澡',
      color: colors.secondaryContainer,
      onColor: colors.onSecondaryContainer,
      action: () => showBathRecordSheet(context),
    ),
    'care:oral' => (
      icon: Icons.medical_services_outlined,
      label: '口腔护理',
      color: colors.secondaryContainer,
      onColor: colors.onSecondaryContainer,
      action: () => showCareActivitySheet(context, type: 'oral'),
    ),
    'care:combing' => (
      icon: Icons.brush_outlined,
      label: '梳毛',
      color: colors.secondaryContainer,
      onColor: colors.onSecondaryContainer,
      action: () => showCareActivitySheet(context, type: 'combing'),
    ),
    'care:styling' => (
      icon: Icons.content_cut_rounded,
      label: '美容',
      color: colors.secondaryContainer,
      onColor: colors.onSecondaryContainer,
      action: () => showCareActivitySheet(context, type: 'styling'),
    ),
    'care:nail' => (
      icon: Icons.back_hand_outlined,
      label: '指甲护理',
      color: colors.secondaryContainer,
      onColor: colors.onSecondaryContainer,
      action: () => showCareActivitySheet(context, type: 'nail'),
    ),
    'care:ear' => (
      icon: Icons.hearing_outlined,
      label: '耳部护理',
      color: colors.secondaryContainer,
      onColor: colors.onSecondaryContainer,
      action: () => showCareActivitySheet(context, type: 'ear'),
    ),
    'care:eye' => (
      icon: Icons.visibility_outlined,
      label: '眼部护理',
      color: colors.secondaryContainer,
      onColor: colors.onSecondaryContainer,
      action: () => showCareActivitySheet(context, type: 'eye'),
    ),
    'care:paw' => (
      icon: Icons.pets_outlined,
      label: '足爪护理',
      color: colors.secondaryContainer,
      onColor: colors.onSecondaryContainer,
      action: () => showCareActivitySheet(context, type: 'paw'),
    ),
    'care:environment' => (
      icon: Icons.cleaning_services_outlined,
      label: '环境清洁',
      color: colors.secondaryContainer,
      onColor: colors.onSecondaryContainer,
      action: () => showCareActivitySheet(context, type: 'environment'),
    ),
    'care:walk' => (
      icon: Icons.directions_walk_rounded,
      label: isWalking ? '结束遛狗' : '快速遛狗',
      color: colors.tertiaryContainer,
      onColor: colors.onTertiaryContainer,
      action: () {
        if (isWalking) {
          showFinishWalkSheet(context);
        } else {
          ref.read(careControllerProvider.notifier).startWalk();
        }
      },
    ),
    'care:custom' => (
      icon: Icons.spa_outlined,
      label: '自定义护理',
      color: colors.secondaryContainer,
      onColor: colors.onSecondaryContainer,
      action: () => showCareActivitySheet(context),
    ),
    'more:records' => (
      icon: Icons.grid_view_rounded,
      label: '更多记录',
      color: colors.surfaceContainerHigh,
      onColor: colors.onSurface,
      action: () => showAddRecordSheet(context),
    ),
    _ => (
      icon: Icons.monitor_weight_outlined,
      label: '体重',
      color: colors.primaryContainer,
      onColor: colors.onPrimaryContainer,
      action: () => showHealthRecordSheet(context, type: 'weight'),
    ),
  };
}

class _TodayCard extends ConsumerWidget {
  const _TodayCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final selectedPetId = ref.watch(selectedPetIdProvider).value;
    final reminders = selectedPetId == null
        ? const AsyncValue<List<Reminder>>.loading()
        : ref.watch(todayRemindersProvider(selectedPetId));

    return Card(
      color: colors.surfaceContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: reminders.when(
          loading: () => const _TodayLoading(),
          error: (error, _) => _TodayMessage(
            icon: Icons.error_outline_rounded,
            title: '提醒加载失败',
            message: _errorMessage(error),
            action: IconButton.filledTonal(
              tooltip: '新增提醒',
              onPressed: selectedPetId == null
                  ? null
                  : () => showReminderSheet(context),
              icon: const Icon(Icons.add_alarm_rounded),
            ),
          ),
          data: (items) {
            if (items.isEmpty) {
              return _TodayMessage(
                icon: Icons.task_alt_rounded,
                title: '今天轻轻松松',
                message: '暂时没有待完成的提醒',
                action: IconButton.filledTonal(
                  tooltip: '新增提醒',
                  onPressed: () => showReminderSheet(context),
                  icon: const Icon(Icons.add_alarm_rounded),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: colors.primaryContainer,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Icon(
                        Icons.notifications_active_outlined,
                        color: colors.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        '今天 ${items.length} 个提醒',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    IconButton.filledTonal(
                      tooltip: '新增提醒',
                      onPressed: () => showReminderSheet(context),
                      icon: const Icon(Icons.add_alarm_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                for (final reminder in items.take(4)) ...[
                  _ReminderTile(reminder: reminder),
                  if (reminder != items.take(4).last) const Divider(height: 10),
                ],
                if (items.length > 4) ...[
                  const SizedBox(height: 8),
                  Text(
                    '还有 ${items.length - 4} 个提醒未显示',
                    style: TextStyle(color: colors.onSurfaceVariant),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TodayLoading extends StatelessWidget {
  const _TodayLoading();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        SizedBox(width: 16),
        Text('正在读取今天的提醒'),
      ],
    );
  }
}

class _TodayMessage extends StatelessWidget {
  const _TodayMessage({
    required this.icon,
    required this.title,
    required this.message,
    required this.action,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: colors.primaryContainer,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(icon, color: colors.onPrimaryContainer),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(message),
            ],
          ),
        ),
        action,
      ],
    );
  }
}

class _ReminderTile extends ConsumerStatefulWidget {
  const _ReminderTile({required this.reminder});

  final Reminder reminder;

  @override
  ConsumerState<_ReminderTile> createState() => _ReminderTileState();
}

class _ReminderTileState extends ConsumerState<_ReminderTile> {
  var _isSaving = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: colors.surfaceContainerHighest,
        child: Icon(_reminderIcon(widget.reminder.sourceType), size: 20),
      ),
      title: Text(widget.reminder.title),
      subtitle: Text(
        '${_formatReminderTime(widget.reminder.scheduledAt)} · ${_sourceTypeLabel(widget.reminder.sourceType)}',
      ),
      trailing: Wrap(
        spacing: 4,
        children: [
          IconButton(
            tooltip: '稍后提醒',
            onPressed: _isSaving ? null : _snooze,
            icon: const Icon(Icons.snooze_rounded),
          ),
          IconButton.filledTonal(
            tooltip: '完成',
            onPressed: _isSaving ? null : _complete,
            icon: const Icon(Icons.check_rounded),
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
          type: _careTypeForReminder(widget.reminder),
          prefill: _carePrefillFromReminder(widget.reminder),
          afterSave: (_) => _markCompleted(result: '已完成并记录护理'),
        );
      } else {
        await showHealthRecordSheet(
          context,
          type: _recordTypeForReminder(widget.reminder),
          prefill: _prefillFromReminder(widget.reminder),
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
                    type: _careTypeForReminder(widget.reminder),
                    occurredAt: DateTime.now(),
                    prefill: _carePrefillFromReminder(widget.reminder),
                  ),
                );
          } else {
            await ref
                .read(healthRecordRepositoryProvider)
                .create(
                  healthRecordDraftFromPrefill(
                    petId: petId,
                    type: _recordTypeForReminder(widget.reminder),
                    occurredAt: DateTime.now(),
                    prefill: _prefillFromReminder(widget.reminder),
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
      _draftFromReminder(
        widget.reminder,
        scheduledAt: repeatRule.nextOccurrence(widget.reminder.scheduledAt),
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
        _draftFromReminder(
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(success)));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_errorMessage(error))));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}

Future<void> showReminderSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    sheetAnimationStyle: const AnimationStyle(
      duration: AppMotion.medium,
      reverseDuration: AppMotion.fast,
    ),
    builder: (_) => const _ReminderSheet(),
  );
}

class _ReminderSheet extends ConsumerStatefulWidget {
  const _ReminderSheet();

  @override
  ConsumerState<_ReminderSheet> createState() => _ReminderSheetState();
}

class _ReminderSheetState extends ConsumerState<_ReminderSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _recordTitleController = TextEditingController();
  final _recordNoteController = TextEditingController();
  final _recordValueController = TextEditingController();
  final _customUnitController = TextEditingController();
  final _detailControllers = <String, TextEditingController>{};
  final _carePlaceController = TextEditingController();
  final _careNoteController = TextEditingController();
  final _careDetailControllers = <String, TextEditingController>{};
  late DateTime _date;
  TimeOfDay _time = TimeOfDay.now();
  String _sourceType = 'manual';
  String _completionMode = 'none';
  String _completionTarget = 'health';
  String _recordType = 'custom';
  String _careType = 'bath';
  String? _recordUnit;
  String _repeatMode = 'once';
  int _intervalDays = 2;
  final Set<int> _weekdays = {DateTime.now().weekday};
  var _isSaving = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _date = DateTime(now.year, now.month, now.day);
    _recordUnit = healthRecordSpecFor(_recordType).defaultUnit;
    _syncReminderDetailControllers();
    _syncCareReminderDetailControllers();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _recordTitleController.dispose();
    _recordNoteController.dispose();
    _recordValueController.dispose();
    _customUnitController.dispose();
    _carePlaceController.dispose();
    _careNoteController.dispose();
    for (final controller in _detailControllers.values) {
      controller.dispose();
    }
    for (final controller in _careDetailControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final recordSpec = healthRecordSpecFor(_recordType);
    final careSpec = careActivitySpecFor(_careType);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        8,
        20,
        MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('新增提醒', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: _sourceType,
                    decoration: const InputDecoration(labelText: '提醒目的'),
                    items: const [
                      DropdownMenuItem(value: 'manual', child: Text('普通提醒')),
                      DropdownMenuItem(value: 'food', child: Text('喂食')),
                      DropdownMenuItem(value: 'water', child: Text('饮水')),
                      DropdownMenuItem(value: 'medication', child: Text('用药')),
                      DropdownMenuItem(value: 'vaccine', child: Text('疫苗')),
                      DropdownMenuItem(value: 'deworming', child: Text('驱虫')),
                      DropdownMenuItem(value: 'symptom', child: Text('症状观察')),
                      DropdownMenuItem(value: 'bath', child: Text('洗澡')),
                      DropdownMenuItem(value: 'oral', child: Text('口腔护理')),
                      DropdownMenuItem(value: 'combing', child: Text('梳毛')),
                      DropdownMenuItem(value: 'styling', child: Text('美容')),
                      DropdownMenuItem(value: 'nail', child: Text('指甲护理')),
                      DropdownMenuItem(value: 'ear', child: Text('耳部护理')),
                      DropdownMenuItem(value: 'eye', child: Text('眼部护理')),
                      DropdownMenuItem(value: 'paw', child: Text('足爪护理')),
                      DropdownMenuItem(
                        value: 'environment',
                        child: Text('用品 / 环境清洁'),
                      ),
                      DropdownMenuItem(value: 'visit', child: Text('就诊 / 复诊')),
                    ],
                    onChanged: (value) => _changeSourceType(value!),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _titleController,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      labelText: '提醒内容 *',
                      prefixIcon: Icon(Icons.notifications_none_rounded),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? '提醒内容不能为空'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.event_outlined),
                    title: const Text('提醒日期'),
                    subtitle: Text(_formatReminderDate(_date)),
                    trailing: const Icon(Icons.edit_outlined),
                    onTap: _pickDate,
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.schedule_rounded),
                    title: const Text('提醒时间'),
                    subtitle: Text(_time.format(context)),
                    trailing: const Icon(Icons.edit_outlined),
                    onTap: _pickTime,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _repeatMode,
                    decoration: const InputDecoration(labelText: '提醒频率'),
                    items: const [
                      DropdownMenuItem(value: 'once', child: Text('一次')),
                      DropdownMenuItem(value: 'daily', child: Text('每天')),
                      DropdownMenuItem(
                        value: 'interval_d',
                        child: Text('每隔 N 天'),
                      ),
                      DropdownMenuItem(
                        value: 'weekly_days',
                        child: Text('每周指定日期'),
                      ),
                      DropdownMenuItem(value: 'monthly', child: Text('每月')),
                    ],
                    onChanged: (value) => setState(() {
                      _repeatMode = value!;
                    }),
                  ),
                  if (_repeatMode == 'interval_d') ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Expanded(child: Text('间隔天数')),
                        IconButton(
                          tooltip: '减少',
                          onPressed: _intervalDays <= 2
                              ? null
                              : () => setState(() {
                                  _intervalDays--;
                                }),
                          icon: const Icon(Icons.remove_rounded),
                        ),
                        Text('$_intervalDays 天'),
                        IconButton(
                          tooltip: '增加',
                          onPressed: () => setState(() {
                            _intervalDays++;
                          }),
                          icon: const Icon(Icons.add_rounded),
                        ),
                      ],
                    ),
                  ],
                  if (_repeatMode == 'weekly_days') ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (var day = 1; day <= 7; day++)
                          FilterChip(
                            label: Text(_weekdayLabel(day)),
                            selected: _weekdays.contains(day),
                            onSelected: (selected) => setState(() {
                              if (selected) {
                                _weekdays.add(day);
                              } else if (_weekdays.length > 1) {
                                _weekdays.remove(day);
                              }
                            }),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '每周 ${_weekdays.length} 次',
                      style: TextStyle(color: colors.onSurfaceVariant),
                    ),
                  ],
                  const SizedBox(height: 18),
                  Text(
                    '完成后动作',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SegmentedButton<String>(
                    showSelectedIcon: false,
                    segments: const [
                      ButtonSegment(value: 'none', label: Text('只完成')),
                      ButtonSegment(value: 'ask_record', label: Text('填写')),
                      ButtonSegment(value: 'auto_record', label: Text('自动记录')),
                    ],
                    selected: {_completionMode},
                    onSelectionChanged: (selection) {
                      setState(() => _completionMode = selection.single);
                    },
                  ),
                  if (_completionMode != 'none') ...[
                    const SizedBox(height: 14),
                    SegmentedButton<String>(
                      showSelectedIcon: false,
                      segments: const [
                        ButtonSegment(value: 'health', label: Text('健康')),
                        ButtonSegment(value: 'care', label: Text('护理')),
                      ],
                      selected: {_completionTarget},
                      onSelectionChanged: (selection) {
                        setState(() => _completionTarget = selection.single);
                      },
                    ),
                    const SizedBox(height: 12),
                    if (_completionTarget == 'health') ...[
                      DropdownButtonFormField<String>(
                        initialValue: _recordType,
                        decoration: const InputDecoration(labelText: '绑定健康类型'),
                        items: healthRecordLabels.entries
                            .map(
                              (entry) => DropdownMenuItem(
                                value: entry.key,
                                child: Text(entry.value),
                              ),
                            )
                            .toList(),
                        onChanged: (value) => _changeRecordType(value!),
                      ),
                      if (_completionMode == 'auto_record') ...[
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _recordTitleController,
                          decoration: InputDecoration(
                            labelText: '记录标题',
                            hintText: recordSpec.defaultTitle,
                          ),
                        ),
                        for (final field in recordSpec.fields) ...[
                          const SizedBox(height: 12),
                          _ReminderDetailField(
                            spec: field,
                            controller: _detailControllers[field.key]!,
                            requireValue: true,
                          ),
                        ],
                        if (recordSpec.hasNumericValue) ...[
                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  controller: _recordValueController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  decoration: InputDecoration(
                                    labelText: '${recordSpec.numericLabel} *',
                                  ),
                                  validator: (value) {
                                    final text = value?.trim() ?? '';
                                    if (text.isEmpty) {
                                      return '自动记录请预填写${recordSpec.numericLabel}';
                                    }
                                    return double.tryParse(text) == null
                                        ? '请输入有效数值'
                                        : null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 2,
                                child: _ReminderUnitField(
                                  unit: _recordUnit,
                                  customController: _customUnitController,
                                  options: recordSpec.unitOptions,
                                  onChanged: (value) =>
                                      setState(() => _recordUnit = value),
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _recordNoteController,
                          maxLines: 2,
                          decoration: InputDecoration(
                            labelText: recordSpec.noteLabel,
                          ),
                        ),
                      ],
                    ] else ...[
                      DropdownButtonFormField<String>(
                        initialValue: _careType,
                        decoration: const InputDecoration(labelText: '绑定护理类型'),
                        items: careActivityLabels.entries
                            .where((entry) => entry.key != 'walk')
                            .map(
                              (entry) => DropdownMenuItem(
                                value: entry.key,
                                child: Text(entry.value),
                              ),
                            )
                            .toList(),
                        onChanged: (value) => _changeCareType(value!),
                      ),
                      if (_completionMode == 'auto_record') ...[
                        for (final field in careSpec.fields) ...[
                          const SizedBox(height: 12),
                          _ReminderCareDetailField(
                            spec: field,
                            controller: _careDetailControllers[field.key]!,
                            requireValue: true,
                          ),
                        ],
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _carePlaceController,
                          decoration: InputDecoration(
                            labelText: careSpec.placeLabel,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _careNoteController,
                          maxLines: 2,
                          decoration: InputDecoration(
                            labelText: careSpec.noteLabel,
                          ),
                        ),
                      ],
                    ],
                  ],
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: _isSaving ? null : _save,
                    icon: const Icon(Icons.save_rounded),
                    label: Text(_isSaving ? '保存中...' : '保存提醒'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _completionMode == 'none'
                  ? '提醒只保存在本机，系统通知接入前会显示在首页今天列表。'
                  : '绑定记录后，完成提醒可以自动生成记录，或先打开表单让你确认后再保存。',
              style: TextStyle(color: colors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked != null) setState(() => _time = picked);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
    );
    if (picked != null) {
      setState(() => _date = DateTime(picked.year, picked.month, picked.day));
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      final petId = await ref.read(petRepositoryProvider).ensureSelectedPetId();
      final now = DateTime.now();
      var scheduledAt = DateTime(
        _date.year,
        _date.month,
        _date.day,
        _time.hour,
        _time.minute,
      );
      if (_repeatMode != 'once' && scheduledAt.isBefore(now)) {
        scheduledAt = scheduledAt.add(const Duration(days: 1));
      }
      if (_repeatMode == 'once' && scheduledAt.isBefore(now)) {
        throw const FormatException('一次提醒的日期和时间不能早于现在');
      }

      final reminder = await ref
          .read(reminderRepositoryProvider)
          .create(
            ReminderDraft(
              petId: petId,
              sourceType: _sourceType,
              title: _titleController.text.trim(),
              scheduledAt: scheduledAt,
              repeatRule: _buildRepeatRule(),
              completionMode: _completionMode,
              completionTarget: _completionTarget,
              recordType:
                  _completionMode == 'none' || _completionTarget != 'health'
                  ? null
                  : _recordType,
              recordTitle:
                  _completionMode != 'auto_record' ||
                      _completionTarget != 'health'
                  ? null
                  : _recordTitleController.text.trim(),
              recordNumericValue:
                  _completionMode != 'auto_record' ||
                      _completionTarget != 'health'
                  ? null
                  : double.tryParse(_recordValueController.text.trim()),
              recordUnit:
                  _completionMode != 'auto_record' ||
                      _completionTarget != 'health'
                  ? null
                  : _resolvedReminderUnit(healthRecordSpecFor(_recordType)),
              recordNote:
                  _completionMode != 'auto_record' ||
                      _completionTarget != 'health'
                  ? ''
                  : _recordNoteController.text,
              recordDetails:
                  _completionMode != 'auto_record' ||
                      _completionTarget != 'health'
                  ? const {}
                  : _collectReminderDetails(),
              careType: _completionMode == 'none' || _completionTarget != 'care'
                  ? null
                  : _careType,
              carePlace:
                  _completionMode == 'auto_record' &&
                      _completionTarget == 'care'
                  ? _carePlaceController.text
                  : '',
              careNote:
                  _completionMode == 'auto_record' &&
                      _completionTarget == 'care'
                  ? _careNoteController.text
                  : '',
              careDetails:
                  _completionMode == 'auto_record' &&
                      _completionTarget == 'care'
                  ? _collectCareReminderDetails()
                  : const {},
            ),
          );
      await notificationService.scheduleReminder(reminder);
      if (!mounted) return;
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_errorMessage(error))));
    }
  }

  void _changeSourceType(String value) {
    setState(() {
      _sourceType = value;
      if (_titleController.text.trim().isEmpty) {
        _titleController.text = _defaultReminderTitle(value);
      }
      if (value != 'manual' && value != 'visit') {
        _completionMode = _completionMode == 'none'
            ? 'ask_record'
            : _completionMode;
        if (isCareReminderSource(value)) {
          _completionTarget = 'care';
          _setCareType(value);
        } else {
          _completionTarget = 'health';
          _setRecordType(defaultHealthRecordTypeForReminder(value));
        }
      }
    });
  }

  void _changeRecordType(String value) {
    setState(() => _setRecordType(value));
  }

  void _changeCareType(String value) {
    setState(() => _setCareType(value));
  }

  void _setRecordType(String value) {
    _recordType = value;
    final spec = healthRecordSpecFor(value);
    _recordUnit = spec.defaultUnit;
    _recordValueController.clear();
    _customUnitController.clear();
    if (_recordTitleController.text.trim().isEmpty) {
      _recordTitleController.text = spec.defaultTitle;
    }
    _syncReminderDetailControllers();
  }

  void _setCareType(String value) {
    _careType = value;
    _carePlaceController.clear();
    _careNoteController.clear();
    _syncCareReminderDetailControllers();
  }

  void _syncReminderDetailControllers() {
    final spec = healthRecordSpecFor(_recordType);
    final nextKeys = spec.fields.map((field) => field.key).toSet();
    for (final key in _detailControllers.keys.toList()) {
      if (!nextKeys.contains(key)) {
        _detailControllers.remove(key)?.dispose();
      }
    }
    for (final field in spec.fields) {
      _detailControllers.putIfAbsent(field.key, () => TextEditingController());
    }
  }

  Map<String, String> _collectReminderDetails() {
    return {
      for (final entry in _detailControllers.entries)
        if (entry.value.text.trim().isNotEmpty)
          entry.key: entry.value.text.trim(),
    };
  }

  void _syncCareReminderDetailControllers() {
    final spec = careActivitySpecFor(_careType);
    final nextKeys = spec.fields.map((field) => field.key).toSet();
    for (final key in _careDetailControllers.keys.toList()) {
      if (!nextKeys.contains(key)) {
        _careDetailControllers.remove(key)?.dispose();
      }
    }
    for (final field in spec.fields) {
      _careDetailControllers.putIfAbsent(
        field.key,
        () => TextEditingController(),
      );
    }
  }

  Map<String, String> _collectCareReminderDetails() {
    return {
      for (final entry in _careDetailControllers.entries)
        if (entry.value.text.trim().isNotEmpty)
          entry.key: entry.value.text.trim(),
    };
  }

  String? _buildRepeatRule() {
    return switch (_repeatMode) {
      'daily' => 'daily',
      'monthly' => 'monthly',
      'interval_d' => 'interval:${_intervalDays}d',
      'weekly_days' => 'weekly_days:${(_weekdays.toList()..sort()).join(',')}',
      _ => null,
    };
  }

  String? _resolvedReminderUnit(HealthRecordTypeSpec spec) {
    if (!spec.hasNumericValue) return null;
    if (_recordUnit == '__custom__') {
      final custom = _customUnitController.text.trim();
      return custom.isEmpty ? spec.defaultUnit : custom;
    }
    return _recordUnit ?? spec.defaultUnit;
  }
}

class _ReminderDetailField extends StatelessWidget {
  const _ReminderDetailField({
    required this.spec,
    required this.controller,
    required this.requireValue,
  });

  final HealthRecordFieldSpec spec;
  final TextEditingController controller;
  final bool requireValue;

  @override
  Widget build(BuildContext context) {
    final required = requireValue && spec.required;
    if (spec.isChoice) {
      final currentValue = spec.options.contains(controller.text)
          ? controller.text
          : null;
      return DropdownButtonFormField<String>(
        initialValue: currentValue,
        decoration: InputDecoration(
          labelText: '${spec.label}${required ? ' *' : ''}',
        ),
        items: [
          const DropdownMenuItem(value: '', child: Text('完成时填写')),
          for (final option in spec.options)
            DropdownMenuItem(value: option, child: Text(option)),
        ],
        validator: (value) => required && (value == null || value.isEmpty)
            ? '请选择${spec.label}'
            : null,
        onChanged: (value) => controller.text = value ?? '',
      );
    }
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: '${spec.label}${required ? ' *' : ''}',
        hintText: requireValue ? spec.placeholder : '完成时可再填写',
      ),
      validator: (value) => required && (value == null || value.trim().isEmpty)
          ? '请填写${spec.label}'
          : null,
    );
  }
}

class _ReminderUnitField extends StatelessWidget {
  const _ReminderUnitField({
    required this.unit,
    required this.customController,
    required this.options,
    required this.onChanged,
  });

  final String? unit;
  final TextEditingController customController;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final knownUnit = unit != null && options.contains(unit);
    if (unit != null && unit != '__custom__' && !knownUnit) {
      customController.text = unit!;
    }
    return Column(
      children: [
        DropdownButtonFormField<String>(
          initialValue: knownUnit ? unit : '__custom__',
          decoration: const InputDecoration(labelText: '单位'),
          items: [
            for (final option in options)
              DropdownMenuItem(value: option, child: Text(option)),
            const DropdownMenuItem(value: '__custom__', child: Text('自定义')),
          ],
          onChanged: onChanged,
        ),
        if (!knownUnit && unit != null) ...[
          const SizedBox(height: 8),
          TextFormField(
            controller: customController,
            decoration: const InputDecoration(labelText: '自定义单位'),
            validator: (value) =>
                value == null || value.trim().isEmpty ? '请填写单位' : null,
          ),
        ],
      ],
    );
  }
}

class _ReminderCareDetailField extends StatelessWidget {
  const _ReminderCareDetailField({
    required this.spec,
    required this.controller,
    required this.requireValue,
  });

  final CareActivityFieldSpec spec;
  final TextEditingController controller;
  final bool requireValue;

  @override
  Widget build(BuildContext context) {
    final required = requireValue && spec.required;
    if (spec.isChoice) {
      final currentValue = spec.options.contains(controller.text)
          ? controller.text
          : null;
      return DropdownButtonFormField<String>(
        initialValue: currentValue,
        decoration: InputDecoration(
          labelText: '${spec.label}${required ? ' *' : ''}',
        ),
        items: [
          const DropdownMenuItem(value: '', child: Text('完成时填写')),
          for (final option in spec.options)
            DropdownMenuItem(value: option, child: Text(option)),
        ],
        validator: (value) => required && (value == null || value.isEmpty)
            ? '请选择${spec.label}'
            : null,
        onChanged: (value) => controller.text = value ?? '',
      );
    }
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: '${spec.label}${required ? ' *' : ''}',
        hintText: requireValue ? spec.placeholder : '完成时可再填写',
      ),
      validator: (value) => required && (value == null || value.trim().isEmpty)
          ? '请填写${spec.label}'
          : null,
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

String _defaultReminderTitle(String sourceType) {
  return switch (sourceType) {
    'food' => '喂食',
    'water' => '提醒饮水',
    'medication' => '用药',
    'vaccine' => '疫苗接种',
    'deworming' => '驱虫',
    'symptom' => '症状观察',
    'bath' => '洗澡',
    'oral' => '口腔护理',
    'combing' => '梳毛',
    'styling' => '美容',
    'nail' => '指甲护理',
    'ear' => '耳部护理',
    'eye' => '眼部护理',
    'paw' => '足爪护理',
    'environment' => '用品 / 环境清洁',
    'visit' => '就诊 / 复诊',
    _ => '',
  };
}

String _formatReminderDate(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

String _formatReminderTime(DateTime date) {
  final local = date.toLocal();
  return '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
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

String _weekdayLabel(int day) {
  return const {
    1: '周一',
    2: '周二',
    3: '周三',
    4: '周四',
    5: '周五',
    6: '周六',
    7: '周日',
  }[day]!;
}

String _errorMessage(Object error) {
  if (error is FormatException) return error.message;
  if (error is StateError) return error.message;
  return '操作失败，请稍后重试';
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.auto_graph_rounded, color: colors.primary),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    '记录越连续，变化越清晰',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                for (var index = 0; index < 7; index++) ...[
                  if (index > 0) const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: AppMotion.medium,
                          height: index == 6 ? 38 : 8,
                          decoration: BoxDecoration(
                            color: index == 6
                                ? colors.primary
                                : colors.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          ['一', '二', '三', '四', '五', '六', '日'][index],
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '完成第一条记录，开启本周健康时间线',
              style: TextStyle(color: colors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            color: colors.onSecondaryContainer,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '本地趋势提示',
                  style: TextStyle(
                    color: colors.onSecondaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '毛健康只和狗狗自己的历史比较，并清楚说明每条提示为什么出现。',
                  style: TextStyle(
                    color: colors.onSecondaryContainer,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dueCount = ref.watch(dueRecommendationCountProvider);
    return IconButton.filledTonal(
      tooltip: '通知中心',
      onPressed: () => context.push('/home/notifications'),
      icon: dueCount > 0
          ? Badge(
              label: Text('$dueCount'),
              child: const Icon(Icons.notifications_none_rounded),
            )
          : const Icon(Icons.notifications_none_rounded),
    );
  }
}
