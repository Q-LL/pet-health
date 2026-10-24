import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design/design.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/units/units.dart';
import '../../entries/domain/entry_codes.dart';
import '../../plans/application/parasite_settings.dart';
import '../../plans/domain/parasite_choice.dart';
import '../../plans/presentation/parasite_choice_card.dart';
import '../../settings/application/display_settings.dart';
import '../data/pets_repository.dart';
import '../domain/pet.dart';
import 'pet_fields.dart';

Future<void> _showSheet(BuildContext context, Widget child) =>
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: child,
      ),
    );

/// 面板顶部：标题和关闭按钮。
class _SheetHeader extends StatelessWidget {
  const _SheetHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.headlineSmall),
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
    );
  }
}

Future<void> showPresetsSheet(
  BuildContext context, {
  required String petId,
  PetPresets? presets,
}) => _showSheet(context, _PresetsSheet(petId: petId, presets: presets));

/// 修改习惯预设。
class _PresetsSheet extends ConsumerStatefulWidget {
  const _PresetsSheet({required this.petId, this.presets});

  final String petId;
  final PetPresets? presets;

  @override
  ConsumerState<_PresetsSheet> createState() => _PresetsSheetState();
}

class _PresetsSheetState extends ConsumerState<_PresetsSheet> {
  static const _maxQuick = 8;

  /// 可以放到今天页的一键记录。
  static const _quickChoices = [
    EntryType.meal,
    EntryType.water,
    EntryType.potty,
    EntryType.brushing,
    EntryType.walk,
    EntryType.weight,
    EntryType.bath,
    EntryType.earCheck,
    EntryType.symptom,
    EntryType.medication,
  ];

  late double? _mealAmount = widget.presets?.mealAmount;
  late PortionUnit? _mealUnit = widget.presets?.mealUnit;
  late int? _mealsPerDay = widget.presets?.mealsPerDay;
  late double? _bowlMl = widget.presets?.bowlMl;
  late List<EntryType> _quick = [
    ...(widget.presets?.quickTypes ?? PetsRepository.defaultQuickTypes),
  ];
  var _saving = false;

  static double? _parse(String raw) {
    final value = double.tryParse(raw.trim().replaceAll(',', '.'));
    return value == null || value <= 0 || !value.isFinite ? null : value;
  }

  static String _format(double? value) {
    if (value == null) return '';
    final rounded = double.parse(value.toStringAsFixed(1));
    return rounded == rounded.roundToDouble()
        ? rounded.toInt().toString()
        : rounded.toString();
  }

  Future<void> _save(PortionUnit unit) async {
    setState(() => _saving = true);
    try {
      await ref
          .read(petsRepositoryProvider)
          .savePresets(
            widget.petId,
            PetPresetsDraft(
              mealAmount: _mealAmount,
              mealUnit: _mealAmount == null ? null : unit,
              mealsPerDay: _mealsPerDay,
              bowlMl: _bowlMl,
              quickTypes: _quick,
            ),
          );
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final units = ref.watch(displayUnitsProvider);
    final mealUnit = _mealUnit ?? units.food;
    final input = [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(22, 0, 22, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SheetHeader(l.presetsTitle),
          const SizedBox(height: 20),
          FieldLabel(l.presetMeal),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100,
                child: TextFormField(
                  initialValue: _format(_mealAmount),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: input,
                  onChanged: (value) =>
                      setState(() => _mealAmount = _parse(value)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final unit in PortionUnit.food)
                      PawChoiceChip(
                        label: l.foodUnit(unit),
                        selected: unit == mealUnit,
                        background: PawColors.subtle,
                        onTap: () => setState(() => _mealUnit = unit),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          FieldLabel(l.presetMealsPerDay),
          Wrap(
            spacing: 8,
            children: [
              for (final count in const [1, 2, 3, 4])
                PawChoiceChip(
                  label: '$count',
                  selected: _mealsPerDay == count,
                  background: PawColors.subtle,
                  onTap: () => setState(
                    () => _mealsPerDay = _mealsPerDay == count ? null : count,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          FieldLabel(l.presetBowl),
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 180,
              child: TextFormField(
                initialValue: _bowlMl == null
                    ? ''
                    : _format(units.water.fromMl(_bowlMl!)),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: input,
                decoration: InputDecoration(
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Text(
                      l.volumeUnit(units.water),
                      style: text.bodyLarge?.copyWith(
                        color: PawColors.inkMuted,
                      ),
                    ),
                  ),
                  suffixIconConstraints: const BoxConstraints(),
                ),
                onChanged: (value) {
                  final amount = _parse(value);
                  setState(
                    () => _bowlMl = amount == null
                        ? null
                        : units.water.toMl(amount),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          FieldLabel(l.presetQuick),
          Text(l.presetQuickHint, style: text.bodySmall),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final type in _quickChoices)
                PawChoiceChip(
                  label: _quick.contains(type)
                      ? '${_quick.indexOf(type) + 1}  ${l.entryType(type)}'
                      : l.entryType(type),
                  selected: _quick.contains(type),
                  background: PawColors.subtle,
                  onTap: () => setState(() {
                    if (_quick.contains(type)) {
                      _quick = [..._quick]..remove(type);
                    } else if (_quick.length < _maxQuick) {
                      _quick = [..._quick, type];
                    }
                  }),
                ),
            ],
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _saving ? null : () => _save(mealUnit),
            style: FilledButton.styleFrom(minimumSize: const Size(0, 56)),
            child: Text(l.sheetSave),
          ),
        ],
      ),
    );
  }
}

Future<void> showParasiteSheet(
  BuildContext context, {
  required String petId,
  required Map<ParasiteCoverage, ParasiteChoice> current,
}) => _showSheet(context, _ParasiteSheet(petId: petId, current: current));

/// 修改驱虫方式。
class _ParasiteSheet extends ConsumerStatefulWidget {
  const _ParasiteSheet({required this.petId, required this.current});

  final String petId;
  final Map<ParasiteCoverage, ParasiteChoice> current;

  @override
  ConsumerState<_ParasiteSheet> createState() => _ParasiteSheetState();
}

class _ParasiteSheetState extends ConsumerState<_ParasiteSheet> {
  static const _order = [
    ParasiteCoverage.heartworm,
    ParasiteCoverage.intestinal,
    ParasiteCoverage.fleasTicks,
  ];

  late final _choices = {...widget.current};
  var _saving = false;

  Future<void> _save() async {
    setState(() => _saving = true);
    final settings = ref.read(parasiteSettingsProvider);
    try {
      for (final coverage in _order) {
        final choice = _choices[coverage] ?? const ParasiteChoice.none();
        // 没改的不动，免得重建计划丢掉"稍后提醒"之类的状态。
        if (choice == widget.current[coverage]) continue;
        await settings.apply(widget.petId, coverage, choice);
      }
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(22, 0, 22, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SheetHeader(l.parasiteCardTitle),
          const SizedBox(height: 6),
          Text(
            l.onboardingParasiteBody,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          for (final coverage in _order) ...[
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: PawColors.hairline, width: 2),
                borderRadius: BorderRadius.circular(PawRadii.row),
              ),
              child: ParasiteChoiceCard(
                coverage: coverage,
                choice: _choices[coverage] ?? const ParasiteChoice.none(),
                onChanged: (choice) =>
                    setState(() => _choices[coverage] = choice),
              ),
            ),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _saving ? null : _save,
            style: FilledButton.styleFrom(minimumSize: const Size(0, 56)),
            child: Text(l.sheetSave),
          ),
        ],
      ),
    );
  }
}
