import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/core/database/app_database.dart';
import 'package:pet_health/core/files/photo_storage.dart';
import 'package:pet_health/features/pets/data/pet_photo_repository.dart';
import 'package:pet_health/features/pets/data/pet_repository.dart';
import 'package:pet_health/features/pets/domain/pet_profile.dart';

void main() {
  late AppDatabase database;
  late _MemoryPhotoStorage storage;
  late PetPhotoRepository photos;
  late PetRepository pets;
  late String petId;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    storage = _MemoryPhotoStorage();
    photos = PetPhotoRepository(database, storage);
    pets = PetRepository(database, photos);
    petId = (await pets.create(const PetDraft(name: '团子'))).id;
  });

  tearDown(() => database.close());

  test('adds, reads and automatically uses first photo as avatar', () async {
    final bytes = Uint8List.fromList([1, 2, 3, 4]);
    final photo = await photos.add(
      petId: petId,
      bytes: bytes,
      originalName: 'avatar.jpg',
      mediaType: 'image/jpeg',
      caption: '一岁生日',
    );

    expect(photo.isAvatar, isTrue);
    expect(await photos.readBytes(photo.id), bytes);
    expect((await pets.getById(petId))?.avatarPath, photo.filePath);
  });

  test('updates metadata, searches, pages and changes avatar', () async {
    final first = await photos.add(
      petId: petId,
      bytes: Uint8List.fromList([1]),
      originalName: 'first.jpg',
      mediaType: 'image/jpeg',
    );
    final second = await photos.add(
      petId: petId,
      bytes: Uint8List.fromList([2]),
      originalName: 'park.png',
      mediaType: 'image/png',
      caption: '公园散步',
    );

    final updated = await photos.updateMetadata(
      second.id,
      caption: '滨江公园散步',
      capturedAt: DateTime.utc(2026, 6, 23),
    );
    final avatar = await photos.setAvatar(second.id);
    final search = await photos.findForPet(petId, keyword: '滨江');
    final page = await photos.findForPet(petId, limit: 1, offset: 1);

    expect(updated.caption, '滨江公园散步');
    expect(avatar.isAvatar, isTrue);
    expect((await photos.getById(first.id))?.isAvatar, isFalse);
    expect(search.single.id, second.id);
    expect(page, hasLength(1));
  });

  test(
    'deleting avatar promotes another photo and removes local file',
    () async {
      final first = await photos.add(
        petId: petId,
        bytes: Uint8List.fromList([1]),
        originalName: 'first.jpg',
        mediaType: 'image/jpeg',
      );
      final second = await photos.add(
        petId: petId,
        bytes: Uint8List.fromList([2]),
        originalName: 'second.jpg',
        mediaType: 'image/jpeg',
        setAsAvatar: true,
      );

      expect(await photos.delete(second.id), isTrue);
      expect(storage.contains(second.filePath!), isFalse);
      expect((await photos.getById(first.id))?.isAvatar, isTrue);
      expect(await photos.delete(second.id), isFalse);
    },
  );

  test('deleting pet cleans photo storage and database rows', () async {
    final photo = await photos.add(
      petId: petId,
      bytes: Uint8List.fromList([1, 2]),
      originalName: 'pet.webp',
      mediaType: 'image/webp',
    );

    expect(await pets.delete(petId), isTrue);
    expect(storage.contains(photo.filePath!), isFalse);
    expect(await photos.findForPet(petId), isEmpty);
  });

  test('count returns total and respects keyword', () async {
    await photos.add(
      petId: petId,
      bytes: Uint8List.fromList([1]),
      originalName: 'park.jpg',
      mediaType: 'image/jpeg',
      caption: '公园散步',
    );
    await photos.add(
      petId: petId,
      bytes: Uint8List.fromList([2]),
      originalName: 'home.png',
      mediaType: 'image/png',
      caption: '在家休息',
    );

    expect(await photos.count(petId), 2);
    expect(await photos.count(petId, keyword: '公园'), 1);
    expect(await photos.count(petId, keyword: 'png'), 1);
    expect(await photos.count(petId, keyword: '不存在'), 0);
  });

  test('rejects empty, oversized and unsupported photo data', () async {
    expect(
      () => photos.add(
        petId: petId,
        bytes: Uint8List(0),
        originalName: 'empty.jpg',
        mediaType: 'image/jpeg',
      ),
      throwsFormatException,
    );
    expect(
      () => photos.add(
        petId: petId,
        bytes: Uint8List.fromList([1]),
        originalName: 'pet.gif',
        mediaType: 'image/gif',
      ),
      throwsFormatException,
    );
  });
}

class _MemoryPhotoStorage implements LocalPhotoStorage {
  final _files = <String, Uint8List>{};

  bool contains(String path) => _files.containsKey(path);

  @override
  Future<StoredPhotoPayload> save({
    required String petId,
    required String photoId,
    required String originalName,
    required Uint8List bytes,
  }) async {
    final path = 'memory://$petId/$photoId';
    _files[path] = Uint8List.fromList(bytes);
    return StoredPhotoPayload(filePath: path);
  }

  @override
  Future<Uint8List> read({String? filePath, Uint8List? bytes}) async {
    return Uint8List.fromList(_files[filePath]!);
  }

  @override
  Future<void> delete(String? filePath) async {
    _files.remove(filePath);
  }
}
