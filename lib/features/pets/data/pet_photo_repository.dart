import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart' as db;
import '../../../core/database/database_provider.dart';
import '../../../core/files/photo_storage.dart';
import '../domain/pet_photo.dart';

const maxPetPhotoBytes = 20 * 1024 * 1024;

final localPhotoStorageProvider = Provider<LocalPhotoStorage>((ref) {
  return createLocalPhotoStorage();
});

final petPhotoRepositoryProvider = Provider<PetPhotoRepository>((ref) {
  return PetPhotoRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(localPhotoStorageProvider),
  );
});

class PetPhotoRepository {
  PetPhotoRepository(this._database, this._storage) : _uuid = const Uuid();

  final db.AppDatabase _database;
  final LocalPhotoStorage _storage;
  final Uuid _uuid;

  Stream<List<PetPhoto>> watchForPet(
    String petId, {
    String? keyword,
    int? limit,
    int offset = 0,
  }) {
    _validatePage(limit: limit, offset: offset);
    final search = keyword?.trim();
    final query = _database.select(_database.petPhotos)
      ..where((photo) {
        var expression = photo.petId.equals(petId);
        if (search != null && search.isNotEmpty) {
          expression &=
              photo.originalName.contains(search) |
              photo.caption.contains(search);
        }
        return expression;
      })
      ..orderBy([
        (photo) => OrderingTerm.desc(photo.isAvatar),
        (photo) => OrderingTerm.desc(photo.capturedAt),
        (photo) => OrderingTerm.desc(photo.createdAt),
      ]);
    if (limit != null) query.limit(limit, offset: offset);
    return query.watch().map(
      (rows) => rows.map(_photoFromRow).toList(growable: false),
    );
  }

  Future<List<PetPhoto>> findForPet(
    String petId, {
    String? keyword,
    int? limit,
    int offset = 0,
  }) {
    return watchForPet(
      petId,
      keyword: keyword,
      limit: limit,
      offset: offset,
    ).first;
  }

  Future<PetPhoto?> getById(String id) async {
    final row = await (_database.select(
      _database.petPhotos,
    )..where((photo) => photo.id.equals(id))).getSingleOrNull();
    return row == null ? null : _photoFromRow(row);
  }

  Future<PetPhoto> add({
    required String petId,
    required Uint8List bytes,
    required String originalName,
    required String mediaType,
    String caption = '',
    DateTime? capturedAt,
    bool setAsAvatar = false,
  }) async {
    await _validateInput(
      petId: petId,
      bytes: bytes,
      originalName: originalName,
      mediaType: mediaType,
    );
    final id = _uuid.v4();
    final now = DateTime.now().toUtc();
    final existingCount =
        await (_database.selectOnly(_database.petPhotos)
              ..addColumns([_database.petPhotos.id.count()])
              ..where(_database.petPhotos.petId.equals(petId)))
            .map((row) => row.read(_database.petPhotos.id.count()) ?? 0)
            .getSingle();
    final makeAvatar = setAsAvatar || existingCount == 0;
    final payload = await _storage.save(
      petId: petId,
      photoId: id,
      originalName: originalName.trim(),
      bytes: bytes,
    );

    try {
      await _database.transaction(() async {
        if (makeAvatar) {
          await (_database.update(_database.petPhotos)
                ..where((photo) => photo.petId.equals(petId)))
              .write(const db.PetPhotosCompanion(isAvatar: Value(false)));
        }
        await _database
            .into(_database.petPhotos)
            .insert(
              db.PetPhotosCompanion.insert(
                id: id,
                petId: petId,
                filePath: Value(payload.filePath),
                bytes: Value(payload.bytes),
                originalName: originalName.trim(),
                mediaType: mediaType,
                caption: Value(caption.trim()),
                capturedAt: Value(capturedAt?.toUtc()),
                isAvatar: Value(makeAvatar),
                createdAt: now,
                updatedAt: now,
              ),
            );
        if (makeAvatar) {
          await _setLegacyAvatarPath(petId, payload.filePath, id, now);
        }
      });
    } on Object {
      await _storage.delete(payload.filePath);
      rethrow;
    }
    return (await getById(id))!;
  }

