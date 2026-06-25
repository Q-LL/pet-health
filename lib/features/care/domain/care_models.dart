import 'package:flutter/foundation.dart';

const careActivityTypes = {
  'bath',
  'walk',
  'oral',
  'combing',
  'styling',
  'nail',
  'ear',
  'eye',
  'paw',
  'environment',
  'custom',
};

@immutable
class CareActivity {
  const CareActivity({
    required this.id,
    required this.petId,
    required this.type,
    required this.occurredAt,
    required this.createdAt,
    required this.updatedAt,
    this.startedAt,
    this.endedAt,
    this.duration,
    this.place = '',
    this.note = '',
    this.details = const {},
    this.routeFilePath,
  });

  final String id;
  final String petId;
  final String type;
  final DateTime occurredAt;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final Duration? duration;
  final String place;
  final String note;
  final Map<String, String> details;
  final String? routeFilePath;
  final DateTime createdAt;
  final DateTime updatedAt;
}

@immutable
class CareActivityDraft {
  const CareActivityDraft({
    required this.petId,
    required this.type,
    required this.occurredAt,
    this.startedAt,
    this.endedAt,
    this.place = '',
    this.note = '',
    this.details = const {},
    this.routeFilePath,
  });

  final String petId;
  final String type;
  final DateTime occurredAt;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final String place;
  final String note;
  final Map<String, String> details;
  final String? routeFilePath;
}

@immutable
class CareActivityPrefill {
  const CareActivityPrefill({
    this.place = '',
    this.note = '',
    this.details = const {},
  });

  final String place;
  final String note;
  final Map<String, String> details;
}

CareActivityDraft careActivityDraftFromPrefill({
  required String petId,
  required String type,
  required DateTime occurredAt,
  required CareActivityPrefill prefill,
}) {
  return CareActivityDraft(
    petId: petId,
    type: type,
    occurredAt: occurredAt,
    place: prefill.place,
    note: prefill.note,
    details: prefill.details,
  );
}

@immutable
class BathRecord {
  const BathRecord({required this.occurredAt, required this.place});

  final DateTime occurredAt;
  final String place;
}

@immutable
class WalkRecord {
  const WalkRecord({
    required this.startedAt,
    required this.endedAt,
    required this.duration,
    required this.place,
  });

  final DateTime startedAt;
  final DateTime endedAt;
  final Duration duration;
  final String place;
}

@immutable
class CareState {
  const CareState({
    this.lastBath,
    this.activeWalkStartedAt,
    this.walks = const [],
  });

  final BathRecord? lastBath;
  final DateTime? activeWalkStartedAt;
  final List<WalkRecord> walks;

  WalkRecord? get lastWalk => walks.isEmpty ? null : walks.first;

  CareState copyWith({
    BathRecord? lastBath,
    DateTime? activeWalkStartedAt,
    bool clearActiveWalk = false,
    List<WalkRecord>? walks,
  }) {
    return CareState(
      lastBath: lastBath ?? this.lastBath,
      activeWalkStartedAt: clearActiveWalk
          ? null
          : activeWalkStartedAt ?? this.activeWalkStartedAt,
      walks: walks ?? this.walks,
    );
  }
}
