import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/codes/coded_enum.dart';
import '../../../core/design/design.dart';
import '../../../core/format/date_display.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/l10n/unit_format.dart';
import '../../entries/domain/entry_codes.dart';
import '../../settings/application/display_settings.dart';
import '../data/plans_repository.dart';
import '../domain/plan.dart';
import '../domain/plan_schedule.dart';
import 'plan_labels.dart';

/// 新建或修改一个计划。传 [plan] 时是修改，可以暂停和删除。
Future<void> showPlanSheet(
  BuildContext context, {
  required String petId,
  Plan? plan,
}) => showModalBottomSheet<void>(
  context: context,
  useRootNavigator: true,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (context) => PlanSheet(petId: petId, plan: plan),
);

class PlanSheet extends ConsumerStatefulWidget {
  const PlanSheet({super.key, required this.petId, this.plan});

  final String petId;
  final Plan? plan;

  /// 新建计划时可选的事项。吃饭、喝水、排泄这类每天都做的事不适合做成计划。
  static const selectableTypes = [
    EntryType.brushing,
    EntryType.bath,
    EntryType.grooming,
    EntryType.earCheck,
    EntryType.otherCare,
    EntryType.parasitePrevention,
    EntryType.vetTest,
    EntryType.weight,
    EntryType.walk,
    EntryType.medication,
    EntryType.vaccine,
    EntryType.custom,
  ];

  @override
  ConsumerState<PlanSheet> createState() => _PlanSheetState();
}

class _PlanSheetState extends ConsumerState<PlanSheet> {
  late EntryType _type = widget.plan?.entryType ?? EntryType.brushing;
  late String? _kind = widget.plan?.entryKind;
  late String _title = widget.plan?.title ?? '';
  late bool _paused = widget.plan?.paused ?? false;
  late PlanScheduleKind _scheduleKind =
      widget.plan?.schedule.kind ?? PlanScheduleKind.weekdays;
  var _days = 7;
  var _months = 1;
  var _mask = Weekdays.forTimesPerWeek(3);
  DateTime? _dueAt;
  var _saving = false;

  bool get _editing => widget.plan != null;

  @override
  void initState() {
    super.initState();
    switch (widget.plan?.schedule) {
      case EveryNDays(:final days):
        _days = days;
      case EveryNMonths(:final months):
        _months = months;
      case OnWeekdays(:final mask):
        _mask = mask;
      case Once(:final dueAt):
        _dueAt = dueAt;
      case null:
    }
  }

  PlanSchedule? get _schedule => switch (_scheduleKind) {
    PlanScheduleKind.everyNDays => EveryNDays(_days),
    PlanScheduleKind.everyNMonths => EveryNMonths(_months),
    PlanScheduleKind.weekdays => _mask == 0 ? null : OnWeekdays(_mask),
    PlanScheduleKind.once => switch (_dueAt) {
      final dueAt? => Once(dueAt),
      null => null,
    },
  };

  bool get _valid =>
      _schedule != null &&
      (_type != EntryType.custom || _title.trim().isNotEmpty);

  /// 需要选具体项的事项和可选的项；不选表示同类型的都算。
  static List<CodedEnum> _kindsFor(EntryType type) => switch (type) {
    EntryType.otherCare => OtherCareKind.values,
    EntryType.parasitePrevention => ParasiteCoverage.values,
    EntryType.vetTest => VetTestKind.values,
    _ => const [],
  };