  Future<PetPhoto> updateMetadata(
    String id, {
    required String caption,
    DateTime? capturedAt,
  }) async {
    if (await getById(id) == null) throw StateError('宠物照片不存在：$id');
    await (_database.update(
      _database.petPhotos,
    )..where((photo) => photo.id.equals(id))).write(
      db.PetPhotosCompanion(
        caption: Value(caption.trim()),
        capturedAt: Value(capturedAt?.toUtc()),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
    return (await getById(id))!;
  }

  Future<PetPhoto> setAvatar(String id) async {
    final photo = await getById(id);
    if (photo == null) throw StateError('宠物照片不存在：$id');
    final now = DateTime.now().toUtc();
    await _database.transaction(() async {
      await (_database.update(_database.petPhotos)
            ..where((row) => row.petId.equals(photo.petId)))
          .write(const db.PetPhotosCompanion(isAvatar: Value(false)));
      await (_database.update(
        _database.petPhotos,
      )..where((row) => row.id.equals(id))).write(
        db.PetPhotosCompanion(
          isAvatar: const Value(true),
          updatedAt: Value(now),
        ),
      );
      await _setLegacyAvatarPath(photo.petId, photo.filePath, id, now);
    });
    return (await getById(id))!;
  }

  Future<Uint8List> readBytes(String id) async {
    final photo = await getById(id);
    if (photo == null) throw StateError('宠物照片不存在：$id');
    return _storage.read(filePath: photo.filePath, bytes: photo.bytes);
  }

  Future<bool> delete(String id) async {
    final photo = await getById(id);
    if (photo == null) return false;
    await _storage.delete(photo.filePath);

    await _database.transaction(() async {
      await (_database.delete(
        _database.petPhotos,
      )..where((row) => row.id.equals(id))).go();
      if (!photo.isAvatar) return;

      final next =
          await (_database.select(_database.petPhotos)
                ..where((row) => row.petId.equals(photo.petId))
                ..orderBy([(row) => OrderingTerm.desc(row.createdAt)])
                ..limit(1))
              .getSingleOrNull();
      if (next == null) {
        await _setLegacyAvatarPath(
          photo.petId,
          null,
          null,
          DateTime.now().toUtc(),
        );
      } else {
        await (_database.update(_database.petPhotos)
              ..where((row) => row.id.equals(next.id)))
            .write(const db.PetPhotosCompanion(isAvatar: Value(true)));
        await _setLegacyAvatarPath(
          photo.petId,
          next.filePath,
          next.id,
          DateTime.now().toUtc(),
        );
      }
    });
    return true;
  }

  Future<void> deleteAllForPet(String petId) async {
    final photos = await findForPet(petId);
    for (final photo in photos) {
      await _storage.delete(photo.filePath);
    }
    await (_database.delete(
      _database.petPhotos,
    )..where((photo) => photo.petId.equals(petId))).go();
  }

  Future<void> _setLegacyAvatarPath(
    String petId,
    String? filePath,
    String? photoId,
    DateTime now,
  ) async {
    await (_database.update(
      _database.pets,
    )..where((pet) => pet.id.equals(petId))).write(
      db.PetsCompanion(
        avatarPath: Value(
          filePath ?? (photoId == null ? null : 'photo:$photoId'),
        ),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> _validateInput({
    required String petId,
    required Uint8List bytes,
    required String originalName,
    required String mediaType,
  }) async {
    final pet = await (_database.select(
      _database.pets,
    )..where((row) => row.id.equals(petId))).getSingleOrNull();
    if (pet == null) throw StateError('宠物档案不存在：$petId');
    if (bytes.isEmpty) throw const FormatException('照片内容不能为空');
    if (bytes.length > maxPetPhotoBytes) {
      throw const FormatException('单张照片不能超过 20 MB');
    }
    if (originalName.trim().isEmpty) {
      throw const FormatException('照片文件名不能为空');
    }
    if (!supportedPetPhotoMediaTypes.contains(mediaType)) {
      throw FormatException('不支持的照片格式：$mediaType');
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

  PetPhoto _photoFromRow(db.PetPhoto row) => PetPhoto(
    id: row.id,
    petId: row.petId,
    filePath: row.filePath,
    bytes: row.bytes,
    originalName: row.originalName,
    mediaType: row.mediaType,
    caption: row.caption,
    capturedAt: row.capturedAt?.toUtc(),
    isAvatar: row.isAvatar,
    createdAt: row.createdAt.toUtc(),
    updatedAt: row.updatedAt.toUtc(),
  );
}
