import 'dart:typed_data';

import 'photo_storage_types.dart';

LocalPhotoStorage createLocalPhotoStorage() => _WebPhotoStorage();

class _WebPhotoStorage implements LocalPhotoStorage {
  @override
  Future<StoredPhotoPayload> save({
    required String petId,
    required String photoId,
    required String originalName,
    required Uint8List bytes,
  }) async {
    return StoredPhotoPayload(bytes: Uint8List.fromList(bytes));
  }

  @override
  Future<Uint8List> read({String? filePath, Uint8List? bytes}) async {
    if (bytes == null) throw StateError('浏览器本地照片数据不存在');
    return Uint8List.fromList(bytes);
  }

  @override
  Future<void> delete(String? filePath) async {}
}
