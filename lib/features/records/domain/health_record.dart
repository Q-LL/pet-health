import 'package:flutter/foundation.dart';

const healthRecordTypes = {
  'weight',
  'food_water',
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
  });

  final String petId;
  final String type;
  final DateTime occurredAt;
  final String title;
  final String note;
  final double? numericValue;
  final String? unit;
  final int? severity;
}
