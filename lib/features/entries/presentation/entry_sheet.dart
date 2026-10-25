import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/codes/coded_enum.dart';
import '../../../core/design/design.dart';
import '../../../core/format/date_display.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/units/units.dart';
import '../../settings/application/display_settings.dart';
import '../application/quick_log.dart';
import '../data/entries_repository.dart';
import '../domain/entry.dart';
import '../domain/entry_codes.dart';
import '../domain/entry_details.dart';

/// 打开补充面板。
///
/// 传 [entryId] 时是给已经记好的记录补充细节，关闭时保存；
/// 不传时是新建一条，点"保存"才写入，返回 [Logged]；新建遛狗时也可以
/// 现在出发，返回 [WalkStarted]。修改已有记录和直接关闭都返回 `null`。
Future<QuickLogResult?> showEntrySheet(
  BuildContext context, {
  required EntryDraft draft,
  String? entryId,
}) => showModalBottomSheet<QuickLogResult>(
  context: context,
  // 从最上层弹出，盖住悬浮底栏；否则底栏会挡住面板底部的按钮。
  useRootNavigator: true,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (context) => EntrySheet(draft: draft, entryId: entryId),
);

class EntrySheet extends ConsumerStatefulWidget {
  const EntrySheet({super.key, required this.draft, this.entryId});

  final EntryDraft draft;
  final String? entryId;

  @override
  ConsumerState<EntrySheet> createState() => _EntrySheetState();
}

class _EntrySheetState extends ConsumerState<EntrySheet> {
  late EntryDetails _details =
      widget.draft.details ??
      EntryDetails.fromJson(widget.draft.type, const {});
  late DateTime _occurredAt = widget.draft.occurredAt;
  late String _note = widget.draft.note;
  late bool _noteOpen = widget.draft.note.isNotEmpty;
  late double? _amount = widget.draft.amount;
  late PortionUnit? _unit = widget.draft.unit;
  late String _label = widget.draft.label ?? '';
  late final double _initialMinutes = _walkMinutes(widget.draft);
  late double? _minutes = _initialMinutes;
  var _saving = false;

  /// 遛狗时长：已有的按实际时长，新补记的默认半小时。
  static double _walkMinutes(EntryDraft draft) {
    final start = draft.startedAt;
    final end = draft.endedAt;
    if (start == null || end == null) return 30;
    return end.difference(start).inMinutes.clamp(1, 24 * 60).toDouble();
  }

  EntryType get _type => widget.draft.type;
  bool get _editing => widget.entryId != null;

  bool get _valid => switch (_type) {
    EntryType.weight => (_amount ?? 0) > 0,
    EntryType.custom => _label.trim().isNotEmpty,
    EntryType.walk => (_minutes ?? 0) > 0,
    _ => true,
  };

  /// 结束时间。开始时间和时长都没改时保留原来精确到秒的时长。
  DateTime get _walkEnd {
    final original = widget.draft.endedAt;
    if (original != null &&
        _occurredAt == widget.draft.occurredAt &&
        _minutes == _initialMinutes) {
      return original;
    }
    return _occurredAt.add(Duration(seconds: ((_minutes ?? 0) * 60).round()));
  }

  EntryDraft get _result {
    final portion = _type == EntryType.meal || _type == EntryType.medication;
    final walk = _type == EntryType.walk;
    final amount = _amount;
    return EntryDraft(
      petId: widget.draft.petId,
      type: _type,
      occurredAt: _occurredAt,
      planId: widget.draft.planId,
      // 份量和单位要么都有，要么都没有。
      amount: portion && _unit == null ? null : amount,
      unit: portion && amount != null ? _unit : null,
      details: _details,
      label: _label,
      note: _note,
      startedAt: walk ? _occurredAt : null,
      endedAt: walk ? _walkEnd : null,
      distanceM: walk ? widget.draft.distanceM : null,
    );
  }

