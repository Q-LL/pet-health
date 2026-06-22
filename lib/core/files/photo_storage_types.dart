import 'dart:typed_data';

class StoredPhotoPayload {
  const StoredPhotoPayload({this.filePath, this.bytes});

  final String? filePath;
  final Uint8List? bytes;
}

abstract interface class LocalPhotoStorage {
  Future<StoredPhotoPayload> save({
    required String petId,
    required String photoId,
    required String originalName,
    required Uint8List bytes,
  });

  Future<Uint8List> read({String? filePath, Uint8List? bytes});

  Future<void> delete(String? filePath);
}
