import 'package:flutter/foundation.dart';

import 'health_record_spec.dart';

const healthRecordTypes = {
  'weight',
  'food',
  'water',
  'elimination',
  'symptom',
  'medication',
  'vaccine',
  'deworming',
  'custom',
};

@immutable
class HealthRecord {
  const HealthRecord({
    required this.id,
    required this.petId,
    required this.type,
    required this.occurredAt,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.note = '',
    this.numericValue,
    this.unit,
    this.severity,
    this.details = const {},
  });

  final String id;
  final String petId;
  final String type;
  final DateTime occurredAt;
  final String title;
  final String note;
  final double? numericValue;
  final String? unit;
  final int? severity;
  final Map<String, String> details;
  final DateTime createdAt;
  final DateTime updatedAt;
}

@immutable
class HealthRecordDraft {
  const HealthRecordDraft({
    required this.petId,
    required this.type,
    required this.occurredAt,
    required this.title,
    this.note = '',
    this.numericValue,
    this.unit,
    this.severity,
    this.details = const {},
  });

  final String petId;
  final String type;
  final DateTime occurredAt;
  final String title;
  final String note;
  final double? numericValue;
  final String? unit;
  final int? severity;
  final Map<String, String> details;
}

@immutable
class HealthRecordPrefill {
  const HealthRecordPrefill({
    this.title,
    this.note = '',
    this.numericValue,
    this.unit,
    this.severity,
    this.details = const {},
  });

  final String? title;
  final String note;
  final double? numericValue;
  final String? unit;
  final int? severity;
  final Map<String, String> details;
}

HealthRecordDraft healthRecordDraftFromPrefill({
  required String petId,
  required String type,
  required DateTime occurredAt,
  required HealthRecordPrefill prefill,
}) {
  final spec = healthRecordSpecFor(type);
  return HealthRecordDraft(
    petId: petId,
    type: type,
    occurredAt: occurredAt,
    title: prefill.title?.trim().isNotEmpty == true
        ? prefill.title!.trim()
        : spec.defaultTitle,
    note: prefill.note,
    numericValue: prefill.numericValue,
    unit: prefill.unit ?? spec.defaultUnit,
    severity: prefill.severity,
    details: prefill.details,
  );
}