  Future<void> _save() async {
    final schedule = _schedule;
    if (!_valid || schedule == null || _saving) return;
    setState(() => _saving = true);
    final plans = ref.read(plansRepositoryProvider);
    final draft = PlanDraft(
      petId: widget.petId,
      entryType: _type,
      entryKind: _kindsFor(_type).isEmpty ? null : _kind,
      title: _type == EntryType.custom ? _title : null,
      schedule: schedule,
      notifyMinute: widget.plan?.notifyMinute,
      paused: _paused,
    );
    try {
      final plan = widget.plan;
      if (plan == null) {
        await plans.create(draft);
      } else {
        await plans.update(plan.id, draft);
      }
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
    final plan = widget.plan;
    if (plan == null) return;
    final l = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l.planDeleteConfirm(l.planName(plan))),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(foregroundColor: PawColors.inkMuted),
            child: Text(l.actionCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l.actionDelete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(plansRepositoryProvider).delete(plan.id);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _pickDate() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final date = await showDatePicker(
      context: context,
      initialDate: _dueAt ?? today,
      firstDate: today.subtract(const Duration(days: 365)),
      lastDate: today.add(const Duration(days: 365 * 3)),
    );
    if (date != null) setState(() => _dueAt = date);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final dateFormat = ref.watch(displayDateFormatProvider);
    final plan = widget.plan;
    final tone = PawTones.forEntry(_type);
    final kinds = _kindsFor(_type);
    final schedule = _schedule;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 0, 22, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: tone.fill,
                    shape: BoxShape.circle,
                  ),
                  child: PawIcon(
                    PawGlyph.forEntry(_type),
                    size: 28,
                    color: tone.onFill,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    plan == null ? l.planNew : l.planName(plan),
                    style: text.headlineSmall,
                  ),
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
            const SizedBox(height: 22),
            if (!_editing) ...[
              _Label(l.planWhat),
              _Grid(
                children: [
                  for (final type in PlanSheet.selectableTypes)
                    OptionTile(
                      label: l.entryType(type),
                      selected: type == _type,
                      onTap: () => setState(() {
                        _type = type;
                        _kind = null;
                      }),
                    ),
                ],
              ),
              if (kinds.isNotEmpty) ...[
                const SizedBox(height: 18),
                _Label(l.fieldWhat),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final kind in kinds)
                      PawChoiceChip(
                        label: l.option(kind),
                        selected: kind.code == _kind,
                        background: PawColors.subtle,
                        // 再点一次取消：不限具体项。
                        onTap: () => setState(
                          () => _kind = _kind == kind.code ? null : kind.code,
                        ),
                      ),
                  ],
                ),
              ],
              if (_type == EntryType.custom) ...[
                const SizedBox(height: 18),
                TextFormField(
                  initialValue: _title,
                  maxLength: 40,
                  decoration: InputDecoration(
                    labelText: l.planTitleLabel,
                    counterText: '',
                  ),
                  onChanged: (value) => setState(() => _title = value),
                ),
              ],
              const SizedBox(height: 22),
            ],
            _Label(l.planHowOften),
            PillSegmented<PlanScheduleKind>(
              options: PlanScheduleKind.values,
              selected: _scheduleKind,
              labelOf: (kind) => switch (kind) {
                PlanScheduleKind.everyNDays => l.scheduleKindEveryNDays,
                PlanScheduleKind.everyNMonths => l.scheduleKindEveryNMonths,
                PlanScheduleKind.weekdays => l.scheduleKindWeekdays,
                PlanScheduleKind.once => l.scheduleKindOnce,
              },
              onChanged: (kind) => setState(() => _scheduleKind = kind),
            ),
            const SizedBox(height: 16),
            switch (_scheduleKind) {
              PlanScheduleKind.everyNDays => _Stepper(
                label: l.dayCount(_days),
                onLess: _days > 1 ? () => setState(() => _days--) : null,
                onMore: _days < 366 ? () => setState(() => _days++) : null,
              ),
              PlanScheduleKind.everyNMonths => _Stepper(
                label: l.monthCount(_months),
                onLess: _months > 1 ? () => setState(() => _months--) : null,
                onMore: _months < 24 ? () => setState(() => _months++) : null,
              ),
              PlanScheduleKind.weekdays => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (
                    var weekday = DateTime.monday;
                    weekday <= DateTime.sunday;
                    weekday++
                  )
                    PawChoiceChip(
                      label: l.weekdayShort(weekday),
                      selected: Weekdays.contains(_mask, weekday),
                      background: PawColors.subtle,
                      onTap: () =>
                          setState(() => _mask ^= Weekdays.bit(weekday)),
                    ),
                ],
              ),
              PlanScheduleKind.once => OutlinedButton(
                onPressed: _pickDate,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(PawRadii.tile),
                  ),
                  side: const BorderSide(color: PawColors.hairline, width: 2),
                ),
                child: Text(
                  _dueAt == null
                      ? l.planDate
                      : formatDisplayDate(_dueAt!, dateFormat),
                  style: text.titleMedium,
                ),
              ),
            },
            if (schedule != null) ...[
              const SizedBox(height: 10),
              Text(
                l.schedule(schedule, dateFormat: dateFormat),
                style: text.bodySmall,
              ),
            ],
            if (_editing) ...[
              const SizedBox(height: 14),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l.planPause),
                value: _paused,
                onChanged: (value) => setState(() => _paused = value),
              ),
            ],
            const SizedBox(height: 18),
            FilledButton(
              onPressed: _valid && !_saving ? _save : null,
              style: FilledButton.styleFrom(minimumSize: const Size(0, 56)),
              child: Text(l.sheetSave),
            ),
            if (_editing) ...[
              const SizedBox(height: 8),
              TextButton(onPressed: _delete, child: Text(l.planDelete)),
            ],
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.titleSmall?.copyWith(color: PawColors.inkMuted),
    ),
  );
}

/// 两列等大的格子。
class _Grid extends StatelessWidget {
  const _Grid({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final half = (constraints.maxWidth - 10) / 2;
      return Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          for (final child in children) SizedBox(width: half, child: child),
        ],
      );
    },
  );
}

/// 减号、数值、加号。
class _Stepper extends StatelessWidget {
  const _Stepper({required this.label, this.onLess, this.onMore});

  final String label;
  final VoidCallback? onLess;
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final style = IconButton.styleFrom(
      backgroundColor: PawColors.subtle,
      minimumSize: const Size(52, 52),
    );
    return Row(
      children: [
        IconButton(
          tooltip: l.stepperLess,
          onPressed: onLess,
          style: style,
          icon: const Icon(Icons.remove_rounded),
        ),
        Expanded(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        IconButton(
          tooltip: l.stepperMore,
          onPressed: onMore,
          style: style,
          icon: const Icon(Icons.add_rounded),
        ),
      ],
    );
  }
}
