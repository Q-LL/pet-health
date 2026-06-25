import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

import 'photo_storage_types.dart';

LocalPhotoStorage createLocalPhotoStorage() => _IoPhotoStorage();

const _photoRootName = 'pet_photos';

class _IoPhotoStorage implements LocalPhotoStorage {
  @override
  Future<StoredPhotoPayload> save({
    required String petId,
    required String photoId,
    required String originalName,
    required Uint8List bytes,
  }) async {
    final root = await getApplicationDocumentsDirectory();
    final relativePath =
        '$_photoRootName/$petId/$photoId.'
        '${_safeExtension(originalName)}';
    final file = File('${root.path}/$relativePath');
    final directory = file.parent;
    await directory.create(recursive: true);
    await file.writeAsBytes(bytes, flush: true);
    return StoredPhotoPayload(filePath: relativePath);
  }

  @override
  Future<Uint8List> read({String? filePath, Uint8List? bytes}) async {
    if (filePath == null) throw StateError('照片文件路径不存在');
    final file = await _resolveStoredPhoto(filePath);
    return file.readAsBytes();
  }

  @override
  Future<void> delete(String? filePath) async {
    if (filePath == null) return;
    final file = await _resolveStoredPhoto(filePath);
    if (await file.exists()) await file.delete();
  }
}

Future<File> _resolveStoredPhoto(String storedPath) async {
  final directFile = File(storedPath);
  if (_isAbsolutePath(storedPath) && await directFile.exists()) {
    return directFile;
  }

  final portablePath = _portablePhotoPath(storedPath);
  if (portablePath == null) return directFile;

  final root = await getApplicationDocumentsDirectory();
  return File('${root.path}/$portablePath');
}

String? _portablePhotoPath(String storedPath) {
  final normalized = storedPath.replaceAll('\\', '/');
  final marker = '$_photoRootName/';
  final markerIndex = normalized.indexOf(marker);
  if (markerIndex >= 0) return normalized.substring(markerIndex);
  if (!_isAbsolutePath(normalized)) return normalized;
  return null;
}

bool _isAbsolutePath(String path) => path.startsWith('/');

String _safeExtension(String name) {
  final candidate = name.contains('.')
      ? name.split('.').last.toLowerCase()
      : '';
  const allowed = {'jpg', 'jpeg', 'png', 'webp', 'heic', 'heif'};
  return allowed.contains(candidate) ? candidate : 'jpg';
}
