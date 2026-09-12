import 'dart:typed_data';

enum AlbumAssetKind { image, video }

class AlbumAssetReference {
  const AlbumAssetReference({
    required this.platformRef,
    required this.kind,
    this.width,
    this.height,
    this.durationMs,
    this.capturedAt,
  });

  final String platformRef;
  final AlbumAssetKind kind;
  final int? width;
  final int? height;
  final int? durationMs;
  final DateTime? capturedAt;
}

abstract interface class AlbumAssetService {
  bool get isSupported;

  Future<List<AlbumAssetReference>> pickImages();

  Future<AlbumAssetReference?> pickVideo();

  Future<Uint8List?> requestThumbnail(String platformRef, {int size = 512});

  Future<Uint8List?> requestPreview(String platformRef, {int size = 2048});

  Future<String?> openAsset(String platformRef);

  Future<bool> checkAvailability(String platformRef);

  Future<void> releaseReference(String platformRef);

  Future<int> cacheUsageBytes();

  Future<void> clearCache();
}
