import '../../../core/l10n/app_locale.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/l10n/unit_format.dart';
import '../../../core/units/unit_preferences.dart';
import '../domain/entry.dart';
import '../domain/entry_codes.dart';
import '../domain/entry_details.dart';

extension EntrySummary on AppLocalizations {
  /// 一条记录的简短摘要，比如"便便 · 正常"或"饮食 · 2 勺 · 吃完了"。
  String entrySummary(Entry entry, ResolvedUnits units) {
    final details = entry.details;
    final amount = entry.amount;
    final unit = entry.unit;
    final label = entry.label?.trim();
    final head = switch (details) {
      // 排泄直接说"便便"或"尿尿"，比"排泄"更具体。
      PottyDetails(:final kind) => pottyKind(kind ?? PottyKind.poop),
      _ when label != null && label.isNotEmpty => label,
      _ => entryType(entry.type),
    };
    final quantity = switch (entry.type) {
      EntryType.meal || EntryType.medication
          when amount != null && unit != null =>
        portion(amount, unit),
      EntryType.water when amount != null => water(amount, units.water),
      EntryType.weight when amount != null => weight(amount, units.weight),
      EntryType.walk when entry.durationSec != null => durationMinutes(
        (entry.durationSec! / 60).round(),
      ),
      _ => null,
    };
    return [head, ?quantity, ...details.options.map(option)].join(' · ');
  }
}
