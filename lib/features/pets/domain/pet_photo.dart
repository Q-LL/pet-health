import 'package:flutter/foundation.dart';

const supportedPetPhotoMediaTypes = {
  'image/jpeg',
  'image/png',
  'image/webp',
  'image/heic',
  'image/heif',
};

@immutable
class PetPhoto {
  const PetPhoto({
    required this.id,
    required this.petId,
    required this.originalName,
    required this.mediaType,
    required this.isAvatar,
    required this.createdAt,
    required this.updatedAt,
    this.filePath,
    this.bytes,
    this.caption = '',
    this.capturedAt,
  });

  final String id;
  final String petId;
  final String? filePath;
  final Uint8List? bytes;
  final String originalName;
  final String mediaType;
  final String caption;
  final DateTime? capturedAt;
  final bool isAvatar;
  final DateTime createdAt;
  final DateTime updatedAt;
}
