import '../../../core/codes/coded_enum.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/l10n/labels.dart';
import '../../entries/domain/entry_codes.dart';
import '../domain/plan.dart';

extension PlanLabels on AppLocalizations {
  /// 计划的名称：自定义事项用用户起的名字，细分项用细分项的名字。
  String planName(Plan plan) {
    if (plan.entryType == EntryType.custom) {
      return plan.title ?? entryTypeCustom;
    }
    final kind = plan.entryKind;
    final CodedEnum? specific = switch (plan.entryType) {
      EntryType.parasitePrevention => decodeCode(ParasiteCoverage.values, kind),
      EntryType.vetTest => decodeCode(VetTestKind.values, kind),
      EntryType.otherCare => decodeCode(OtherCareKind.values, kind),
      _ => null,
    };
    return specific == null ? entryType(plan.entryType) : option(specific);
  }
}
