import 'package:characters/characters.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart' as db;
import '../../../core/database/database_provider.dart';
import '../../../core/files/album_asset_service.dart';
import '../domain/memory_entry.dart';

const androidAlbumReferenceWarningThreshold = 4500;
const androidAlbumReferenceLimit = 5000;

final albumAssetServiceProvider = Provider<AlbumAssetService>((ref) {
  return createAlbumAssetService();
});

final memoryRepositoryProvider = Provider<MemoryRepository>((ref) {
  return MemoryRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(albumAssetServiceProvider),
  );
});

final memoriesForPetProvider = StreamProvider.autoDispose
    .family<List<PetMemoryEntry>, String>((ref, petId) {
      return ref.watch(memoryRepositoryProvider).watchForPet(petId);
    });

class MemoryRepository {
  MemoryRepository(this._database, this._assetService) : _uuid = const Uuid();

  final db.AppDatabase _database;
  final AlbumAssetService _assetService;
  final Uuid _uuid;

  Stream<List<PetMemoryEntry>> watchForPet(
    String petId, {
    int? limit,
    int offset = 0,
  }) {
    _validatePage(limit: limit, offset: offset);
    final query = _database.select(_database.memoryEntries)
      ..where((entry) => entry.petId.equals(petId))
      ..orderBy([
        (entry) => OrderingTerm.desc(entry.occurredAt),
        (entry) => OrderingTerm.desc(entry.createdAt),
      ]);
    if (limit != null) query.limit(limit, offset: offset);
    return query.watch().asyncMap((rows) async {
      return Future.wait(rows.map(_entryFromRow));
    });
  }

  Future<List<PetMemoryEntry>> findForPet(
    String petId, {
    int? limit,
    int offset = 0,
  }) {
    return watchForPet(petId, limit: limit, offset: offset).first;
  }

  Future<PetMemoryEntry?> getById(String id) async {
    final row = await (_database.select(
      _database.memoryEntries,
    )..where((entry) => entry.id.equals(id))).getSingleOrNull();
    return row == null ? null : _entryFromRow(row);
  }

