import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/shell.dart';
import '../../../core/db/database_provider.dart';
import '../../../core/design/design.dart';
import '../../../core/format/date_display.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/l10n/unit_format.dart';
import '../../entries/application/quick_log.dart';
import '../../entries/data/entries_repository.dart';
import '../../entries/domain/entry.dart';
import '../../entries/domain/entry_codes.dart';
import '../../entries/presentation/entry_sheet.dart';
import '../../plans/application/plan_providers.dart';
import '../../plans/domain/parasite_choice.dart';
import '../../plans/domain/plan.dart';
import '../../settings/application/display_settings.dart';
import '../../settings/data/preferences_repository.dart';
import '../../settings/presentation/settings_page.dart';
import '../../today/application/today_providers.dart';
import '../application/current_pet.dart';
import '../data/pets_repository.dart';
import '../domain/pet.dart';
import 'pet_edit_page.dart';
import 'pet_sheets.dart';

/// 最近 90 天的体重记录，按时间倒序。
final _recentWeightsProvider = StreamProvider.autoDispose<List<Entry>>((ref) {
  final pet = ref.watch(currentPetProvider);
  if (pet == null) return Stream.value(const []);
  final today = ref.watch(todayProvider);
  return ref
      .watch(entriesRepositoryProvider)
      .watchForPet(
        pet.id,
        types: const {EntryType.weight},
        from: today.subtract(const Duration(days: 90)),
        to: today.add(const Duration(days: 1)),
      );
});

/// 最近一次体重，不限时间。
final _latestWeightProvider = StreamProvider.autoDispose<Entry?>((ref) {
  final pet = ref.watch(currentPetProvider);
  if (pet == null) return Stream.value(null);
  return ref
      .watch(entriesRepositoryProvider)
      .watchForPet(pet.id, types: const {EntryType.weight}, limit: 1)
      .map((list) => list.firstOrNull);
});

/// 狗狗档案：资料、体重、习惯预设、驱虫方式。
class PetPage extends ConsumerWidget {
  const PetPage({super.key});

