import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';

import '../../../core/design/design.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/units/units.dart';
import '../../entries/domain/entry_codes.dart';
import '../../pets/domain/pet_codes.dart';
import '../../pets/presentation/pet_fields.dart';
import '../../plans/presentation/parasite_choice_card.dart';
import '../../settings/application/display_settings.dart';
import '../../settings/data/preferences_repository.dart';
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
      // 第一只狗狗建好后，路由会自动从引导页转到今天页。
      final pet = await ref.read(onboardingServiceProvider).finish(_draft);
      if (_adding) {
        // 添加的狗狗直接选中，回到今天页看它。
        await ref.read(preferencesRepositoryProvider).setSelectedPet(pet.id);
        if (mounted) context.go(Routes.today);
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  bool get _adding =>
      GoRouterState.of(context).uri.queryParameters['add'] == '1';

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
                  if (_step == 0 && _adding)
                    TextButton(
                      onPressed: () => context.go(Routes.pet),
                      style: TextButton.styleFrom(
                        foregroundColor: PawColors.inkMuted,
                      ),
                      child: Text(l.actionCancel),
                    ),
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
            style: PawTextStyles.of(
              context,
            ).note.copyWith(color: PawColors.inkMuted),
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

class _BreedStep extends StatelessWidget {
  const _BreedStep({required this.draft, required this.onChanged});

  final OnboardingDraft draft;
  final DraftUpdate onChanged;

  @override
  Widget build(BuildContext context) => _StepScaffold(
    title: AppLocalizations.of(context).onboardingBreedTitle(draft.name.trim()),
    children: [
      BreedSelector(
        breedCode: draft.breedCode,
        breedName: draft.breedName,
        breedGroup: draft.breedGroup,
        onBreed: (code) => onChanged(
          (d) => d.copyWith(
            breedCode: () => code,
            breedName: () => null,
            breedGroup: () => null,
          ),
        ),
        onOther: () => onChanged(
          (d) => d.copyWith(
            breedCode: () => null,
            breedGroup: () => d.breedGroup ?? BreedGroup.mixed,
          ),
        ),
        onName: (name) => onChanged((d) => d.copyWith(breedName: () => name)),
        onGroup: (group) =>
            onChanged((d) => d.copyWith(breedGroup: () => group)),
      ),
    ],
  );
}

class _DatesStep extends StatelessWidget {
  const _DatesStep({required this.draft, required this.onChanged});

  final OnboardingDraft draft;
  final DraftUpdate onChanged;

  @override
  Widget build(BuildContext context) => _StepScaffold(
    title: AppLocalizations.of(context).onboardingDatesTitle,
    children: [
      PetDateFields(
        birthDate: draft.birthDate,
        birthPrecision: draft.birthPrecision,
        homeDate: draft.homeDate,
        onBirthDate: (date) =>
            onChanged((d) => d.copyWith(birthDate: () => date)),
        onBirthPrecision: (precision) =>
            onChanged((d) => d.copyWith(birthPrecision: precision)),
        onHomeDate: (date) =>
            onChanged((d) => d.copyWith(homeDate: () => date)),
      ),
    ],
  );
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
          ParasiteChoiceCard(
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
