import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/shell.dart';
import '../../../core/design/design.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/l10n/unit_format.dart';
import '../../entries/application/quick_log.dart';
import '../../entries/data/entries_repository.dart';
import '../../entries/presentation/entry_sheet.dart';
import '../../entries/presentation/entry_summary.dart';
import '../../pets/application/current_pet.dart';
import '../../pets/domain/pet.dart';
import '../../settings/application/display_settings.dart';
import '../../today/application/today_providers.dart';
import '../application/plan_providers.dart';
import '../domain/plan.dart';
import '../domain/plan_schedule.dart';
import 'plan_labels.dart';
import 'plan_sheet.dart';

/// 计划页：按今天、快到了、还没开始、已暂停、已完成分组列出全部计划。
class PlansPage extends ConsumerWidget {
  const PlansPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final pet = ref.watch(currentPetProvider);
    if (pet == null) return const SizedBox.shrink();
    final statuses =
        ref.watch(currentPlanStatusesProvider).value ?? const <PlanStatus>[];

    bool active(PlanStatus s) => !s.plan.paused;
    final groups = <(String, List<PlanStatus>)>[
      (
        l.groupToday,
        [
          for (final s in statuses)
            if (active(s) &&
                (s.due.state == PlanState.due ||
                    s.due.state == PlanState.snoozed))
              s,
        ],
      ),
      (
        l.groupSoon,
        [
          for (final s in statuses)
            if (active(s) && s.due.state == PlanState.upcoming) s,
        ],
      ),
      (
        l.groupNotStarted,
        [
          for (final s in statuses)
            if (active(s) && s.due.state == PlanState.notStarted) s,
        ],
      ),
      (
        l.groupPaused,
        [
          for (final s in statuses)
            if (!active(s)) s,
        ],
      ),
      (
        l.groupDone,
        [
          for (final s in statuses)
            if (active(s) && s.due.state == PlanState.completed) s,
        ],
      ),
    ];

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          PawSpace.page,
          26,
          PawSpace.page,
          navClearance,
        ),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.plansTitle(pet.name), style: text.headlineMedium),
                    const SizedBox(height: 6),
                    Text(l.plansSubtitle, style: text.bodySmall),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: () => showPlanSheet(context, petId: pet.id),
                icon: const PawIcon(
                  PawGlyph.plus,
                  size: 16,
                  color: PawColors.ink,
                  strokeWidth: 3.4,
                ),
                label: Text(l.plansNew),
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (statuses.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                children: [
                  const Sticker(StickerArt.star, size: 96, turns: -0.02),
                  const SizedBox(height: 16),
                  Text(l.plansEmpty, style: text.bodySmall),
                ],
              ),
            ),
          for (final (title, items) in groups)
            if (items.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 10),
                child: Text(
                  title,
                  style: text.titleSmall?.copyWith(
                    color: title == l.groupToday
                        ? PawColors.coralText
                        : PawColors.inkMuted,
                  ),
                ),
              ),
              for (final (index, status) in items.indexed) ...[
                _PlanRow(pet: pet, status: status, tilt: index.isEven),
                const SizedBox(height: 10),
              ],
            ],
        ],
      ),
    );
  }
}

class _PlanRow extends ConsumerWidget {
  const _PlanRow({required this.pet, required this.status, required this.tilt});

  final Pet pet;
  final PlanStatus status;
  final bool tilt;

  Future<void> _logFirst(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final plan = status.plan;
    final result = await ref
        .read(quickLogProvider)
        .log(
          petId: pet.id,
          type: plan.entryType,
          presets: ref.read(currentPresetsProvider).value,
          planId: plan.id,
          kind: plan.entryKind,
        );
    if (!context.mounted) return;
    switch (result) {
      case Logged(:final entry) || WalkStarted(:final entry):
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              '${l.toastLogged} · '
              '${l.entrySummary(entry, ref.read(displayUnitsProvider))}',
            ),
            action: SnackBarAction(
              label: l.toastUndo,
              onPressed: () =>
                  ref.read(entriesRepositoryProvider).delete(entry.id),
            ),
          ),
        );
      case WalkFinished():
        break;
      case NeedsDetails(:final draft):
        await showEntrySheet(context, draft: draft);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final plan = status.plan;
    final due = status.due;
    final tone = PawTones.forEntry(plan.entryType);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final dateFormat = ref.watch(displayDateFormatProvider);
    final lastDone = status.lastDoneAt;

    final details = [
      l.schedule(plan.schedule, dateFormat: dateFormat),
      if (due.state == PlanState.notStarted)
        l.planStartsAfterFirstLog
      else if (lastDone != null && plan.schedule is! Once)
        l.planLastDone(DateFormat.MMMd(locale).format(lastDone)),
    ].join(' · ');

    final Widget? trailing = switch (due.state) {
      _ when plan.paused => null,
      PlanState.due => _Chip(l.chipToday, dark: true),
      PlanState.snoozed => _Chip(l.chipLater),
      PlanState.upcoming => switch (due.dueDay) {
        final day? => _Chip(DateFormat.MMMd(locale).format(day)),
        null => null,
      },
      PlanState.notStarted => TextButton(
        onPressed: () => _logFirst(context, ref),
        style: TextButton.styleFrom(
          backgroundColor: PawTones.blush.fill,
          minimumSize: const Size(0, 40),
        ),
        child: Text(l.cardLogIt),
      ),
      PlanState.completed => null,
    };

    return Material(
      color: PawColors.surface,
      borderRadius: BorderRadius.circular(PawRadii.row),
      child: InkWell(
        borderRadius: BorderRadius.circular(PawRadii.row),
        onTap: () => showPlanSheet(context, petId: pet.id, plan: plan),
        child: Opacity(
          opacity: plan.paused ? 0.6 : 1,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
            child: Row(
              children: [
                RotationTransition(
                  turns: AlwaysStoppedAnimation(tilt ? -0.016 : 0.014),
                  child: Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: tone.fill,
                      shape: BoxShape.circle,
                      border: Border.all(color: PawColors.surface, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: tone.onFill.withValues(alpha: 0.18),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: PawIcon(
                      PawGlyph.forEntry(plan.entryType),
                      size: 24,
                      color: tone.onFill,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.planName(plan), style: text.titleMedium),
                      const SizedBox(height: 3),
                      Text(details, style: text.bodySmall),
                    ],
                  ),
                ),
                if (trailing != null) ...[const SizedBox(width: 8), trailing],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.label, {this.dark = false});

  final String label;
  final bool dark;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: dark ? PawColors.ink : PawColors.ground,
      borderRadius: BorderRadius.circular(PawRadii.chip),
    ),
    child: Text(
      label,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: dark ? Colors.white : PawColors.ink,
      ),
    ),
  );
}
