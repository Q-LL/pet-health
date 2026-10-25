import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/shell.dart';
import '../../../core/db/database_provider.dart';
import '../../../core/design/design.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/l10n/unit_format.dart';
import '../../cards/domain/card_codes.dart';
import '../../entries/application/quick_log.dart';
import '../../entries/domain/entry.dart';
import '../../entries/domain/entry_codes.dart';
import '../../entries/domain/entry_details.dart';
import '../../entries/application/log_toast.dart';
import '../../entries/presentation/log_flow.dart';
import '../../pets/application/current_pet.dart';
import '../../pets/data/pets_repository.dart';
import '../../pets/domain/pet.dart';
import '../../plans/application/plan_providers.dart';
import '../../plans/data/plans_repository.dart';
import '../../plans/domain/plan.dart';
import '../../plans/domain/plan_schedule.dart';
import '../../plans/presentation/plan_labels.dart';
import '../../settings/application/display_settings.dart';
import '../application/today_providers.dart';

/// 今天页：问候、一键记录、今天想说的卡片。
class TodayPage extends ConsumerStatefulWidget {
  const TodayPage({super.key});

  @override
  ConsumerState<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends ConsumerState<TodayPage> {
  static const _snooze = Duration(hours: 3);
  static const _maxCards = 3;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final pet = ref.watch(currentPetProvider);
    if (pet == null) return const SizedBox.shrink();

    final presets = ref.watch(currentPresetsProvider).value;
    final entries = ref.watch(todayEntriesProvider).value ?? const <Entry>[];
    final statuses =
        ref.watch(currentPlanStatusesProvider).value ?? const <PlanStatus>[];
    final walk = ref.watch(activeWalkProvider).value;
    final due = [
      for (final status in statuses)
        if (!status.plan.paused && status.due.state == PlanState.due) status,
    ];
    final quickTypes = presets?.quickTypes ?? PetsRepository.defaultQuickTypes;
    final toast = ref.watch(logToastProvider);

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: EdgeInsets.fromLTRB(
          PawSpace.page,
          20,
          PawSpace.page,
          // 提示条出现时多留一段，免得挡住最下面的卡片。
          navClearance + (toast == null ? 0 : 76),
        ),
        children: [
          _Hero(pet: pet),
          const SizedBox(height: 22),
          Text(l.todayQuickLog, style: text.titleLarge),
          const SizedBox(height: 12),
          QuickLogGrid(
            children: [
              for (final type in quickTypes)
                QuickLogButton(
                  glyph: PawGlyph.forEntry(type),
                  tone: PawTones.forEntry(type),
                  label: l.entryType(type),
                  caption: _caption(l, type, entries, presets, walk, due),
                  due:
                      _hasDue(due, type) && !entries.any((e) => e.type == type),
                  justLogged: toast?.entry.type == type,
                  onTap: () =>
                      quickLogEntry(context, ref, petId: pet.id, type: type),
                  onLongPress: () =>
                      openNewEntry(context, ref, petId: pet.id, type: type),
                ),
            ],
          ),
          const SizedBox(height: 26),
          Text(l.todayForYou, style: text.titleLarge),
          const SizedBox(height: 12),
          if (due.isEmpty)
            DailyCard(
              tone: CardTone.of(CardCategory.moment),
              tag: l.cardCategoryMoment,
              body: l.todayNothingDue,
              sticker: StickerArt.star,
              stickerTurns: -0.022,
            )
          else
            for (final status in due.take(_maxCards)) ...[
              _ComingUpCard(
                status: status,
                onLog: () => quickLogEntry(
                  context,
                  ref,
                  petId: pet.id,
                  type: status.plan.entryType,
                  planId: status.plan.id,
                  kind: status.plan.entryKind,
                ),
                onLater: () => ref
                    .read(plansRepositoryProvider)
                    .snooze(
                      status.plan.id,
                      ref.read(clockProvider)().add(_snooze),
                    ),
              ),
              const SizedBox(height: 12),
            ],
        ],
      ),
    );
  }

  static bool _hasDue(List<PlanStatus> due, EntryType type) =>
      due.any((status) => status.plan.entryType == type);

  String _caption(
    AppLocalizations l,
    EntryType type,
    List<Entry> entries,
    PetPresets? presets,
    Entry? walk,
    List<PlanStatus> due,
  ) {
    final ofType = entries.where((e) => e.type == type).toList();
    final count = ofType.length;
    switch (type) {
      case EntryType.meal:
        final total = presets?.mealsPerDay;
        return total == null
            ? l.captionTimes(count)
            : l.captionMeals(count, total);
      case EntryType.water:
        return l.captionWater(count);
      case EntryType.potty:
        return l.captionPoop(
          ofType
              .where(
                (e) =>
                    e.details is PottyDetails &&
                    (e.details as PottyDetails).kind != PottyKind.pee,
              )
              .length,
        );
      case EntryType.walk when walk != null:
        final minutes = ref
            .read(clockProvider)()
            .difference(walk.startedAt ?? walk.occurredAt)
            .inMinutes;
        return l.captionWalking(math.max(minutes, 0));
      default:
        if (count == 0 && _hasDue(due, type)) return l.captionDueToday;
        if (count == 0 && !QuickLog.canLogInstantly(type)) {
          return l.captionTapToLog;
        }
        return l.captionTimes(count);
    }
  }
}

/// 顶部的问候卡片。
class _Hero extends ConsumerWidget {
  const _Hero({required this.pet});

  final Pet pet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final now = ref.watch(clockProvider)();
    final date = DateFormat.MMMEd(
      Localizations.localeOf(context).toLanguageTag(),
    ).format(now);
    final day = pet.dayTogether(now);

    return Container(
      constraints: const BoxConstraints(minHeight: 150),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: PawColors.peach,
        borderRadius: BorderRadius.circular(PawRadii.hero),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -50,
            top: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                color: PawColors.peachDeep,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 8,
            bottom: -10,
            child: Sticker(
              StickerArt.golden,
              size: 128,
              turns: -0.017,
              semanticLabel: pet.name,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 22, 150, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: text.labelMedium?.copyWith(
                    color: const Color(0xFF7A4B3C),
                  ),
                ),
                const SizedBox(height: 6),
                Text(l.todayGreeting(pet.name), style: text.displaySmall),
                if (day != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: PawColors.surface,
                      borderRadius: BorderRadius.circular(PawRadii.chip),
                    ),
                    child: Text(l.dayTogether(day), style: text.labelMedium),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 计划"该做了"的卡片：只说距离上次多少天，不说"逾期""晚了"。
class _ComingUpCard extends ConsumerWidget {
  const _ComingUpCard({
    required this.status,
    required this.onLog,
    required this.onLater,
  });

  final PlanStatus status;
  final VoidCallback onLog;
  final VoidCallback onLater;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final plan = status.plan;
    final name = l.planName(plan);
    final days = status.due.daysSinceLast;
    final schedule = l.schedule(
      plan.schedule,
      dateFormat: ref.watch(displayDateFormatProvider),
    );
    return DailyCard(
      tone: CardTone.of(CardCategory.comingUp),
      tag: l.cardCategoryComingUp,
      meta: '$name · $schedule',
      body: days == null || days == 0
          ? l.cardOnTodaysList(name)
          : l.cardDaysSince(days),
      actions: [
        CardButton(label: l.cardLogIt, primary: true, onPressed: onLog),
        CardButton(label: l.cardLater, onPressed: onLater),
      ],
    );
  }
}
