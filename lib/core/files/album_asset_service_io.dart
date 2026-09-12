import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'album_asset_types.dart';

const _channel = MethodChannel('pet_health/album_assets');
const _maxCacheBytes = 100 * 1024 * 1024;

AlbumAssetService createAlbumAssetService() => _IoAlbumAssetService();

class _IoAlbumAssetService implements AlbumAssetService {
  @override
  bool get isSupported => Platform.isIOS || Platform.isAndroid;

  @override
  Future<List<AlbumAssetReference>> pickImages() async {
    if (!isSupported) return const [];
    final values = await _channel.invokeListMethod<Object?>('pickImages');
    return (values ?? const [])
        .whereType<Map<Object?, Object?>>()
        .map(_referenceFromMap)
        .toList(growable: false);
  }

  @override
  Future<AlbumAssetReference?> pickVideo() async {
    if (!isSupported) return null;
    final value = await _channel.invokeMapMethod<Object?, Object?>('pickVideo');
    return value == null ? null : _referenceFromMap(value);
  }

  @override
  Future<Uint8List?> requestThumbnail(
    String platformRef, {
    int size = 512,
  }) async {
    final cached = await _cachedFile(platformRef, size);
    if (await cached.exists()) {
      await cached.setLastModified(DateTime.now());
      return cached.readAsBytes();
    }
    final bytes = await _requestBytes('requestThumbnail', platformRef, size);
    if (bytes == null) return null;
    await cached.parent.create(recursive: true);
    await cached.writeAsBytes(bytes, flush: true);
    await _pruneCache();
    return bytes;
  }

  @override
  Future<Uint8List?> requestPreview(String platformRef, {int size = 2048}) {
    return _requestBytes('requestPreview', platformRef, size);
  }

  Future<Uint8List?> _requestBytes(
    String method,
    String platformRef,
    int size,
  ) async {
    if (!isSupported) return null;
    return _channel.invokeMethod<Uint8List>(method, {
      'ref': platformRef,
      'size': size,
    });
  }

  @override
  Future<String?> openAsset(String platformRef) async {
    if (!isSupported) return null;
    return _channel.invokeMethod<String>('openAsset', {'ref': platformRef});
  }

  @override
  Future<bool> checkAvailability(String platformRef) async {
    if (!isSupported) return false;
    return await _channel.invokeMethod<bool>('checkAvailability', {
          'ref': platformRef,
        }) ??
        false;
  }

  @override
  Future<void> releaseReference(String platformRef) async {
    if (!isSupported) return;
    await _channel.invokeMethod<void>('releaseReference', {'ref': platformRef});
  }

  @override
  Future<int> cacheUsageBytes() async {
    final directory = await _cacheDirectory();
    if (!await directory.exists()) return 0;
    var total = 0;
    await for (final entity in directory.list()) {
      if (entity is File) total += await entity.length();
    }
    return total;
  }

  @override
  Future<void> clearCache() async {
    final directory = await _cacheDirectory();
    if (await directory.exists()) await directory.delete(recursive: true);
  }

  Future<File> _cachedFile(String reference, int size) async {
    final bytes = utf8.encode('$reference@$size');
    var hash = 0xcbf29ce484222325;
    for (final byte in bytes) {
      hash ^= byte;
      hash = (hash * 0x100000001b3) & 0x7fffffffffffffff;
    }
    final directory = await _cacheDirectory();
    return File('${directory.path}/${hash.toRadixString(16)}.jpg');
  }

  Future<Directory> _cacheDirectory() async {
    final root = await getTemporaryDirectory();
    return Directory('${root.path}/memory_thumbnails');
  }

  Future<void> _pruneCache() async {
    final directory = await _cacheDirectory();
    if (!await directory.exists()) return;
    final files = <File>[];
    await for (final entity in directory.list()) {
      if (entity is File) files.add(entity);
    }
    var total = 0;
    final entries = <({File file, int bytes, DateTime modified})>[];
    for (final file in files) {
      final stat = await file.stat();
      total += stat.size;
      entries.add((file: file, bytes: stat.size, modified: stat.modified));
    }
    entries.sort((a, b) => a.modified.compareTo(b.modified));
    for (final entry in entries) {
      if (total <= _maxCacheBytes) break;
      await entry.file.delete();
      total -= entry.bytes;
    }
  }
}

AlbumAssetReference _referenceFromMap(Map<Object?, Object?> value) {
  final kindValue = value['kind'] as String?;
  final capturedAtMs = (value['capturedAt'] as num?)?.toInt();
  return AlbumAssetReference(
    platformRef: value['ref']! as String,
    kind: kindValue == 'video' ? AlbumAssetKind.video : AlbumAssetKind.image,
    width: (value['width'] as num?)?.toInt(),
    height: (value['height'] as num?)?.toInt(),
    durationMs: (value['durationMs'] as num?)?.toInt(),
    capturedAt: capturedAtMs == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(capturedAtMs, isUtc: true),
  );
}
