import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design/design.dart';
import '../../../core/format/date_display.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/units/unit_preferences.dart';
import '../../../core/units/units.dart';
import '../data/preferences_repository.dart';
import '../domain/app_preferences.dart';

/// 设置：语言、单位、日期格式。改动立即保存。
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final prefs =
        ref.watch(appPreferencesProvider).value ?? const AppPreferences();
    final repo = ref.read(preferencesRepositoryProvider);
    final units = prefs.units;

    Future<void> setUnits(UnitPreferences value) => repo.setUnits(value);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.settingsTitle, style: text.titleLarge),
        backgroundColor: PawColors.ground,
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(PawSpace.page, 8, PawSpace.page, 40),
        children: [
          _Section(
            title: l.settingsLanguage,
            child: _Choices<AppLanguage>(
              values: AppLanguage.values,
              selected: prefs.language,
              labelOf: l.language,
              onSelect: repo.setLanguage,
            ),
          ),
          _Section(
            title: l.settingsUnits,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Row(
                  label: l.settingsUnitSystem,
                  child: _Choices<UnitSystem>(
                    values: UnitSystem.values,
                    selected: units.system,
                    labelOf: l.unitSystem,
                    onSelect: (system) => setUnits(_withSystem(units, system)),
                  ),
                ),
                _Row(
                  label: l.settingsWeightUnit,
                  child: _Choices<WeightUnit?>(
                    values: const [null, ...WeightUnit.values],
                    selected: units.weight,
                    labelOf: (unit) => unit == null
                        ? l.settingsFollowUnitSystem
                        : l.weightUnit(unit),
                    onSelect: (unit) =>
                        setUnits(_with(units, weight: () => unit)),
                  ),
                ),
                _Row(
                  label: l.settingsWaterUnit,
                  child: _Choices<VolumeUnit?>(
                    values: const [null, ...VolumeUnit.values],
                    selected: units.water,
                    labelOf: (unit) => unit == null
                        ? l.settingsFollowUnitSystem
                        : l.volumeUnit(unit),
                    onSelect: (unit) =>
                        setUnits(_with(units, water: () => unit)),
                  ),
                ),
                _Row(
                  label: l.settingsFoodUnit,
                  child: _Choices<PortionUnit?>(
                    values: const [null, ...PortionUnit.food],
                    selected: units.food,
                    labelOf: (unit) => unit == null
                        ? l.settingsFollowUnitSystem
                        : l.foodUnit(unit),
                    onSelect: (unit) =>
                        setUnits(_with(units, food: () => unit)),
                  ),
                ),
              ],
            ),
          ),
          _Section(
            title: l.settingsDateFormat,
            child: _Choices<DateDisplayFormat>(
              values: DateDisplayFormat.values,
              selected: prefs.dateFormat,
              labelOf: l.dateFormat,
              onSelect: repo.setDateFormat,
            ),
          ),
        ],
      ),
    );
  }

  static UnitPreferences _withSystem(UnitPreferences u, UnitSystem system) =>
      UnitPreferences(
        system: system,
        weight: u.weight,
        water: u.water,
        distance: u.distance,
        temperature: u.temperature,
        food: u.food,
      );

  static UnitPreferences _with(
    UnitPreferences u, {
    WeightUnit? Function()? weight,
    VolumeUnit? Function()? water,
    PortionUnit? Function()? food,
  }) => UnitPreferences(
    system: u.system,
    weight: weight == null ? u.weight : weight(),
    water: water == null ? u.water : water(),
    distance: u.distance,
    temperature: u.temperature,
    food: food == null ? u.food : food(),
  );
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: PawColors.surface,
        borderRadius: BorderRadius.circular(PawRadii.row),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          child,
        ],
      ),
    ),
  );
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: PawColors.inkMuted),
        ),
        const SizedBox(height: 8),
        child,
      ],
    ),
  );
}

class _Choices<T> extends StatelessWidget {
  const _Choices({
    required this.values,
    required this.selected,
    required this.labelOf,
    required this.onSelect,
  });

  final List<T> values;
  final T selected;
  final String Function(T value) labelOf;
  final ValueChanged<T> onSelect;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      for (final value in values)
        PawChoiceChip(
          label: labelOf(value),
          selected: value == selected,
          background: PawColors.subtle,
          onTap: () => onSelect(value),
        ),
    ],
  );
}
