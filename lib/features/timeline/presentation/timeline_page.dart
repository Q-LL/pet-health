import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/shell.dart';
import '../../../core/design/design.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/l10n/labels.dart';
import '../../entries/domain/entry.dart';
import '../../entries/domain/entry_codes.dart';
import '../../entries/domain/entry_groups.dart';
import '../../entries/presentation/entry_summary.dart';
import '../../entries/presentation/log_flow.dart';
import '../../pets/application/current_pet.dart';
import '../../settings/application/display_settings.dart';
import '../../today/application/today_providers.dart';
import '../application/timeline_providers.dart';
import '../domain/timeline_day.dart';

/// 时间线：按天列出所有记录，点一条可以修改或删除。
class TimelinePage extends ConsumerStatefulWidget {
  const TimelinePage({super.key});

  @override
  ConsumerState<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends ConsumerState<TimelinePage> {
  static const _pageSize = 100;

  final _scroll = ScrollController();
  var _limit = _pageSize;
  EntryGroup? _group;

  /// 翻页时新的一页还在读取，先显示已经有的，免得列表闪一下变空。
  List<Entry>? _shown;
  var _hasMore = false;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_loadMoreNearEnd);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _loadMoreNearEnd() {
    if (_hasMore && _scroll.position.extentAfter < 600) {
      setState(() {
        _hasMore = false;
        _limit += _pageSize;
      });
    }
  }

  void _selectGroup(EntryGroup? group) {
    if (group == _group) return;
    setState(() {
      _group = group;
      _limit = _pageSize;
      _shown = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final pet = ref.watch(currentPetProvider);
    if (pet == null) return const SizedBox.shrink();

    final loaded = ref
        .watch(timelineEntriesProvider((limit: _limit, group: _group)))
        .value;
    if (loaded != null) {
      _shown = loaded;
      _hasMore = loaded.length >= _limit;
    }
    final entries = _shown;
    final days = entries == null ? const <TimelineDay>[] : groupByDay(entries);

    return SafeArea(
      bottom: false,
      child: ListView(
        controller: _scroll,
        padding: const EdgeInsets.fromLTRB(
          PawSpace.page,
          26,
          PawSpace.page,
          navClearance,
        ),
        children: [
          Text(l.timelineTitle(pet.name), style: text.headlineMedium),
          const SizedBox(height: PawSpace.lg),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            child: Row(
              children: [
                for (final group in [null, ...EntryGroup.values]) ...[
                  PawChoiceChip(
                    label: group == null ? l.timelineAll : l.entryGroup(group),
                    selected: group == _group,
                    onTap: () => _selectGroup(group),
                  ),
                  const SizedBox(width: PawSpace.sm),
                ],
              ],
            ),
          ),
          const SizedBox(height: PawSpace.lg),
          if (entries != null && entries.isEmpty)
            _Empty(
              message: _group == null ? l.timelineEmpty : l.timelineEmptyGroup,
            )
          else
            for (final day in days) ...[
              _DayHeader(date: day.date),
              const SizedBox(height: PawSpace.sm),
              _DayCard(entries: day.entries),
              const SizedBox(height: PawSpace.lg),
            ],
        ],
      ),
    );
  }
}

/// 日期标题："今天""昨天"，其余显示月日和星期，往年的加上年份。
class _DayHeader extends ConsumerWidget {
  const _DayHeader({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final today = ref.watch(todayProvider);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final yesterday = DateTime(today.year, today.month, today.day - 1);
    final label = date == today
        ? l.timelineToday
        : date == yesterday
        ? l.timelineYesterday
        : date.year == today.year
        ? DateFormat.MMMEd(locale).format(date)
        : DateFormat.yMMMEd(locale).format(date);
    return Text(
      label,
      style: Theme.of(
        context,
      ).textTheme.titleSmall?.copyWith(color: PawColors.inkMuted),
    );
  }
}

/// 一天的记录放在同一张白色卡片里，用细线隔开。
class _DayCard extends StatelessWidget {
  const _DayCard({required this.entries});

  final List<Entry> entries;

  @override
  Widget build(BuildContext context) => Material(
    color: PawColors.surface,
    borderRadius: BorderRadius.circular(PawRadii.row),
    clipBehavior: Clip.antiAlias,
    child: Column(
      children: [
        for (var i = 0; i < entries.length; i++) ...[
          if (i > 0)
            const Divider(
              height: 1,
              thickness: 1,
              indent: 70,
              color: PawColors.hairline,
            ),
          _EntryRow(entry: entries[i]),
        ],
      ],
    ),
  );
}

class _EntryRow extends ConsumerWidget {
  const _EntryRow({required this.entry});

  final Entry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final tone = PawTones.forEntry(entry.type);
    final summary = entry.isActiveWalk
        ? '${l.entryType(EntryType.walk)} · ${l.timelineWalking}'
        : l.entrySummary(entry, ref.watch(displayUnitsProvider));
    final time = MaterialLocalizations.of(
      context,
    ).formatTimeOfDay(TimeOfDay.fromDateTime(entry.occurredAt));
    final note = entry.note.trim();

    return InkWell(
      // 正在进行的遛狗要先结束才能修改。
      onTap: entry.isActiveWalk ? null : () => editEntry(context, entry),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 16, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: tone.fill,
                shape: BoxShape.circle,
              ),
              child: PawIcon(
                PawGlyph.forEntry(entry.type),
                size: 22,
                color: tone.onFill,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(summary, style: text.bodyMedium),
                    if (note.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        note,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: text.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                time,
                style: text.labelMedium?.copyWith(color: PawColors.inkMuted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: PawSpace.xl),
    child: Column(
      children: [
        const Sticker(StickerArt.comb, size: 120, turns: -0.017),
        const SizedBox(height: PawSpace.lg),
        Text(
          message,
          textAlign: TextAlign.center,
          style: PawTextStyles.of(
            context,
          ).note.copyWith(color: PawColors.inkMuted),
        ),
      ],
    ),
  );
}
