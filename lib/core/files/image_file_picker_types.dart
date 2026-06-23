import 'dart:typed_data';

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

String mediaTypeForImageName(String name) {
  final lower = name.toLowerCase();
  if (lower.endsWith('.png')) return 'image/png';
  if (lower.endsWith('.webp')) return 'image/webp';
  if (lower.endsWith('.heic')) return 'image/heic';
  if (lower.endsWith('.heif')) return 'image/heif';
  return 'image/jpeg';
}
