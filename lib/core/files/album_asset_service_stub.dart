import 'dart:typed_data';

import 'album_asset_types.dart';

AlbumAssetService createAlbumAssetService() => _UnsupportedAlbumAssetService();

class _UnsupportedAlbumAssetService implements AlbumAssetService {
  @override
  bool get isSupported => false;

  @override
  Future<void> clearCache() async {}

  @override
  Future<int> cacheUsageBytes() async => 0;

  @override
  Future<bool> checkAvailability(String platformRef) async => false;

  @override
  Future<String?> openAsset(String platformRef) async => null;

  @override
  Future<List<AlbumAssetReference>> pickImages() async => const [];

  @override
  Future<AlbumAssetReference?> pickVideo() async => null;

  @override
  Future<void> releaseReference(String platformRef) async {}

  @override
  Future<Uint8List?> requestPreview(
    String platformRef, {
    int size = 2048,
  }) async => null;

  @override
  Future<Uint8List?> requestThumbnail(
    String platformRef, {
    int size = 512,
  }) async => null;
}