  Future<void> _save() async {
    if (!_valid || _saving) return;
    setState(() => _saving = true);
    final entries = ref.read(entriesRepositoryProvider);
    try {
      final id = widget.entryId;
      if (id == null) {
        final entry = await entries.create(_result);
        if (mounted) Navigator.of(context).pop(Logged(entry));
      } else {
        await entries.update(id, _result);
        if (mounted) Navigator.of(context).pop();
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  /// 不补记，现在出发开始计时。
  Future<void> _startWalk() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final entry = await ref
          .read(entriesRepositoryProvider)
          .startWalk(widget.draft.petId);
      if (mounted) Navigator.of(context).pop(WalkStarted(entry));
    } on ActiveWalkExists {
      // 已经在遛了（比如在别处刚点了开始），不用再开始一次。
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _pickTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _occurredAt,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_occurredAt),
    );
    if (time == null) return;
    setState(
      () => _occurredAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      ),
    );
  }

  String _formatTime(BuildContext context) {
    final time = MaterialLocalizations.of(
      context,
    ).formatTimeOfDay(TimeOfDay.fromDateTime(_occurredAt));
    final today = DateUtils.dateOnly(DateTime.now());
    if (DateUtils.isSameDay(_occurredAt, today)) return time;
    final date = formatDisplayDate(
      _occurredAt,
      ref.read(displayDateFormatProvider),
      withYear: _occurredAt.year != today.year,
    );
    return '$date $time';
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final time = _formatTime(context);
    final tone = PawTones.forEntry(_type);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 0, 22, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                _TypeBadge(type: _type, tone: tone),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _editing ? l.sheetAddDetails : l.entryType(_type),
                        style: text.headlineSmall,
                      ),
                      if (_editing)
                        Text(l.sheetLoggedAt(time), style: text.bodySmall),
                    ],
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
            ..._fields(context),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: _FieldButton(
                    label: _type == EntryType.walk
                        ? l.sheetWalkStart
                        : l.sheetTime,
                    value: time,
                    onTap: _pickTime,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _noteOpen
                      ? const SizedBox.shrink()
                      : _FieldButton(
                          glyph: PawGlyph.plus,
                          value: l.sheetAddNote,
                          accent: true,
                          onTap: () => setState(() => _noteOpen = true),
                        ),
                ),
              ],
            ),
            if (_noteOpen) ...[
              const SizedBox(height: 14),
              TextFormField(
                initialValue: _note,
                autofocus: _note.isEmpty,
                minLines: 2,
                maxLines: 4,
                maxLength: 500,
                decoration: InputDecoration(
                  labelText: l.sheetNote,
                  counterText: '',
                ),
                onChanged: (value) => _note = value,
              ),
            ],
            const SizedBox(height: 22),
            FilledButton(
              onPressed: _valid && !_saving ? _save : null,
              style: FilledButton.styleFrom(minimumSize: const Size(0, 56)),
              child: Text(_editing ? l.sheetDone : l.sheetSave),
            ),
            if (_type == EntryType.walk && !_editing) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: _saving ? null : _startWalk,
                child: Text(l.walkStartNow),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _fields(BuildContext context) {
    final l = AppLocalizations.of(context);
    final units = ref.watch(displayUnitsProvider);
    Widget options<T extends CodedEnum>(
      String label,
      List<T> values,
      T? selected,
      ValueChanged<T> onSelect, {
      Set<T> attention = const {},
    }) => _OptionsField<T>(
      label: label,
      values: values,
      selected: selected,
      labelOf: l.option,
      onSelect: (value) => setState(() => onSelect(value)),
      attention: attention,
    );

    final details = _details;
    return switch (details) {
      MealDetails(:final appetite) => [
        _AmountField(
          label: l.onboardingMealAmount,
          amount: _amount,
          onChanged: (value) => setState(() {
            _amount = value;
            _unit ??= units.food;
          }),
          units: [
            for (final unit in PortionUnit.food) (unit, l.foodUnit(unit)),
          ],
          unit: _unit ?? units.food,
          onUnit: (unit) => setState(() => _unit = unit),
        ),
        const SizedBox(height: 18),
        options(
          l.fieldAppetite,
          Appetite.values,
          appetite,
          (v) => _details = MealDetails(appetite: v),
          attention: const {Appetite.barelyAte},
        ),
      ],
      WaterDetails(:final intake) => [
        _AmountField(
          label: l.sheetAmount,
          amount: _amount == null ? null : units.water.fromMl(_amount!),
          onChanged: (value) => setState(
            () => _amount = value == null ? null : units.water.toMl(value),
          ),
          suffix: l.volumeUnit(units.water),
        ),
        const SizedBox(height: 18),
        options(
          l.fieldIntake,
          WaterIntake.values,
          intake,
          (v) => _details = WaterDetails(intake: v),
        ),
      ],
      PottyDetails(:final kind, :final stool, :final urine) => [
        PillSegmented<PottyKind>(
          options: PottyKind.values,
          selected: kind ?? PottyKind.poop,
          labelOf: l.pottyKind,
          onChanged: (value) => setState(
            () => _details = PottyDetails(
              kind: value,
              stool: value == PottyKind.poop ? StoolStatus.normal : null,
              urine: value == PottyKind.pee ? UrineStatus.normal : null,
            ),
          ),
        ),
        const SizedBox(height: 18),
        if ((kind ?? PottyKind.poop) == PottyKind.poop)
          options(
            l.fieldLooks,
            StoolStatus.values,
            stool,
            (v) => _details = PottyDetails(kind: PottyKind.poop, stool: v),
            attention: const {StoolStatus.bloodOrMucus},
          )
        else
          options(
            l.fieldLooks,
            UrineStatus.values,
            urine,
            (v) => _details = PottyDetails(kind: PottyKind.pee, urine: v),
            attention: const {UrineStatus.unusualColor},
          ),
      ],
      BrushingDetails(:final coat) => [
        options(
          l.fieldCoat,
          CoatCondition.values,
          coat,
          (v) => _details = BrushingDetails(coat: v),
          attention: const {CoatCondition.skinIssue},
        ),
      ],
      BathDetails(:final where) => [
        options(
          l.fieldWhere,
          BathPlace.values,
          where,
          (v) => _details = BathDetails(where: v),
        ),
      ],
      GroomingDetails(:final where) => [
        options(
          l.fieldWhere,
          GroomingPlace.values,
          where,
          (v) => _details = GroomingDetails(where: v),
        ),
      ],
      EarCheckDetails(:final ears) => [
        options(
          l.fieldEars,
          EarCondition.values,
          ears,
          (v) => _details = EarCheckDetails(ears: v),
          attention: const {EarCondition.redOrSmelly},
        ),
      ],
      OtherCareDetails(:final kind) => [
        options(
          l.fieldWhat,
          OtherCareKind.values,
          kind,
          (v) => _details = OtherCareDetails(kind: v),
        ),
      ],
      SymptomDetails(:final kind, :final status) => [
        options(
          l.fieldNoticed,
          SymptomKind.values,
          kind,
          (v) => _details = SymptomDetails(kind: v, status: status),
        ),
        const SizedBox(height: 18),
        options(
          l.fieldTrend,
          SymptomStatus.values,
          status,
          (v) => _details = SymptomDetails(kind: kind, status: v),
          attention: const {SymptomStatus.worse},
        ),
      ],
      VetTestDetails(:final kind, :final result) => [
        options(
          l.fieldWhat,
          VetTestKind.values,
          kind,
          (v) => _details = VetTestDetails(kind: v, result: result),
        ),
        const SizedBox(height: 18),
        options(
          l.fieldResult,
          VetTestResult.values,
          result,
          (v) => _details = VetTestDetails(kind: kind, result: v),
        ),
      ],
      ParasitePreventionDetails(:final coverage) => [
        _MultiOptionsField<ParasiteCoverage>(
          label: l.fieldCovers,
          values: ParasiteCoverage.values,
          selected: coverage,
          labelOf: l.option,
          onToggle: (value) => setState(
            () => _details = ParasitePreventionDetails(
              coverage: coverage.contains(value)
                  ? ({...coverage}..remove(value))
                  : {...coverage, value},
            ),
          ),
        ),
        const SizedBox(height: 18),
        _TextField(
          label: l.sheetProduct,
          value: _label,
          onChanged: (value) => _label = value,
        ),
      ],
      NoDetails() => switch (_type) {
        EntryType.weight => [
          _AmountField(
            label: l.entryTypeWeight,
            amount: _amount == null ? null : units.weight.fromKg(_amount!),
            onChanged: (value) => setState(
              () => _amount = value == null ? null : units.weight.toKg(value),
            ),
            suffix: l.weightUnit(units.weight),
            autofocus: true,
          ),
        ],
        EntryType.medication => [
          _TextField(
            label: l.sheetName,
            value: _label,
            onChanged: (value) => _label = value,
          ),
          const SizedBox(height: 18),
          _AmountField(
            label: l.sheetAmount,
            amount: _amount,
            onChanged: (value) => setState(() {
              _amount = value;
              _unit ??= PortionUnit.tablet;
            }),
            units: [
              for (final unit in PortionUnit.medication) (unit, unit.code),
            ],
            unit: _unit ?? PortionUnit.tablet,
            onUnit: (unit) => setState(() => _unit = unit),
          ),
        ],
        EntryType.walk => [
          _AmountField(
            label: l.fieldWalkDuration,
            amount: _minutes,
            onChanged: (value) => setState(() => _minutes = value),
            suffix: l.unitMinutes,
          ),
        ],
        EntryType.vaccine || EntryType.custom => [
          _TextField(
            label: l.sheetName,
            value: _label,
            autofocus: true,
            onChanged: (value) => setState(() => _label = value),
          ),
        ],
        _ => const [],
      },
    };
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type, required this.tone});

  final EntryType type;
  final PawTone tone;

  @override
  Widget build(BuildContext context) {
    if (type == EntryType.potty) {
      return const Sticker(StickerArt.potty, size: 56, turns: -0.017);
    }
    return Container(
      width: 52,
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: tone.fill, shape: BoxShape.circle),
      child: PawIcon(PawGlyph.forEntry(type), size: 28, color: tone.onFill),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

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

/// 两列等大的选项格子；单数时最后一个占满一行。
class _OptionsField<T extends CodedEnum> extends StatelessWidget {
  const _OptionsField({
    required this.label,
    required this.values,
    required this.selected,
    required this.labelOf,
    required this.onSelect,
    this.attention = const {},
  });

  final String label;
  final List<T> values;
  final T? selected;
  final String Function(T value) labelOf;
  final ValueChanged<T> onSelect;
  final Set<T> attention;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _SectionLabel(label),
      _TwoColumns(
        children: [
          for (final value in values)
            OptionTile(
              label: labelOf(value),
              selected: value == selected,
              attention: attention.contains(value),
              onTap: () => onSelect(value),
            ),
        ],
      ),
    ],
  );
}

