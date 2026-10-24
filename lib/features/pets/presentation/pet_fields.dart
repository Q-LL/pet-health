import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/design/design.dart';
import '../../../core/format/date_display.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/l10n/labels.dart';
import '../../settings/application/display_settings.dart';
import '../domain/breed_catalog.dart';
import '../domain/pet_codes.dart';

/// 表单里一组内容的小标题。
class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(text, style: Theme.of(context).textTheme.titleSmall),
  );
}

/// 选品种：搜索预设犬种，或选"列表里没有 / 混种"后手填名字并选分组。
class BreedSelector extends StatefulWidget {
  const BreedSelector({
    super.key,
    required this.breedCode,
    required this.breedName,
    required this.breedGroup,
    required this.onBreed,
    required this.onOther,
    required this.onName,
    required this.onGroup,
  });

  final String? breedCode;
  final String? breedName;
  final BreedGroup? breedGroup;
  final ValueChanged<String> onBreed;
  final VoidCallback onOther;
  final ValueChanged<String> onName;
  final ValueChanged<BreedGroup> onGroup;

  @override
  State<BreedSelector> createState() => _BreedSelectorState();
}

class _BreedSelectorState extends State<BreedSelector> {
  var _query = '';
  late var _other = widget.breedCode == null && widget.breedGroup != null;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final query = _query.trim().toLowerCase();
    final breeds = [
      for (final code in breedCatalog.keys)
        if (query.isEmpty || l.breed(code)!.toLowerCase().contains(query)) code,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: l.onboardingBreedSearch,
            prefixIcon: const Icon(Icons.search_rounded),
          ),
          onChanged: (value) => setState(() => _query = value),
        ),
        const SizedBox(height: PawSpace.md),
        for (final code in breeds) ...[
          OptionTile(
            label: l.breed(code)!,
            selected: !_other && widget.breedCode == code,
            onTap: () {
              setState(() => _other = false);
              widget.onBreed(code);
            },
          ),
          const SizedBox(height: PawSpace.sm),
        ],
        OptionTile(
          label: l.onboardingBreedOther,
          selected: _other,
          onTap: () {
            setState(() => _other = true);
            widget.onOther();
          },
        ),
        if (_other) ...[
          const SizedBox(height: PawSpace.lg),
          FieldLabel(l.onboardingBreedOtherName),
          TextFormField(
            initialValue: widget.breedName,
            maxLength: 40,
            decoration: const InputDecoration(counterText: ''),
            onChanged: widget.onName,
          ),
          const SizedBox(height: PawSpace.lg),
          FieldLabel(l.onboardingBreedGroupLabel),
          Text(l.onboardingBreedGroupHint, style: text.bodySmall),
          const SizedBox(height: 10),
          for (final group in BreedGroup.values) ...[
            OptionTile(
              label: l.breedGroup(group),
              selected: widget.breedGroup == group,
              onTap: () => widget.onGroup(group),
            ),
            const SizedBox(height: PawSpace.sm),
          ],
        ] else if (widget.breedCode case final code?) ...[
          const SizedBox(height: PawSpace.md),
          Text(
            '${l.breedGroup(breedGroupFor(code))} · ${l.onboardingBreedGroupHint}',
            style: text.bodySmall,
          ),
        ],
      ],
    );
  }
}

/// 生日（可以只填年月）和到家日期。
class PetDateFields extends ConsumerWidget {
  const PetDateFields({
    super.key,
    required this.birthDate,
    required this.birthPrecision,
    required this.homeDate,
    required this.onBirthDate,
    required this.onBirthPrecision,
    required this.onHomeDate,
  });

  final DateTime? birthDate;
  final BirthPrecision birthPrecision;
  final DateTime? homeDate;
  final ValueChanged<DateTime?> onBirthDate;
  final ValueChanged<BirthPrecision> onBirthPrecision;
  final ValueChanged<DateTime?> onHomeDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final dateFormat = ref.watch(displayDateFormatProvider);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final monthOnly = birthPrecision == BirthPrecision.month;

    String? show(DateTime? date, {bool month = false}) => date == null
        ? null
        : month
        ? DateFormat.yMMM(locale).format(date)
        : formatDisplayDate(date, dateFormat);

    Future<DateTime?> pick(DateTime? initial) {
      final today = DateUtils.dateOnly(DateTime.now());
      return showDatePicker(
        context: context,
        initialDate: initial ?? today,
        firstDate: DateTime(1990),
        lastDate: today,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DateFieldTile(
          label: l.onboardingBirthday,
          value: show(birthDate, month: monthOnly),
          onPick: () async {
            final date = await pick(birthDate);
            if (date != null) onBirthDate(date);
          },
          onClear: () => onBirthDate(null),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l.onboardingBirthdayMonthOnly),
          value: monthOnly,
          onChanged: (value) => onBirthPrecision(
            value ? BirthPrecision.month : BirthPrecision.day,
          ),
        ),
        const SizedBox(height: PawSpace.lg),
        DateFieldTile(
          label: l.onboardingHomeDate,
          hint: l.onboardingHomeDateHint,
          value: show(homeDate),
          onPick: () async {
            final date = await pick(homeDate);
            if (date != null) onHomeDate(date);
          },
          onClear: () => onHomeDate(null),
        ),
      ],
    );
  }
}

/// 一个日期：点一下选择，填了以后可以清除。
class DateFieldTile extends StatelessWidget {
  const DateFieldTile({
    super.key,
    required this.label,
    required this.value,
    required this.onPick,
    required this.onClear,
    this.hint,
  });

  final String label;
  final String? hint;
  final String? value;
  final VoidCallback onPick;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final value = this.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label),
        if (hint case final hint?) ...[
          Text(hint, style: text.bodySmall),
          const SizedBox(height: 10),
        ],
        Material(
          color: PawColors.surface,
          borderRadius: BorderRadius.circular(PawRadii.tile),
          child: InkWell(
            borderRadius: BorderRadius.circular(PawRadii.tile),
            onTap: onPick,
            child: SizedBox(
              height: 58,
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      value ?? l.onboardingNotSet,
                      style: text.bodyLarge?.copyWith(
                        color: value == null ? PawColors.inkMuted : null,
                        fontWeight: value == null ? null : FontWeight.w600,
                      ),
                    ),
                  ),
                  if (value != null)
                    TextButton(
                      onPressed: onClear,
                      child: Text(l.onboardingClear),
                    ),
                  const SizedBox(width: 6),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
