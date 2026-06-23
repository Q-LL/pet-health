import 'dart:typed_data';

import 'photo_storage_types.dart';

LocalPhotoStorage createLocalPhotoStorage() => _UnsupportedPhotoStorage();

class _UnsupportedPhotoStorage implements LocalPhotoStorage {
  @override
  Future<void> delete(String? filePath) async {}

  @override
  Future<Uint8List> read({String? filePath, Uint8List? bytes}) {
    throw UnsupportedError('当前平台不支持狗狗照片存储');
  }

  @override
  Future<StoredPhotoPayload> save({
    required String petId,
    required String photoId,
    required String originalName,
    required Uint8List bytes,
  }) {
    throw UnsupportedError('当前平台不支持狗狗照片存储');
  }
}