class _MultiOptionsField<T extends CodedEnum> extends StatelessWidget {
  const _MultiOptionsField({
    required this.label,
    required this.values,
    required this.selected,
    required this.labelOf,
    required this.onToggle,
  });

  final String label;
  final List<T> values;
  final Set<T> selected;
  final String Function(T value) labelOf;
  final ValueChanged<T> onToggle;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _SectionLabel(label),
      for (final value in values) ...[
        OptionTile(
          label: labelOf(value),
          selected: selected.contains(value),
          onTap: () => onToggle(value),
        ),
        const SizedBox(height: 10),
      ],
    ],
  );
}

class _TwoColumns extends StatelessWidget {
  const _TwoColumns({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      const gap = 10.0;
      final half = (constraints.maxWidth - gap) / 2;
      return Wrap(
        spacing: gap,
        runSpacing: gap,
        children: [
          for (var i = 0; i < children.length; i++)
            SizedBox(
              width: i == children.length - 1 && children.length.isOdd
                  ? constraints.maxWidth
                  : half,
              child: children[i],
            ),
        ],
      );
    },
  );
}

class _FieldButton extends StatelessWidget {
  const _FieldButton({
    required this.value,
    required this.onTap,
    this.label,
    this.glyph,
    this.accent = false,
  });