  void _push(BuildContext context, Widget page) => Navigator.of(
    context,
    rootNavigator: true,
  ).push(MaterialPageRoute<void>(builder: (_) => page));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final pet = ref.watch(currentPetProvider);
    if (pet == null) return const SizedBox.shrink();
    final multiple = (ref.watch(allPetsProvider).value?.length ?? 0) > 1;

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          PawSpace.page,
          16,
          PawSpace.page,
          navClearance,
        ),
        children: [
          Row(
            children: [
              FilledButton.icon(
                onPressed: () => _showSwitcher(context, ref, pet),
                style: FilledButton.styleFrom(
                  backgroundColor: PawColors.surface,
                  foregroundColor: PawColors.ink,
                ),
                icon: const PawIcon(PawGlyph.chevronDown, size: 16),
                iconAlignment: IconAlignment.end,
                label: Text(multiple ? l.petSwitch : l.petAdd),
              ),
              const Spacer(),
              IconButton(
                tooltip: l.settingsTitle,
                onPressed: () => _push(context, const SettingsPage()),
                style: IconButton.styleFrom(
                  backgroundColor: PawColors.surface,
                  minimumSize: const Size(48, 48),
                ),
                icon: const Icon(Icons.settings_outlined),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _Profile(pet: pet, onEdit: () => showPetEditSheet(context, pet)),
          const SizedBox(height: 16),
          _WeightCard(pet: pet),
          const SizedBox(height: 14),
          _PresetsCard(pet: pet),
          const SizedBox(height: 14),
          _ParasiteCard(pet: pet),
        ],
      ),
    );
  }

  Future<void> _showSwitcher(BuildContext context, WidgetRef ref, Pet current) {
    final l = AppLocalizations.of(context);
    final pets = ref.read(allPetsProvider).value ?? const <Pet>[];
    return showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 0, 22, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final pet in pets) ...[
                OptionTile(
                  label: pet.name,
                  selected: pet.id == current.id,
                  onTap: () {
                    ref
                        .read(preferencesRepositoryProvider)
                        .setSelectedPet(pet.id);
                    Navigator.of(sheetContext).pop();
                  },
                ),
                const SizedBox(height: 10),
              ],
              FilledButton.icon(
                onPressed: () {
                  Navigator.of(sheetContext).pop();
                  context.go('${Routes.welcome}?add=1');
                },
                style: FilledButton.styleFrom(minimumSize: const Size(0, 56)),
                icon: const PawIcon(
                  PawGlyph.plus,
                  size: 18,
                  color: PawColors.ink,
                  strokeWidth: 3,
                ),
                label: Text(l.petAdd),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Profile extends ConsumerWidget {
  const _Profile({required this.pet, required this.onEdit});

  final Pet pet;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final now = ref.watch(clockProvider)();
    final dateFormat = ref.watch(displayDateFormatProvider);
    final breed = l.breed(pet.breedCode) ?? pet.breedName;
    final chips = [
      if (pet.sex case final sex?)
        [l.sex(sex), if (pet.neutered == true) l.petNeutered].join(' · '),
      if (pet.birthDate case final birth?) _age(l, birth, now),
      if (pet.homeDate case final home?)
        l.petHomeSince(formatDisplayDate(home, dateFormat)),
    ];

    return InkWell(
      onTap: onEdit,
      borderRadius: BorderRadius.circular(PawRadii.card),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Sticker(
              StickerArt.golden,
              size: 120,
              turns: -0.014,
              semanticLabel: pet.name,
            ),
            const SizedBox(height: 8),
            Text(pet.name, style: text.displaySmall),
            const SizedBox(height: 4),
            Text(
              [?breed, l.breedGroup(pet.breedGroup)].join(' · '),
              style: text.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final chip in chips)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: PawColors.surface,
                      borderRadius: BorderRadius.circular(PawRadii.chip),
                    ),
                    child: Text(chip, style: text.labelMedium),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: PawColors.peach,
                    borderRadius: BorderRadius.circular(PawRadii.chip),
                  ),
                  child: Text(
                    l.petEdit,
                    style: text.labelMedium?.copyWith(
                      color: PawColors.coralText,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _age(AppLocalizations l, DateTime birth, DateTime now) {
    var months = (now.year - birth.year) * 12 + now.month - birth.month;
    if (now.day < birth.day) months--;
    months = months < 0 ? 0 : months;
    return months < 12
        ? l.petAgeMonths(months)
        : l.petAgeYearsMonths(months ~/ 12, months % 12);
  }
}

/// 白色卡片：标题、可选的右上角说明和内容；点整张卡片进入修改。
class _Card extends StatelessWidget {
  const _Card({
    required this.title,
    required this.child,
    this.trailing,
    this.onTap,
    this.color = PawColors.surface,
  });

  final String title;
  final String? trailing;
  final Widget child;
  final VoidCallback? onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(child: Text(title, style: text.titleSmall)),
                  if (trailing case final trailing?)
                    Text(
                      trailing,
                      style: text.bodySmall?.copyWith(fontSize: 12),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _WeightCard extends ConsumerWidget {
  const _WeightCard({required this.pet});

  final Pet pet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final units = ref.watch(displayUnitsProvider);
    final latest = ref.watch(_latestWeightProvider).value;
    final recent = ref.watch(_recentWeightsProvider).value ?? const <Entry>[];

    Future<void> log() => showEntrySheet(
      context,
      draft: QuickLog.draftFor(
        petId: pet.id,
        type: EntryType.weight,
        at: ref.read(clockProvider)(),
      ),
    );

    return _Card(
      title: l.petWeight,
      trailing: recent.isEmpty ? null : l.petWeightRecent(recent.length),
      onTap: log,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: latest?.amount == null
                ? Text(l.petWeightNone, style: text.bodyMedium)
                : Text(
                    l.weight(latest!.amount!, units.weight),
                    style: text.headlineSmall?.copyWith(
                      fontFamily: PawFonts.latin,
                      fontVariations: PawFonts.weight(FontWeight.w700),
                    ),
                  ),
          ),
          if (recent.length >= 2)
            SizedBox(
              width: 160,
              height: 50,
              child: CustomPaint(
                painter: _Sparkline([
                  for (final entry in recent.reversed) ?entry.amount,
                ]),
              ),
            )
          else
            TextButton(onPressed: log, child: Text(l.cardLogIt)),
        ],
      ),
    );
  }
}

/// 体重小曲线：一条粗的浅色底线加一条细线，最新一次是实心点。
class _Sparkline extends CustomPainter {
  _Sparkline(this.values);

