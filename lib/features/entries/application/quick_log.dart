import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/codes/coded_enum.dart';
import '../../../core/db/database_provider.dart';
import '../../pets/domain/pet.dart';
import '../data/entries_repository.dart';
import '../domain/entry.dart';
import '../domain/entry_codes.dart';
import '../domain/entry_details.dart';

final quickLogProvider = Provider<QuickLog>((ref) {
  return QuickLog(
    ref.watch(entriesRepositoryProvider),
    clock: ref.watch(clockProvider),
  );
});

/// 一键记录的结果。
@immutable
sealed class QuickLogResult {
  const QuickLogResult();
}

/// 已经按默认值记好。
final class Logged extends QuickLogResult {
  const Logged(this.entry);

  final Entry entry;
}

final class WalkStarted extends QuickLogResult {
  const WalkStarted(this.entry);

  final Entry entry;
}

final class WalkFinished extends QuickLogResult {
  const WalkFinished(this.entry);

  final Entry entry;
}

/// 这一类需要用户填一些内容（体重、症状……），交给补充面板。
final class NeedsDetails extends QuickLogResult {
  const NeedsDetails(this.draft);

  final EntryDraft draft;
}

/// 一键记录：点一下按习惯预设和默认选项记一条，记不了的交给补充面板。
class QuickLog {
  QuickLog(this._entries, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final EntriesRepository _entries;
  final DateTime Function() _clock;

  Future<QuickLogResult> log({
    required String petId,
    required EntryType type,
    PetPresets? presets,
    String? planId,
    String? kind,
  }) async {
    if (type == EntryType.walk) {
      final finished = await _entries.finishWalk(petId);
      if (finished != null) return WalkFinished(finished);
      return WalkStarted(await _entries.startWalk(petId));
    }
    final draft = draftFor(
      petId: petId,
      type: type,
      at: _clock(),
      presets: presets,
      planId: planId,
      kind: kind,
    );
    if (!canLogInstantly(type, kind: kind)) return NeedsDetails(draft);
    return Logged(await _entries.create(draft));
  }

  /// 点一下就能记的类型；其余的需要先填内容。
  ///
  /// 其他护理和驱虫要知道具体是哪一项，计划卡片会带上 [kind]。
  static bool canLogInstantly(EntryType type, {String? kind}) => switch (type) {
    EntryType.meal ||
    EntryType.water ||
    EntryType.potty ||
    EntryType.brushing ||
    EntryType.walk ||
    EntryType.bath ||
    EntryType.grooming ||
    EntryType.earCheck => true,
    EntryType.otherCare => decodeCode(OtherCareKind.values, kind) != null,
    EntryType.parasitePrevention =>
      decodeCode(ParasiteCoverage.values, kind) != null,
    EntryType.weight ||
    EntryType.symptom ||
    EntryType.medication ||
    EntryType.vaccine ||
    EntryType.vetTest ||
    EntryType.custom => false,
  };

  /// 一键记录时写入的内容：习惯预设里的份量，加上最常见的选项。
  static EntryDraft draftFor({
    required String petId,
    required EntryType type,
    required DateTime at,
    PetPresets? presets,
    String? planId,
    String? kind,
  }) {
    final mealAmount = presets?.mealAmount;
    final mealUnit = presets?.mealUnit;
    final hasPortion = mealAmount != null && mealUnit != null;
    return EntryDraft(
      petId: petId,
      type: type,
      occurredAt: at,
      planId: planId,
      amount: switch (type) {
        EntryType.meal when hasPortion => mealAmount,
        EntryType.water => presets?.bowlMl,
        _ => null,
      },
      unit: type == EntryType.meal && hasPortion ? mealUnit : null,
      details: switch (type) {
        EntryType.meal => const MealDetails(appetite: Appetite.finished),
        EntryType.potty => const PottyDetails(
          kind: PottyKind.poop,
          stool: StoolStatus.normal,
        ),
        EntryType.brushing => const BrushingDetails(coat: CoatCondition.smooth),
        EntryType.bath => const BathDetails(where: BathPlace.home),
        EntryType.grooming => const GroomingDetails(
          where: GroomingPlace.groomer,
        ),
        EntryType.earCheck => const EarCheckDetails(ears: EarCondition.clean),
        EntryType.otherCare => OtherCareDetails(
          kind: decodeCode(OtherCareKind.values, kind),
        ),
        EntryType.parasitePrevention => ParasitePreventionDetails(
          coverage: {?decodeCode(ParasiteCoverage.values, kind)},
        ),
        EntryType.vetTest => VetTestDetails(
          kind: decodeCode(VetTestKind.values, kind),
        ),
        _ => null,
      },
    );
  }
}
