import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/design/design.dart';
import '../../../core/format/date_display.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/l10n/unit_format.dart';
import '../../../core/units/units.dart';
import '../../entries/domain/entry_codes.dart';
import '../../pets/domain/breed_catalog.dart';
import '../../pets/domain/pet_codes.dart';
import '../../settings/application/display_settings.dart';
import '../application/onboarding_service.dart';
import '../domain/onboarding_draft.dart';

/// 修改表单：传入的函数作用在最新的表单上，连续快速操作也不会互相覆盖。
typedef DraftUpdate =
    void Function(OnboardingDraft Function(OnboardingDraft) change);

/// 新建狗狗的引导：名字 → 品种 → 日子 → 日常习惯 → 驱虫。只有名字必填。
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  static const _steps = 5;

  var _step = 0;
  var _draft = const OnboardingDraft();
  var _saving = false;
  var _showNameError = false;

  void _update(OnboardingDraft Function(OnboardingDraft) change) {
    setState(() => _draft = change(_draft));
    if (_showNameError && _draft.name.trim().isNotEmpty) {
      setState(() => _showNameError = false);
    }
  }

  Future<void> _next() async {
    if (_step == 0 && _draft.name.trim().isEmpty) {
      setState(() => _showNameError = true);
      return;
    }
    if (_step < _steps - 1) {
      setState(() => _step++);
      return;
    }
    setState(() => _saving = true);
    try {
      // 建好后路由会自动从引导页转到今天页。
      await ref.read(onboardingServiceProvider).finish(_draft);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final body = switch (_step) {
      0 => _NameStep(
        draft: _draft,
        onChanged: _update,
        showError: _showNameError,
      ),
      1 => _BreedStep(draft: _draft, onChanged: _update),
      2 => _DatesStep(draft: _draft, onChanged: _update),
      3 => _HabitsStep(draft: _draft, onChanged: _update),
      _ => _ParasiteStep(draft: _draft, onChanged: _update),
    };
    final last = _step == _steps - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                PawSpace.page,
                12,
                PawSpace.page,
                0,
              ),
              child: Row(
                children: [
                  for (var i = 0; i < _steps; i++)
                    Expanded(
                      child: Container(
                        height: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: i <= _step ? PawColors.coral : PawColors.peach,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                PawSpace.page,
                8,
                PawSpace.page,
                0,
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  l.onboardingStep(_step + 1, _steps),
                  style: text.bodySmall,
                ),
              ),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: KeyedSubtree(key: ValueKey(_step), child: body),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                PawSpace.page,
                8,
                PawSpace.page,
                16,
              ),
              child: Row(
                children: [
                  if (_step > 0)
                    TextButton(
                      onPressed: _saving ? null : () => setState(() => _step--),
                      style: TextButton.styleFrom(
                        foregroundColor: PawColors.inkMuted,
                      ),
                      child: Text(l.onboardingBack),
                    ),
                  const Spacer(),
                  if (_step > 0 && !last)
                    TextButton(
                      onPressed: () => setState(() => _step++),
                      style: TextButton.styleFrom(
                        foregroundColor: PawColors.inkMuted,
                      ),
                      child: Text(l.onboardingSkip),
                    ),
                  const SizedBox(width: PawSpace.sm),
                  FilledButton(
                    onPressed: _saving ? null : _next,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(132, 54),
                    ),
                    child: Text(last ? l.onboardingDone : l.onboardingNext),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 每一步共用的外框：标题、可选的说明、可滚动的内容。
class _StepScaffold extends StatelessWidget {
  const _StepScaffold({
    required this.title,
    required this.children,
    this.body,
    this.sticker,
  });

  final String title;
  final String? body;
  final StickerArt? sticker;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(PawSpace.page, 12, PawSpace.page, 24),
      children: [
        if (sticker case final sticker?) ...[
          Center(child: Sticker(sticker, size: 120, turns: -0.017)),
          const SizedBox(height: PawSpace.lg),
        ],
        Text(title, style: text.headlineMedium),
        if (body case final body?) ...[
          const SizedBox(height: PawSpace.sm),
          Text(
            body,
            style: text.bodyMedium?.copyWith(color: PawColors.inkMuted),
          ),
        ],
        const SizedBox(height: PawSpace.xl),
        ...children,
      ],
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(text, style: Theme.of(context).textTheme.titleSmall),
  );
}

class _NameStep extends StatelessWidget {
  const _NameStep({
    required this.draft,
    required this.onChanged,
    required this.showError,
  });

  final OnboardingDraft draft;
  final DraftUpdate onChanged;
  final bool showError;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return _StepScaffold(
      sticker: StickerArt.golden,
      title: l.onboardingWelcomeTitle,
      body: l.onboardingWelcomeBody,
      children: [
        _Label(l.onboardingNameLabel),
        TextFormField(
          initialValue: draft.name,
          textInputAction: TextInputAction.done,
          maxLength: 30,
          decoration: InputDecoration(
            hintText: l.onboardingNameHint,
            counterText: '',
            errorText: showError ? l.onboardingNameRequired : null,
          ),
          onChanged: (value) => onChanged((d) => d.copyWith(name: value)),
        ),
        const SizedBox(height: PawSpace.lg),
        _Label(l.onboardingSexLabel),
        Wrap(
          spacing: PawSpace.sm,
          children: [
            for (final sex in PetSex.values)
              PawChoiceChip(
                label: l.sex(sex),
                selected: draft.sex == sex,
                // 再点一次取消选择。
                onTap: () => onChanged(
                  (d) => d.copyWith(sex: () => d.sex == sex ? null : sex),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _BreedStep extends StatefulWidget {
  const _BreedStep({required this.draft, required this.onChanged});

  final OnboardingDraft draft;
  final DraftUpdate onChanged;

  @override
  State<_BreedStep> createState() => _BreedStepState();
}

class _BreedStepState extends State<_BreedStep> {
  var _query = '';
  late var _other =
      widget.draft.breedCode == null && widget.draft.breedGroup != null;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final draft = widget.draft;
    final query = _query.trim().toLowerCase();
    final breeds = [
      for (final code in breedCatalog.keys)
        if (query.isEmpty || l.breed(code)!.toLowerCase().contains(query)) code,
    ];

    return _StepScaffold(
      title: l.onboardingBreedTitle(draft.name.trim()),
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
            selected: !_other && draft.breedCode == code,
            onTap: () {
              setState(() => _other = false);
              widget.onChanged(
                (d) => d.copyWith(
                  breedCode: () => code,
                  breedName: () => null,
                  breedGroup: () => null,
                ),
              );
            },
          ),
          const SizedBox(height: PawSpace.sm),
        ],
        OptionTile(
          label: l.onboardingBreedOther,
          selected: _other,
          onTap: () {
            setState(() => _other = true);
            widget.onChanged(
              (d) => d.copyWith(
                breedCode: () => null,
                breedGroup: () => d.breedGroup ?? BreedGroup.mixed,
              ),
            );
          },
        ),
        if (_other) ...[
          const SizedBox(height: PawSpace.lg),
          _Label(l.onboardingBreedOtherName),
          TextFormField(
            initialValue: draft.breedName,
            maxLength: 40,
            decoration: const InputDecoration(counterText: ''),
            onChanged: (value) =>
                widget.onChanged((d) => d.copyWith(breedName: () => value)),
          ),
          const SizedBox(height: PawSpace.lg),
          _Label(l.onboardingBreedGroupLabel),
          Text(l.onboardingBreedGroupHint, style: text.bodySmall),
          const SizedBox(height: 10),
          for (final group in BreedGroup.values) ...[
            OptionTile(
              label: l.breedGroup(group),
              selected: draft.breedGroup == group,
              onTap: () =>
                  widget.onChanged((d) => d.copyWith(breedGroup: () => group)),
            ),
            const SizedBox(height: PawSpace.sm),
          ],
        ] else if (draft.breedCode case final code?) ...[
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

class _DatesStep extends ConsumerWidget {
  const _DatesStep({required this.draft, required this.onChanged});

  final OnboardingDraft draft;
  final DraftUpdate onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final dateFormat = ref.watch(displayDateFormatProvider);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final monthOnly = draft.birthPrecision == BirthPrecision.month;

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

    return _StepScaffold(
      title: l.onboardingDatesTitle,
      children: [
        _DateField(
          label: l.onboardingBirthday,
          value: show(draft.birthDate, month: monthOnly),
          onPick: () async {
            final date = await pick(draft.birthDate);
            if (date != null) {
              onChanged((d) => d.copyWith(birthDate: () => date));
            }
          },
          onClear: () => onChanged((d) => d.copyWith(birthDate: () => null)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l.onboardingBirthdayMonthOnly),
          value: monthOnly,
          onChanged: (value) => onChanged(
            (d) => d.copyWith(
              birthPrecision: value ? BirthPrecision.month : BirthPrecision.day,
            ),
          ),
        ),
        const SizedBox(height: PawSpace.lg),
        _DateField(
          label: l.onboardingHomeDate,
          hint: l.onboardingHomeDateHint,
          value: show(draft.homeDate),
          onPick: () async {
            final date = await pick(draft.homeDate);
            if (date != null) {
              onChanged((d) => d.copyWith(homeDate: () => date));
            }
          },
          onClear: () => onChanged((d) => d.copyWith(homeDate: () => null)),
        ),
      ],
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
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
        _Label(label),
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

class _HabitsStep extends ConsumerWidget {
  const _HabitsStep({required this.draft, required this.onChanged});

  final OnboardingDraft draft;
  final DraftUpdate onChanged;

  static double? _parse(String raw) {
    final value = double.tryParse(raw.trim().replaceAll(',', '.'));
    return value == null || value <= 0 || !value.isFinite ? null : value;
  }

  static String _format(double? value) => value == null
      ? ''
      : value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toString();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final units = ref.watch(displayUnitsProvider);
    final mealUnit = draft.mealUnit ?? units.food;
    final waterUnit = units.water;
    final bowl = draft.bowlMl;
    final numberInput = [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))];

    return _StepScaffold(
      title: l.onboardingHabitsTitle,
      body: l.onboardingHabitsBody,
      children: [
        _Label(l.onboardingMealAmount),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 110,
              child: TextFormField(
                initialValue: _format(draft.mealAmount),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: numberInput,
                onChanged: (value) => onChanged(
                  (d) => d.copyWith(
                    mealAmount: () => _parse(value),
                    mealUnit: () => mealUnit,
                  ),
                ),
              ),
            ),
            const SizedBox(width: PawSpace.md),
            Expanded(
              child: Wrap(
                spacing: PawSpace.sm,
                runSpacing: PawSpace.sm,
                children: [
                  for (final unit in PortionUnit.food)
                    PawChoiceChip(
                      label: l.foodUnit(unit),
                      selected: unit == mealUnit,
                      onTap: () =>
                          onChanged((d) => d.copyWith(mealUnit: () => unit)),
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: PawSpace.xl),
        _Label(l.onboardingMealsPerDay),
        Wrap(
          spacing: PawSpace.sm,
          children: [
            for (final count in const [1, 2, 3, 4])
              PawChoiceChip(
                label: '$count',
                selected: draft.mealsPerDay == count,
                onTap: () => onChanged(
                  (d) => d.copyWith(
                    mealsPerDay: () =>
                        draft.mealsPerDay == count ? null : count,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: PawSpace.xl),
        _Label(l.onboardingBowl),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 180,
            child: TextFormField(
              initialValue: bowl == null
                  ? ''
                  : _format(
                      double.parse(waterUnit.fromMl(bowl).toStringAsFixed(1)),
                    ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: numberInput,
              decoration: InputDecoration(
                // suffixText 只在输入时出现；单位要一直看得到。
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(
                    l.volumeUnit(waterUnit),
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: PawColors.inkMuted),
                  ),
                ),
                suffixIconConstraints: const BoxConstraints(
                  minWidth: 0,
                  minHeight: 0,
                ),
              ),
              onChanged: (value) {
                final amount = _parse(value);
                onChanged(
                  (d) => d.copyWith(
                    bowlMl: () =>
                        amount == null ? null : waterUnit.toMl(amount),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _ParasiteStep extends StatelessWidget {
  const _ParasiteStep({required this.draft, required this.onChanged});

  final OnboardingDraft draft;
  final DraftUpdate onChanged;

  // 心丝虫放最前：按时最重要，也最容易被忽略。
  static const _order = [
    ParasiteCoverage.heartworm,
    ParasiteCoverage.intestinal,
    ParasiteCoverage.fleasTicks,
  ];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return _StepScaffold(
      title: l.onboardingParasiteTitle,
      body: l.onboardingParasiteBody,
      children: [
        for (final coverage in _order) ...[
          _ParasiteCard(
            coverage: coverage,
            choice: draft.parasite(coverage),
            onChanged: (choice) => onChanged(
              (d) => d.copyWith(parasites: {...d.parasites, coverage: choice}),
            ),
          ),
          const SizedBox(height: PawSpace.md),
        ],
      ],
    );
  }
}

class _ParasiteCard extends ConsumerWidget {
  const _ParasiteCard({
    required this.coverage,
    required this.choice,
    required this.onChanged,
  });

  final ParasiteCoverage coverage;
  final ParasiteChoice choice;
  final ValueChanged<ParasiteChoice> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final dateFormat = ref.watch(displayDateFormatProvider);
    final hint = switch ((coverage, choice.mode)) {
      (ParasiteCoverage.heartworm, ParasiteMode.scheduled) =>
        l.parasiteHeartwormTestFirst,
      (ParasiteCoverage.heartworm, ParasiteMode.tests) =>
        l.parasiteHeartwormTestsHint,
      (ParasiteCoverage.intestinal, ParasiteMode.tests) =>
        l.parasiteIntestinalTestsHint,
      _ => null,
    };

    String modeLabel(ParasiteMode mode) => switch (mode) {
      ParasiteMode.scheduled => l.parasiteModeScheduled,
      ParasiteMode.tests => l.parasiteModeTests,
      ParasiteMode.none => l.parasiteModeNone,
    };

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: PawColors.surface,
        borderRadius: BorderRadius.circular(PawRadii.row),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: PawTones.peach.fill,
                  shape: BoxShape.circle,
                ),
                child: PawIcon(PawGlyph.parasite, color: PawTones.peach.onFill),
              ),
              const SizedBox(width: PawSpace.md),
              Text(l.parasiteCoverage(coverage), style: text.titleMedium),
            ],
          ),
          const SizedBox(height: PawSpace.md),
          PillSegmented<ParasiteMode>(
            options: ParasiteOptions.modesFor(coverage),
            selected: choice.mode,
            labelOf: modeLabel,
            onChanged: (mode) =>
                onChanged(ParasiteOptions.defaultFor(coverage, mode)),
          ),
          if (choice.mode != ParasiteMode.none) ...[
            const SizedBox(height: PawSpace.md),
            Wrap(
              spacing: PawSpace.sm,
              runSpacing: PawSpace.sm,
              children: [
                for (final schedule in ParasiteOptions.schedulesFor(
                  coverage,
                  choice.mode,
                ))
                  PawChoiceChip(
                    label: l.schedule(schedule, dateFormat: dateFormat),
                    selected: schedule == choice.schedule,
                    background: PawColors.subtle,
                    onTap: () =>
                        onChanged(ParasiteChoice(choice.mode, schedule)),
                  ),
              ],
            ),
          ],
          if (hint != null) ...[
            const SizedBox(height: PawSpace.md),
            Text(hint, style: text.bodySmall),
          ],
        ],
      ),
    );
  }
}
