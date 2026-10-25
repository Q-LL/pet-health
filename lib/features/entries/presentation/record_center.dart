import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database_provider.dart';
import '../../../core/design/design.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/l10n/labels.dart';
import '../../today/application/today_providers.dart';
import '../domain/entry_codes.dart';

/// 打开记录中心，返回选中的记录类型；直接关闭时返回 `null`。
Future<EntryType?> showRecordCenter(BuildContext context) =>
    showModalBottomSheet<EntryType>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const RecordCenter(),
    );

enum _Group { daily, care, health, more }

/// 记录中心：按类别列出所有能记的事。今天页只放常用的几项，其余都在这里。
class RecordCenter extends ConsumerWidget {
  const RecordCenter({super.key});

  static const _groups = [
    (
      _Group.daily,
      [EntryType.meal, EntryType.water, EntryType.potty, EntryType.walk],
    ),
    (
      _Group.care,
      [
        EntryType.brushing,
        EntryType.bath,
        EntryType.grooming,
        EntryType.earCheck,
      ],
    ),
    (
      _Group.health,
      [
        EntryType.weight,
        EntryType.symptom,
        EntryType.medication,
        EntryType.vetTest,
      ],
    ),
    (
      _Group.more,
      [
        EntryType.parasitePrevention,
        EntryType.vaccine,
        EntryType.otherCare,
        EntryType.custom,
      ],
    ),
  ];

  /// 所有记录类型都要出现在记录中心里。
  static List<EntryType> get types => [
    for (final (_, types) in _groups) ...types,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final walk = ref.watch(activeWalkProvider).value;

    String? caption(EntryType type) {
      if (type != EntryType.walk || walk == null) return null;
      final minutes = ref
          .read(clockProvider)()
          .difference(walk.startedAt ?? walk.occurredAt)
          .inMinutes;
      return l.captionWalking(math.max(minutes, 0));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(22, 0, 22, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(l.recordCenterTitle, style: text.headlineSmall),
              ),
              IconButton(
                tooltip: l.sheetClose,
                onPressed: () => Navigator.of(context).pop(),
                style: IconButton.styleFrom(
                  backgroundColor: PawColors.subtle,
                  minimumSize: const Size(44, 44),
                ),
                icon: const PawIcon(PawGlyph.close, size: 18),
              ),
            ],
          ),
          for (final (group, types) in _groups) ...[
            const SizedBox(height: 18),
            Text(switch (group) {
              _Group.daily => l.recordGroupDaily,
              _Group.care => l.recordGroupCare,
              _Group.health => l.recordGroupHealth,
              _Group.more => l.recordGroupMore,
            }, style: text.titleSmall?.copyWith(color: PawColors.inkMuted)),
            const SizedBox(height: 10),
            QuickLogGrid(
              children: [
                for (final type in types)
                  QuickLogButton(
                    size: 56,
                    glyph: PawGlyph.forEntry(type),
                    tone: PawTones.forEntry(type),
                    label: l.entryType(type),
                    caption: caption(type),
                    onTap: () => Navigator.of(context).pop(type),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
