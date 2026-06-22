import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

import 'photo_storage_types.dart';

LocalPhotoStorage createLocalPhotoStorage() => _IoPhotoStorage();

class _IoPhotoStorage implements LocalPhotoStorage {
  @override
  Future<StoredPhotoPayload> save({
    required String petId,
    required String photoId,
    required String originalName,
    required Uint8List bytes,
  }) async {
    final root = await getApplicationDocumentsDirectory();
    final directory = Directory('${root.path}/pet_photos/$petId');
    await directory.create(recursive: true);
    final extension = _safeExtension(originalName);
    final file = File('${directory.path}/$photoId.$extension');
    await file.writeAsBytes(bytes, flush: true);
    return StoredPhotoPayload(filePath: file.path);
  }

  @override
  Future<Uint8List> read({String? filePath, Uint8List? bytes}) async {
    if (filePath == null) throw StateError('照片文件路径不存在');
    return File(filePath).readAsBytes();
  }

  @override
  Future<void> delete(String? filePath) async {
    if (filePath == null) return;
    final file = File(filePath);
    if (await file.exists()) await file.delete();
  }
}

String _safeExtension(String name) {
  final candidate = name.contains('.')
      ? name.split('.').last.toLowerCase()
      : '';
  const allowed = {'jpg', 'jpeg', 'png', 'webp', 'heic', 'heif'};
  return allowed.contains(candidate) ? candidate : 'jpg';
}
