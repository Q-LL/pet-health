import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'image_file_picker_types.dart';

const _petPhotoTypes = XTypeGroup(
  label: '狗狗照片',
  uniformTypeIdentifiers: <String>['public.image'],
  extensions: <String>['jpg', 'jpeg', 'png', 'webp', 'heic', 'heif'],
  mimeTypes: <String>[
    'image/jpeg',
    'image/png',
    'image/webp',
    'image/heic',
    'image/heif',
  ],
);

XFile? _recoveredNativePhoto;

/// Recovers a gallery result when Android recreated MainActivity while the
/// system picker was in front. The file is consumed on the next avatar tap so
/// the regular crop and compression flow remains the single processing path.
Future<bool> recoverLostPetPhotoSelection() async {
  if (!Platform.isAndroid || _recoveredNativePhoto != null) {
    return _recoveredNativePhoto != null;
  }
  final response = await ImagePicker().retrieveLostData();
  if (response.isEmpty) return false;
  final exception = response.exception;
  if (exception != null) throw exception;
  final files = response.files;
  if (files == null || files.isEmpty) return false;
  _recoveredNativePhoto = files.first;
  return true;
}

Future<PickedImageFile?> pickPetPhotoFile() async {
  if (Platform.isIOS || Platform.isAndroid) {
    return _pickNativeGalleryPhoto();
  }

  return _pickDesktopPhotoFile();
}

Future<PickedImageFile?> _pickNativeGalleryPhoto() async {
  final recovered = _recoveredNativePhoto;
  _recoveredNativePhoto = null;
  final file =
      recovered ??
      await ImagePicker().pickImage(
        source: ImageSource.gallery,
        requestFullMetadata: false,
      );
  if (file == null) return null;

  return _cropPickedImage(sourcePath: file.path, name: file.name);
}

Future<PickedImageFile?> _pickDesktopPhotoFile() async {
  final file = await openFile(acceptedTypeGroups: [_petPhotoTypes]);
  if (file == null) return null;
  final bytes = await file.readAsBytes();

  final tempDir = await getTemporaryDirectory();
  final extension = file.name.split('.').last;
  final tempPath =
      '${tempDir.path}/pet_photo_pick.${DateTime.now().millisecondsSinceEpoch}.$extension';
  final tempFile = File(tempPath);
  await tempFile.writeAsBytes(bytes);

  try {
    return await _cropPickedImage(sourcePath: tempPath, name: file.name);
  } finally {
    try {
      await tempFile.delete();
    } catch (_) {}
  }
}

Future<PickedImageFile?> _cropPickedImage({
  required String sourcePath,
  required String name,
}) async {
  final croppedFile = await ImageCropper().cropImage(
    sourcePath: sourcePath,
    aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
    maxWidth: 1600,
    maxHeight: 1600,
    compressFormat: ImageCompressFormat.jpg,
    compressQuality: 90,
    uiSettings: [
      AndroidUiSettings(toolbarTitle: '裁剪头像', lockAspectRatio: true),
      IOSUiSettings(
        title: '裁剪头像',
        aspectRatioLockEnabled: true,
        resetAspectRatioEnabled: false,
      ),
    ],
  );

  if (croppedFile == null) return null;

  final croppedBytes = await croppedFile.readAsBytes();
  return PickedImageFile(
    bytes: croppedBytes,
    name: _croppedJpegName(name),
    mediaType: 'image/jpeg',
  );
}

String _croppedJpegName(String originalName) {
  final trimmed = originalName.trim();
  if (trimmed.isEmpty) return 'avatar.jpg';
  final dot = trimmed.lastIndexOf('.');
  final stem = dot > 0 ? trimmed.substring(0, dot) : trimmed;
  return '$stem.jpg';
}