  final List<double> values;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final low = values.reduce((a, b) => a < b ? a : b);
    final high = values.reduce((a, b) => a > b ? a : b);
    final span = (high - low).abs() < 0.001 ? 1.0 : high - low;
    const pad = 6.0;
    Offset point(int i) => Offset(
      pad + (size.width - pad * 2) * i / (values.length - 1),
      size.height - pad - (size.height - pad * 2) * (values[i] - low) / span,
    );
    final path = Path()..moveTo(point(0).dx, point(0).dy);
    for (var i = 1; i < values.length; i++) {
      path.lineTo(point(i).dx, point(i).dy);
    }
    canvas
      ..drawPath(
        path,
        Paint()
          ..color = PawColors.peach
          ..style = PaintingStyle.stroke
          ..strokeWidth = 9
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      )
      ..drawPath(
        path,
        Paint()
          ..color = PawColors.coral
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      )
      ..drawCircle(
        point(values.length - 1),
        5,
        Paint()..color = PawColors.coralText,
      );
  }

  @override
  bool shouldRepaint(_Sparkline old) => old.values != values;
}

class _PresetsCard extends ConsumerWidget {
  const _PresetsCard({required this.pet});

  final Pet pet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final presets = ref.watch(currentPresetsProvider).value;
    final units = ref.watch(displayUnitsProvider);
    final amount = presets?.mealAmount;
    final unit = presets?.mealUnit;
    final bowl = presets?.bowlMl;
    final quick = presets?.quickTypes ?? PetsRepository.defaultQuickTypes;

    return _Card(
      title: l.presetsTitle,
      onTap: () => showPresetsSheet(context, petId: pet.id, presets: presets),
      child: Column(
        children: [
          _Line(
            l.presetMeal,
            amount != null && unit != null
                ? l.portion(amount, unit)
                : l.presetNotSet,
          ),
          _Line(
            l.presetMealsPerDay,
            presets?.mealsPerDay?.toString() ?? l.presetNotSet,
          ),
          _Line(
            l.presetBowl,
            bowl == null ? l.presetNotSet : l.water(bowl, units.water),
          ),
          _Line(
            l.presetQuick,
            quick.map(l.entryType).join(l.weekdayListSeparator),
            last: true,
          ),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line(this.label, this.value, {this.last = false});

  final String label;
  final String value;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: last
          ? null
          : const BoxDecoration(
              border: Border(bottom: BorderSide(color: PawColors.hairline)),
            ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: text.bodyMedium?.copyWith(color: PawColors.inkMuted),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _ParasiteCard extends ConsumerWidget {
  const _ParasiteCard({required this.pet});

  static const _order = [
    ParasiteCoverage.heartworm,
    ParasiteCoverage.intestinal,
    ParasiteCoverage.fleasTicks,
  ];

  final Pet pet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final dateFormat = ref.watch(displayDateFormatProvider);
    final plans = [
      for (final status
          in ref.watch(currentPlanStatusesProvider).value ??
              const <PlanStatus>[])
        status.plan,
    ];
    final choices = {
      for (final coverage in _order)
        coverage: parasiteChoiceFromPlans(coverage, plans),
    };

    String summary(ParasiteChoice choice) => switch (choice) {
      ParasiteChoice(mode: ParasiteMode.scheduled, :final schedule?) =>
        l.parasiteSummaryScheduled(
          l.schedule(schedule, dateFormat: dateFormat),
        ),
      ParasiteChoice(mode: ParasiteMode.tests, :final schedule?) =>
        l.parasiteSummaryTests(l.schedule(schedule, dateFormat: dateFormat)),
      _ => l.parasiteModeNone,
    };

    return _Card(
      title: l.parasiteCardTitle,
      trailing: l.parasiteCardHint,
      color: const Color(0xFFD6F0DE),
      onTap: () => showParasiteSheet(context, petId: pet.id, current: choices),
      child: Column(
        children: [
          for (final coverage in _order)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l.parasiteCoverage(coverage),
                      style: text.bodyMedium,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: choices[coverage]!.mode == ParasiteMode.scheduled
                          ? PawColors.success
                          : PawColors.surface,
                      borderRadius: BorderRadius.circular(PawRadii.chip),
                    ),
                    child: Text(
                      summary(choices[coverage]!),
                      style: text.labelMedium?.copyWith(
                        color: choices[coverage]!.mode == ParasiteMode.scheduled
                            ? Colors.white
                            : PawTones.mint.onFill,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