  Future<PetMemoryEntry> create({
    required String petId,
    required DateTime occurredAt,
    required String note,
    required List<AlbumAssetReference> media,
    String? moodEmoji,
  }) async {
    await _validateInput(
      petId: petId,
      note: note,
      moodEmoji: moodEmoji,
      media: media,
    );
    final id = _uuid.v4();
    final now = DateTime.now().toUtc();
    await _database.transaction(() async {
      await _database
          .into(_database.memoryEntries)
          .insert(
            db.MemoryEntriesCompanion.insert(
              id: id,
              petId: petId,
              occurredAt: occurredAt.toUtc(),
              note: Value(note.trim()),
              moodEmoji: Value(_normalizedEmoji(moodEmoji)),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await _replaceMedia(id, media);
    });
    return (await getById(id))!;
  }

  Future<PetMemoryEntry> update(
    String id, {
    required DateTime occurredAt,
    required String note,
    required List<AlbumAssetReference> media,
    String? moodEmoji,
  }) async {
    final existing = await getById(id);
    if (existing == null) throw StateError('爱宠时光不存在：$id');
    await _validateInput(
      petId: existing.petId,
      note: note,
      moodEmoji: moodEmoji,
      media: media,
    );
    final oldReferences = existing.media
        .map((item) => item.platformRef)
        .toSet();
    final newReferences = media.map((item) => item.platformRef).toSet();

    await _database.transaction(() async {
      await (_database.update(
        _database.memoryEntries,
      )..where((entry) => entry.id.equals(id))).write(
        db.MemoryEntriesCompanion(
          occurredAt: Value(occurredAt.toUtc()),
          note: Value(note.trim()),
          moodEmoji: Value(_normalizedEmoji(moodEmoji)),
          updatedAt: Value(DateTime.now().toUtc()),
        ),
      );
      await (_database.delete(
        _database.memoryMediaRefs,
      )..where((item) => item.entryId.equals(id))).go();
      await _replaceMedia(id, media);
    });

    for (final reference in oldReferences.difference(newReferences)) {
      await _releaseIfUnused(reference);
    }
    return (await getById(id))!;
  }

  Future<bool> delete(String id) async {
    final existing = await getById(id);
    if (existing == null) return false;
    final references = existing.media.map((item) => item.platformRef).toSet();
    await (_database.delete(
      _database.memoryEntries,
    )..where((entry) => entry.id.equals(id))).go();
    for (final reference in references) {
      await _releaseIfUnused(reference);
    }
    return true;
  }

  Future<void> deleteAllForPet(String petId) async {
    final entries = await findForPet(petId);
    final references = entries
        .expand((entry) => entry.media)
        .map((item) => item.platformRef)
        .toSet();
    await (_database.delete(
      _database.memoryEntries,
    )..where((entry) => entry.petId.equals(petId))).go();
    for (final reference in references) {
      await _releaseIfUnused(reference);
    }
  }

  Future<int> count(String petId) {
    final query = _database.selectOnly(_database.memoryEntries)
      ..addColumns([_database.memoryEntries.id.count()])
      ..where(_database.memoryEntries.petId.equals(petId));
    return query
        .map((row) => row.read(_database.memoryEntries.id.count()) ?? 0)
        .getSingle();
  }

  Future<int> distinctReferenceCount() async {
    final rows = await (_database.selectOnly(
      _database.memoryMediaRefs,
      distinct: true,
    )..addColumns([_database.memoryMediaRefs.platformRef])).get();
    return rows.length;
  }

  Future<void> _replaceMedia(
    String entryId,
    List<AlbumAssetReference> media,
  ) async {
    for (var index = 0; index < media.length; index++) {
      final item = media[index];
      await _database
          .into(_database.memoryMediaRefs)
          .insert(
            db.MemoryMediaRefsCompanion.insert(
              id: _uuid.v4(),
              entryId: entryId,
              kind: item.kind.name,
              platformRef: item.platformRef,
              position: index,
              width: Value(item.width),
              height: Value(item.height),
              durationMs: Value(item.durationMs),
              capturedAt: Value(item.capturedAt?.toUtc()),
            ),
          );
    }
  }

  Future<PetMemoryEntry> _entryFromRow(db.MemoryEntry row) async {
    final mediaRows =
        await (_database.select(_database.memoryMediaRefs)
              ..where((item) => item.entryId.equals(row.id))
              ..orderBy([(item) => OrderingTerm.asc(item.position)]))
            .get();
    return PetMemoryEntry(
      id: row.id,
      petId: row.petId,
      occurredAt: row.occurredAt.toLocal(),
      note: row.note,
      moodEmoji: row.moodEmoji,
      media: mediaRows
          .map(
            (item) => MemoryMediaReference(
              id: item.id,
              entryId: item.entryId,
              platformRef: item.platformRef,
              kind: item.kind == AlbumAssetKind.video.name
                  ? AlbumAssetKind.video
                  : AlbumAssetKind.image,
              position: item.position,
              width: item.width,
              height: item.height,
              durationMs: item.durationMs,
              capturedAt: item.capturedAt?.toLocal(),
            ),
          )
          .toList(growable: false),
      createdAt: row.createdAt.toUtc(),
      updatedAt: row.updatedAt.toUtc(),
    );
  }

  Future<void> _releaseIfUnused(String reference) async {
    final remaining =
        await (_database.selectOnly(_database.memoryMediaRefs)
              ..addColumns([_database.memoryMediaRefs.id.count()])
              ..where(_database.memoryMediaRefs.platformRef.equals(reference)))
            .map((row) => row.read(_database.memoryMediaRefs.id.count()) ?? 0)
            .getSingle();
    if (remaining == 0) {
      try {
        await _assetService.releaseReference(reference);
      } on Object {
        // The database remains authoritative when an OS grant already expired.
      }
    }
  }

  Future<void> _validateInput({
    required String petId,
    required String note,
    required String? moodEmoji,
    required List<AlbumAssetReference> media,
  }) async {
    final pet = await (_database.select(
      _database.pets,
    )..where((row) => row.id.equals(petId))).getSingleOrNull();
    if (pet == null || pet.isPlaceholder) {
      throw const FormatException('请先创建真实的狗狗档案');
    }
    if (note.trim().isEmpty && media.isEmpty) {
      throw const FormatException('请填写随笔或选择照片、视频');
    }
    final normalizedMood = _normalizedEmoji(moodEmoji);
    if (normalizedMood != null && !isValidMoodEmoji(normalizedMood)) {
      throw const FormatException('心情贴纸只能选择一个 Emoji');
    }
    final videos = media
        .where((item) => item.kind == AlbumAssetKind.video)
        .length;
    final images = media
        .where((item) => item.kind == AlbumAssetKind.image)
        .length;
    if (videos > 1 || (videos > 0 && images > 0)) {
      throw const FormatException('每篇只能选择多张照片或一个视频');
    }
    if (media.map((item) => item.platformRef).toSet().length != media.length) {
      throw const FormatException('同一篇日志不能重复添加相同媒体');
    }
    final activeReferences = await distinctReferenceCount();
    final newReferences = media.map((item) => item.platformRef).toSet();
    final existingRows = newReferences.isEmpty
        ? const <db.MemoryMediaRef>[]
        : await (_database.select(
            _database.memoryMediaRefs,
          )..where((row) => row.platformRef.isIn(newReferences))).get();
    final existingReferences = existingRows
        .map((row) => row.platformRef)
        .toSet();
    final additionalReferences = newReferences.difference(existingReferences);
    if (activeReferences + additionalReferences.length >
        androidAlbumReferenceLimit) {
      throw const FormatException('系统相册引用已达到 5000 个，请先移除部分旧媒体');
    }
  }

  void _validatePage({int? limit, required int offset}) {
    if (limit != null && limit <= 0) {
      throw const FormatException('limit 必须大于 0');
    }
    if (offset < 0 || (offset > 0 && limit == null)) {
      throw const FormatException('offset 必须非负且只能与 limit 一起使用');
    }
  }
}

bool isValidMoodEmoji(String value) {
  final normalized = value.trim();
  if (normalized.isEmpty || normalized.characters.length != 1) return false;
  return normalized.runes.any(_isEmojiRune);
}

bool _isEmojiRune(int rune) {
  return (rune >= 0x1F000 && rune <= 0x1FAFF) ||
      (rune >= 0x2600 && rune <= 0x27BF) ||
      (rune >= 0x1F1E6 && rune <= 0x1F1FF) ||
      rune == 0x2764 ||
      rune == 0x00A9 ||
      rune == 0x00AE ||
      rune == 0x203C ||
      rune == 0x2049 ||
      rune == 0x2122 ||
      rune == 0x2139 ||
      rune == 0x3030 ||
      rune == 0x303D ||
      rune == 0x3297 ||
      rune == 0x3299;
}

String? _normalizedEmoji(String? value) {
  final trimmed = value?.trim();
  return trimmed == null || trimmed.isEmpty ? null : trimmed;
}