  final String? label;
  final String value;
  final PawGlyph? glyph;
  final bool accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final label = this.label;
    final glyph = this.glyph;
    return Material(
      color: PawColors.ground,
      borderRadius: BorderRadius.circular(PawRadii.tile),
      child: InkWell(
        borderRadius: BorderRadius.circular(PawRadii.tile),
        onTap: onTap,
        child: SizedBox(
          height: 58,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                if (glyph != null) ...[
                  PawIcon(
                    glyph,
                    size: 18,
                    color: PawColors.coralText,
                    strokeWidth: 3,
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (label != null)
                        Text(
                          label,
                          style: text.bodySmall?.copyWith(fontSize: 12),
                        ),
                      Text(
                        value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.titleSmall?.copyWith(
                          color: accent ? PawColors.coralText : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.autofocus = false,
  });

  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final bool autofocus;

  @override
  Widget build(BuildContext context) => TextFormField(
    initialValue: value,
    autofocus: autofocus,
    maxLength: 60,
    decoration: InputDecoration(labelText: label, counterText: ''),
    onChanged: onChanged,
  );
}

/// 数量输入：可以带单位选择，也可以只显示一个固定单位。
class _AmountField<U> extends StatelessWidget {
  const _AmountField({
    required this.label,
    required this.amount,
    required this.onChanged,
    this.units = const [],
    this.unit,
    this.onUnit,
    this.suffix,
    this.autofocus = false,
  });

  final String label;
  final double? amount;
  final ValueChanged<double?> onChanged;
  final List<(U, String)> units;
  final U? unit;
  final ValueChanged<U>? onUnit;
  final String? suffix;
  final bool autofocus;

  static String _format(double? value) {
    if (value == null) return '';
    final rounded = double.parse(value.toStringAsFixed(2));
    return rounded == rounded.roundToDouble()
        ? rounded.toInt().toString()
        : rounded.toString();
  }

  @override
  Widget build(BuildContext context) {
    final suffix = this.suffix;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel(label),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 160,
            child: TextFormField(
              initialValue: _format(amount),
              autofocus: autofocus,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
              ],
              decoration: InputDecoration(
                suffixIcon: suffix == null
                    ? null
                    : Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Text(
                          suffix,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: PawColors.inkMuted),
                        ),
                      ),
                suffixIconConstraints: const BoxConstraints(),
              ),
              onChanged: (raw) {
                final value = double.tryParse(raw.trim().replaceAll(',', '.'));
                onChanged(
                  value == null || value <= 0 || !value.isFinite ? null : value,
                );
              },
            ),
          ),
        ),
        if (units.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final (value, name) in units)
                PawChoiceChip(
                  label: name,
                  selected: value == unit,
                  background: PawColors.subtle,
                  onTap: () => onUnit?.call(value),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
