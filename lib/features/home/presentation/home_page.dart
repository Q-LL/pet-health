import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../reminders/presentation/reminder_editor.dart';
import '../../reminders/presentation/reminder_presenters.dart';
import '../../reminders/presentation/today_reminder_tile.dart';
import '../../../core/ui/ui.dart';
import '../../care/application/care_controller.dart';
import '../../pets/data/pet_repository.dart';
import '../../pets/domain/pet_profile.dart';
import '../../reminders/data/reminder_repository.dart';
import '../../reminders/domain/reminder_models.dart';
import '../../care/presentation/care_page.dart';
import '../../care/application/care_recommendation.dart';
import '../../care/presentation/care_todo_body.dart';
import '../../settings/presentation/settings_page.dart';
import 'home_companion.dart';
import 'home_sections.dart';
import 'home_quick_actions.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profiles = ref.watch(petsProvider);
    final selected = ref.watch(selectedPetIdProvider);
    final pets = (profiles.value ?? const <PetProfile>[])
        .where((pet) => !pet.isPlaceholder)
        .toList();
    final pet = pets.where((pet) => pet.id == selected.value).firstOrNull;
    final walking = ref.watch(
      careControllerProvider.select(
        (state) => state.activeWalkStartedAt != null,
      ),
    );
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: CustomScrollView(
          key: const PageStorageKey('home-journal'),
          slivers: [
            SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 680),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 104),
                    child: profiles.hasError || selected.hasError
                        ? Column(
                            children: [
                              const Text('暂时无法读取狗狗档案'),
                              TextButton(
                                onPressed: () {
                                  ref.invalidate(petsProvider);
                                  ref.invalidate(selectedPetIdProvider);
                                },
                                child: const Text('重新加载'),
                              ),
                            ],
                          )
                        : profiles.isLoading || selected.isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(40),
                            child: CircularProgressIndicator(),
                          )
                        : EntranceAnimation(
                            offset: const Offset(0, 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                HomeCompanion(pet: pet, pets: pets),
                                if (pet != null) ...[
                                  const SizedBox(height: 24),
                                  const _TodayCard(),
                                  const SizedBox(height: 24),
                                  AppSection(
                                    title: '快速记录',
                                    action: '编辑',
                                    onTap: () => showQuickActionSheet(context),
                                    child: const HomeQuickActions(),
                                  ),
                                  const SizedBox(height: 24),
                                  HomeSignalPreview(petId: pet.id),
                                  const SizedBox(height: 16),
                                  HomeMemoryPreview(petId: pet.id),
                                  const SizedBox(height: 16),
                                  // A running walk lives in the shell's mini bar.
                                  if (!walking) ...[
                                    const HomeWalkCard(),
                                    const SizedBox(height: 24),
                                  ],
                                  HomeHealthPreview(petId: pet.id),
                                  const SizedBox(height: 24),
                                  const HomeCareLinks(),
                                ],
                              ],
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TodayCard extends ConsumerWidget {
  const _TodayCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = ref.watch(selectedPetIdProvider).value;
    final reminders = id == null
        ? const AsyncValue<List<Reminder>>.loading()
        : ref.watch(todayRemindersProvider(id));
    final due = ref
        .watch(careRecommendationsProvider)
        .where((item) => item.isRecommended)
        .toList();
    return SectionCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: reminders.when(
        loading: () => const _TodayLoading(),
        error: (error, _) => _TodayMessage(
          icon: Icons.error_outline_rounded,
          title: '提醒加载失败',
          message: reminderErrorMessage(error),
          action: IconButton(
            tooltip: '重试提醒',
            onPressed: id == null
                ? null
                : () => ref.invalidate(todayRemindersProvider(id)),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ),
        data: (items) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (items.isEmpty && due.isEmpty)
              _TodayMessage(
                icon: Icons.task_alt_rounded,
                title: '今天轻轻松松',
                message: '暂时没有待完成的提醒',
                action: IconButton(
                  tooltip: '新增提醒',
                  onPressed: () => showReminderSheet(context),
                  icon: const Icon(Icons.add_alarm_rounded),
                ),
              ),
            for (final reminder in items.take(3)) ...[
              TodayReminderTile(key: ValueKey(reminder.id), reminder: reminder),
              const Divider(height: 1),
            ],
            for (final recommendation in due.take(2)) ...[
              DueCareRow(recommendation: recommendation),
              const Divider(height: 1),
            ],
            ListRow(
              title: '查看全部待办',
              onTap: () => context.go(CareSegment.todo.location),
            ),
          ],
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
        Expanded(child: Text('正在读取今天的提醒')),
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
          width: 40,
          height: 40,
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
