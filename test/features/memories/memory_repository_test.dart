import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/core/database/app_database.dart';
import 'package:pet_health/core/files/album_asset_types.dart';
import 'package:pet_health/features/memories/data/memory_repository.dart';
import 'package:pet_health/features/pets/data/pet_repository.dart';
import 'package:pet_health/features/pets/domain/pet_profile.dart';

void main() {
  late AppDatabase database;
  late _FakeAlbumAssetService assets;
  late MemoryRepository memories;
  late PetRepository pets;
  late String petId;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    assets = _FakeAlbumAssetService();
    memories = MemoryRepository(database, assets);
    pets = PetRepository(database, null, memories);
    petId = (await pets.create(const PetDraft(name: '团子'))).id;
  });

  tearDown(() => database.close());

  test(
    'creates text-only entries and orders the timeline newest first',
    () async {
      final older = await memories.create(
        petId: petId,
        occurredAt: DateTime(2026, 7, 1),
        note: '第一次去海边',
        moodEmoji: '🥰',
        media: const [],
      );
      final newer = await memories.create(
        petId: petId,
        occurredAt: DateTime(2026, 7, 2),
        note: '今天很开心',
        media: const [],
      );

      final timeline = await memories.findForPet(petId);
      expect(timeline.map((entry) => entry.id), [newer.id, older.id]);
      expect(timeline.last.moodEmoji, '🥰');
      expect(await memories.count(petId), 2);
    },
  );

  test('supports unlimited photos while preserving their order', () async {
    final photos = List.generate(
      11,
      (index) => _asset('photo-$index', AlbumAssetKind.image),
    );
    final entry = await memories.create(
      petId: petId,
      occurredAt: DateTime(2026, 7, 3),
      note: '',
      media: photos,
    );

    expect(entry.media, hasLength(11));
    expect(
      entry.media.map((item) => item.platformRef),
      List.generate(11, (index) => 'photo-$index'),
    );
  });

  test(
    'allows one video but rejects mixed media and duplicate references',
    () async {
      final video = _asset('video-1', AlbumAssetKind.video);
      final entry = await memories.create(
        petId: petId,
        occurredAt: DateTime(2026, 7, 3),
        note: '',
        media: [video],
      );
      expect(entry.media.single.kind, AlbumAssetKind.video);

      expect(
        () => memories.create(
          petId: petId,
          occurredAt: DateTime(2026, 7, 3),
          note: '混合',
          media: [
            _asset('photo-1', AlbumAssetKind.image),
            _asset('video-2', AlbumAssetKind.video),
          ],
        ),
        throwsFormatException,
      );
      expect(
        () => memories.create(
          petId: petId,
          occurredAt: DateTime(2026, 7, 3),
          note: '重复',
          media: [
            _asset('photo-1', AlbumAssetKind.image),
            _asset('photo-1', AlbumAssetKind.image),
          ],
        ),
        throwsFormatException,
      );
    },
  );

  test('validates optional mood as one complete emoji grapheme', () {
    for (final emoji in ['😊', '👍🏽', '🇨🇳', '❤️', '👨‍👩‍👧‍👦']) {
      expect(isValidMoodEmoji(emoji), isTrue, reason: emoji);
    }
    for (final invalid in ['', 'A', '开心', '😊🥰', 'ordinary text']) {
      expect(isValidMoodEmoji(invalid), isFalse, reason: invalid);
    }
  });

  test('updates and clears mood without losing the entry', () async {
    final created = await memories.create(
      petId: petId,
      occurredAt: DateTime(2026, 7, 4),
      note: '午睡',
      moodEmoji: '😴',
      media: const [],
    );
    final updated = await memories.update(
      created.id,
      occurredAt: created.occurredAt,
      note: '睡醒了',
      moodEmoji: null,
      media: const [],
    );

    expect(updated.note, '睡醒了');
    expect(updated.moodEmoji, isNull);
  });

  test(
    'releases a shared platform reference only after its last use',
    () async {
      final shared = _asset('shared-photo', AlbumAssetKind.image);
      final first = await memories.create(
        petId: petId,
        occurredAt: DateTime(2026, 7, 4),
        note: '第一篇',
        media: [shared],
      );
      final second = await memories.create(
        petId: petId,
        occurredAt: DateTime(2026, 7, 5),
        note: '第二篇',
        media: [shared],
      );

      await memories.delete(first.id);
      expect(assets.released, isEmpty);
      await memories.delete(second.id);
      expect(assets.released, ['shared-photo']);
    },
  );

  test('deleting a pet cascades memories and releases album grants', () async {
    await memories.create(
      petId: petId,
      occurredAt: DateTime(2026, 7, 6),
      note: '要保留文字直到删除狗狗',
      media: [_asset('pet-photo', AlbumAssetKind.image)],
    );

    expect(await pets.delete(petId), isTrue);
    expect(await memories.findForPet(petId), isEmpty);
    expect(assets.released, ['pet-photo']);
  });

  test('requires at least text or media', () {
    expect(
      () => memories.create(
        petId: petId,
        occurredAt: DateTime.now(),
        note: '',
        media: const [],
      ),
      throwsFormatException,
    );
  });
}

AlbumAssetReference _asset(String reference, AlbumAssetKind kind) {
  return AlbumAssetReference(
    platformRef: reference,
    kind: kind,
    width: 1200,
    height: 900,
    durationMs: kind == AlbumAssetKind.video ? 90000 : null,
  );
}

class _FakeAlbumAssetService implements AlbumAssetService {
  final released = <String>[];

  @override
  bool get isSupported => true;

  @override
  Future<int> cacheUsageBytes() async => 0;

  @override
  Future<void> clearCache() async {}

  @override
  Future<bool> checkAvailability(String platformRef) async => true;

  @override
  Future<String?> openAsset(String platformRef) async => platformRef;

  @override
  Future<List<AlbumAssetReference>> pickImages() async => const [];

  @override
  Future<AlbumAssetReference?> pickVideo() async => null;

  @override
  Future<void> releaseReference(String platformRef) async {
    released.add(platformRef);
  }

  @override
  Future<Uint8List?> requestPreview(
    String platformRef, {
    int size = 2048,
  }) async {
    return null;
  }

  @override
  Future<Uint8List?> requestThumbnail(
    String platformRef, {
    int size = 512,
  }) async {
    return null;
  }
}
