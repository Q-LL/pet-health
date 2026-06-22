import 'package:flutter/foundation.dart';

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
