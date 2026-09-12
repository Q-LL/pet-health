import 'package:flutter/foundation.dart';

import '../../../core/files/album_asset_types.dart';

@immutable
class MemoryMediaReference {
  const MemoryMediaReference({
    required this.id,
    required this.entryId,
    required this.platformRef,
    required this.kind,
    required this.position,
    this.width,
    this.height,
    this.durationMs,
    this.capturedAt,
  });

  final String id;
  final String entryId;
  final String platformRef;
  final AlbumAssetKind kind;
  final int position;
  final int? width;
  final int? height;
  final int? durationMs;
  final DateTime? capturedAt;
}

@immutable
class PetMemoryEntry {
  const PetMemoryEntry({
    required this.id,
    required this.petId,
    required this.occurredAt,
    required this.note,
    required this.media,
    required this.createdAt,
    required this.updatedAt,
    this.moodEmoji,
  });

  final String id;
  final String petId;
  final DateTime occurredAt;
  final String note;
  final String? moodEmoji;
  final List<MemoryMediaReference> media;
  final DateTime createdAt;
  final DateTime updatedAt;
}
