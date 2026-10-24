import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design/design.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/l10n/unit_format.dart';
import '../../entries/domain/entry_codes.dart';
import '../../settings/application/display_settings.dart';
import '../domain/parasite_choice.dart';

/// 一类驱虫的设置：选按时用药、定期检查或先不设置，再选间隔。
class ParasiteChoiceCard extends ConsumerWidget {
  const ParasiteChoiceCard({
    super.key,
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
