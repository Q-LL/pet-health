import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database_provider.dart';
import '../../../core/design/design.dart';
import '../../../core/l10n/app_locale.dart';
import '../../pets/data/pets_repository.dart';
import '../../settings/application/display_settings.dart';
import '../application/log_toast.dart';
import '../application/quick_log.dart';
import '../data/entries_repository.dart';
import '../domain/entry.dart';
import '../domain/entry_codes.dart';
import 'entry_sheet.dart';
import 'entry_summary.dart';

/// 一键记录：能直接记的记好后弹提示条，需要填内容的打开面板。
Future<void> quickLogEntry(
  BuildContext context,
  WidgetRef ref, {
  required String petId,
  required EntryType type,
  String? planId,
  String? kind,
}) async {
  final presets = await ref.read(petsRepositoryProvider).getPresets(petId);
  final result = await ref
      .read(quickLogProvider)
      .log(
        petId: petId,
        type: type,
        presets: presets,
        planId: planId,
        kind: kind,
      );
  if (context.mounted) await _showResult(context, ref, result);
}

/// 打开新建记录的面板，保存后弹提示条。
///
/// 正在遛狗时选遛狗，直接结束这次遛狗；没在遛时打开面板，可以补记一次，
/// 也可以现在出发开始计时。
Future<void> openNewEntry(
  BuildContext context,
  WidgetRef ref, {
  required String petId,
  required EntryType type,
}) async {
  if (type == EntryType.walk) {
    final finished = await ref
        .read(entriesRepositoryProvider)
        .finishWalk(petId);
    if (finished != null) {
      ref
          .read(logToastProvider.notifier)
          .show(LogToast(LogToastKind.walkFinished, finished));
      return;
    }
  }
  final presets = await ref.read(petsRepositoryProvider).getPresets(petId);
  if (!context.mounted) return;
  final result = await showEntrySheet(
    context,
    draft: QuickLog.draftFor(
      petId: petId,
      type: type,
      at: ref.read(clockProvider)(),
      presets: presets,
    ),
  );
  if (context.mounted) await _showResult(context, ref, result);
}

Future<void> _showResult(
  BuildContext context,
  WidgetRef ref,
  QuickLogResult? result,
) async {
  final toasts = ref.read(logToastProvider.notifier);
  switch (result) {
    case Logged(:final entry):
      toasts.show(LogToast(LogToastKind.logged, entry));
    case WalkStarted(:final entry):
      toasts.show(LogToast(LogToastKind.walkStarted, entry));
    case WalkFinished(:final entry):
      toasts.show(LogToast(LogToastKind.walkFinished, entry));
    case NeedsDetails(:final draft):
      final saved = await showEntrySheet(context, draft: draft);
      if (context.mounted) await _showResult(context, ref, saved);
    case null:
      break;
  }
}

/// 打开修改记录的面板，可以改内容，也可以删除。正在进行的遛狗要先结束才能修改。
Future<void> editEntry(BuildContext context, Entry entry) async {
  if (entry.isActiveWalk) return;
  await showEntrySheet(
    context,
    entryId: entry.id,
    draft: EntryDraft(
      petId: entry.petId,
      type: entry.type,
      occurredAt: entry.occurredAt,
      planId: entry.planId,
      amount: entry.amount,
      unit: entry.unit,
      details: entry.details,
      label: entry.label,
      note: entry.note,
      startedAt: entry.startedAt,
      endedAt: entry.endedAt,
      distanceM: entry.distanceM,
    ),
  );
}

/// 浮在底栏上方的提示条：可以撤销，也可以补充细节。放在外框里，切换页面时也还在。
class LogToastHost extends ConsumerWidget {
  const LogToastHost({super.key});

  Future<void> _addDetails(
    BuildContext context,
    WidgetRef ref,
    LogToast toast,
  ) async {
    ref.read(logToastProvider.notifier).hide();
    final entry = await ref
        .read(entriesRepositoryProvider)
        .getById(toast.entry.id);
    if (entry == null || !context.mounted) return;
    await editEntry(context, entry);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toast = ref.watch(logToastProvider);
    if (toast == null) return const SizedBox.shrink();
    final l = AppLocalizations.of(context);
    final time = MaterialLocalizations.of(
      context,
    ).formatTimeOfDay(TimeOfDay.fromDateTime(toast.entry.occurredAt));
    final summary = l.entrySummary(
      toast.entry,
      ref.watch(displayUnitsProvider),
    );
    return LoggedToast(
      key: ValueKey(toast.entry.id),
      title: switch (toast.kind) {
        LogToastKind.logged => l.toastLogged,
        LogToastKind.walkStarted => l.toastWalkStarted,
        LogToastKind.walkFinished => l.toastWalkFinished,
      },
      detail: '$summary · $time',
      undoLabel: l.toastUndo,
      onUndo: toast.undoable
          ? () {
              ref.read(logToastProvider.notifier).hide();
              ref.read(entriesRepositoryProvider).delete(toast.entry.id);
            }
          : null,
      moreLabel: l.toastMore,
      onMore: () => _addDetails(context, ref, toast),
    );
  }
}
