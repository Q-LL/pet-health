import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database_provider.dart';
import '../../../core/db/pet_health_database.dart';
import '../../entries/domain/entry_codes.dart';
import '../data/plans_repository.dart';
import '../domain/parasite_choice.dart';

final parasiteSettingsProvider = Provider<ParasiteSettings>((ref) {
  return ParasiteSettings(
    ref.watch(petHealthDatabaseProvider),
    ref.watch(plansRepositoryProvider),
  );
});

/// 修改一类驱虫的方式：删掉这一类原有的计划，再按新的选择生成。
///
/// 之前的驱虫和检查记录都保留，新计划从最近一次记录接着推算。
class ParasiteSettings {
  ParasiteSettings(this._db, this._plans);

  final PetHealthDatabase _db;
  final PlansRepository _plans;

  Future<void> apply(
    String petId,
    ParasiteCoverage coverage,
    ParasiteChoice choice,
  ) => _db.transaction(() async {
    for (final status in await _plans.statusesFor(petId)) {
      if (isParasitePlanFor(coverage, status.plan)) {
        await _plans.delete(status.plan.id);
      }
    }
    final draft = parasitePlanDraft(petId, coverage, choice);
    if (draft != null) await _plans.create(draft);
  });
}
