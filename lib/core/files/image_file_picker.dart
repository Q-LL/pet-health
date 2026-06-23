import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';

const _petPhotoTypes = XTypeGroup(
  label: '狗狗照片',
  extensions: ['jpg', 'jpeg', 'png', 'webp', 'heic', 'heif'],
  mimeTypes: [
    'image/jpeg',
    'image/png',
    'image/webp',
    'image/heic',
    'image/heif',
  ],
);

class PickedImageFile {
  const PickedImageFile({
    required this.bytes,
    required this.name,
    required this.mediaType,
  });

  final Uint8List bytes;
  final String name;
  final String mediaType;
}

Future<PickedImageFile?> pickPetPhotoFile() async {
  final file = await openFile(acceptedTypeGroups: [_petPhotoTypes]);
  if (file == null) return null;
  final bytes = await file.readAsBytes();
  return PickedImageFile(
    bytes: bytes,
    name: file.name,
    mediaType: file.mimeType ?? _mediaTypeForName(file.name),
  );
}

String _mediaTypeForName(String name) {
  final extension = name.split('.').last.toLowerCase();
  return switch (extension) {
    'png' => 'image/png',
    'webp' => 'image/webp',
    'heic' => 'image/heic',
    'heif' => 'image/heif',
    _ => 'image/jpeg',
  };
}
