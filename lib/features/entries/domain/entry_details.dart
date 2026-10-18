import 'package:flutter/foundation.dart';

import '../../../core/codes/coded_enum.dart';
import 'entry_codes.dart';

/// 记录的结构化细节，存进 `entries.details` 的 JSON 里只有 code。
///
/// 每种 [EntryType] 对应一个子类；没有细节字段的类型使用 [NoDetails]。
/// 读到不认识的 code 时按"未填写"处理，不抛异常。
@immutable
sealed class EntryDetails {
  const EntryDetails();

  Map<String, Object?> toJson();

  /// 这份细节是否属于 [type]，比如 [MealDetails] 只属于饮食。
  bool isFor(EntryType type) =>
      runtimeType == EntryDetails.fromJson(type, const {}).runtimeType;

  static EntryDetails fromJson(EntryType type, Map<String, Object?> json) {
    return switch (type) {
      EntryType.meal => MealDetails(
        appetite: decodeCode(Appetite.values, json['appetite']),
      ),
      EntryType.water => WaterDetails(
        intake: decodeCode(WaterIntake.values, json['intake']),
      ),
      EntryType.potty => PottyDetails(
        kind: decodeCode(PottyKind.values, json['kind']),
        stool: decodeCode(StoolStatus.values, json['stool']),
        urine: decodeCode(UrineStatus.values, json['urine']),
      ),
      EntryType.brushing => BrushingDetails(
        coat: decodeCode(CoatCondition.values, json['coat']),
      ),
      EntryType.bath => BathDetails(
        where: decodeCode(BathPlace.values, json['where']),
      ),
      EntryType.grooming => GroomingDetails(
        where: decodeCode(GroomingPlace.values, json['where']),
      ),
      EntryType.dewormer => DewormerDetails(
        coverage: decodeCodeSet(DewormerCoverage.values, json['coverage']),
      ),
      EntryType.earCheck => EarCheckDetails(
        ears: decodeCode(EarCondition.values, json['ears']),
      ),
      EntryType.otherCare => OtherCareDetails(
        kind: decodeCode(OtherCareKind.values, json['kind']),
      ),
      EntryType.symptom => SymptomDetails(
        kind: decodeCode(SymptomKind.values, json['kind']),
        status: decodeCode(SymptomStatus.values, json['status']),
      ),
      EntryType.walk ||
      EntryType.heartworm ||
      EntryType.weight ||
      EntryType.medication ||
      EntryType.vaccine ||
      EntryType.custom => const NoDetails(),
    };
  }
}

Map<String, Object?> _codes(Map<String, CodedEnum?> fields) => {
  for (final MapEntry(:key, :value) in fields.entries)
    if (value != null) key: value.code,
};

final class NoDetails extends EntryDetails {
  const NoDetails();

  @override
  Map<String, Object?> toJson() => const {};

  @override
  bool operator ==(Object other) => other is NoDetails;

  @override
  int get hashCode => (NoDetails).hashCode;
}

final class MealDetails extends EntryDetails {
  const MealDetails({this.appetite});

  final Appetite? appetite;

  @override
  Map<String, Object?> toJson() => _codes({'appetite': appetite});

  @override
  bool operator ==(Object other) =>
      other is MealDetails && appetite == other.appetite;

  @override
  int get hashCode => appetite.hashCode;
}

final class WaterDetails extends EntryDetails {
  const WaterDetails({this.intake});

  final WaterIntake? intake;

  @override
  Map<String, Object?> toJson() => _codes({'intake': intake});

  @override
  bool operator ==(Object other) =>
      other is WaterDetails && intake == other.intake;

  @override
  int get hashCode => intake.hashCode;
}

final class PottyDetails extends EntryDetails {
  const PottyDetails({this.kind, this.stool, this.urine});

  final PottyKind? kind;

  /// 只在 [kind] 为便便时有意义。
  final StoolStatus? stool;

  /// 只在 [kind] 为尿尿时有意义。
  final UrineStatus? urine;

  @override
  Map<String, Object?> toJson() =>
      _codes({'kind': kind, 'stool': stool, 'urine': urine});

  @override
  bool operator ==(Object other) =>
      other is PottyDetails &&
      kind == other.kind &&
      stool == other.stool &&
      urine == other.urine;

  @override
  int get hashCode => Object.hash(kind, stool, urine);
}

final class BrushingDetails extends EntryDetails {
  const BrushingDetails({this.coat});

  final CoatCondition? coat;

  @override
  Map<String, Object?> toJson() => _codes({'coat': coat});

  @override
  bool operator ==(Object other) =>
      other is BrushingDetails && coat == other.coat;

  @override
  int get hashCode => coat.hashCode;
}

final class BathDetails extends EntryDetails {
  const BathDetails({this.where});

  final BathPlace? where;

  @override
  Map<String, Object?> toJson() => _codes({'where': where});

  @override
  bool operator ==(Object other) =>
      other is BathDetails && where == other.where;

  @override
  int get hashCode => where.hashCode;
}

final class GroomingDetails extends EntryDetails {
  const GroomingDetails({this.where});

  final GroomingPlace? where;

  @override
  Map<String, Object?> toJson() => _codes({'where': where});

  @override
  bool operator ==(Object other) =>
      other is GroomingDetails && where == other.where;

  @override
  int get hashCode => where.hashCode;
}

final class DewormerDetails extends EntryDetails {
  const DewormerDetails({this.coverage = const {}});

  final Set<DewormerCoverage> coverage;

  @override
  Map<String, Object?> toJson() => {
    // 按 enum 声明顺序输出，保证同样的内容总是得到同样的 JSON。
    if (coverage.isNotEmpty)
      'coverage': [
        for (final value in DewormerCoverage.values)
          if (coverage.contains(value)) value.code,
      ],
  };

  @override
  bool operator ==(Object other) =>
      other is DewormerDetails && setEquals(coverage, other.coverage);

  @override
  int get hashCode => Object.hashAllUnordered(coverage);
}

final class EarCheckDetails extends EntryDetails {
  const EarCheckDetails({this.ears});

  final EarCondition? ears;

  @override
  Map<String, Object?> toJson() => _codes({'ears': ears});

  @override
  bool operator ==(Object other) =>
      other is EarCheckDetails && ears == other.ears;

  @override
  int get hashCode => ears.hashCode;
}

final class OtherCareDetails extends EntryDetails {
  const OtherCareDetails({this.kind});

  final OtherCareKind? kind;

  @override
  Map<String, Object?> toJson() => _codes({'kind': kind});

  @override
  bool operator ==(Object other) =>
      other is OtherCareDetails && kind == other.kind;

  @override
  int get hashCode => kind.hashCode;
}

final class SymptomDetails extends EntryDetails {
  const SymptomDetails({this.kind, this.status});

  final SymptomKind? kind;
  final SymptomStatus? status;

  @override
  Map<String, Object?> toJson() => _codes({'kind': kind, 'status': status});

  @override
  bool operator ==(Object other) =>
      other is SymptomDetails && kind == other.kind && status == other.status;

  @override
  int get hashCode => Object.hash(kind, status);
}
