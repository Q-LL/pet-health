import 'dart:io';
import 'dart:typed_data';

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

Future<PickedImageFile?> pickPetPhotoFile() async {
  if (Platform.isIOS || Platform.isAndroid) {
    return _pickNativeGalleryPhoto();
  }

  return _pickDesktopPhotoFile();
}

Future<PickedImageFile?> _pickNativeGalleryPhoto() async {
  final file = await ImagePicker().pickImage(
    source: ImageSource.gallery,
    requestFullMetadata: false,
  );
  if (file == null) return null;

  final bytes = await file.readAsBytes();
  return _cropPickedImage(
    sourcePath: file.path,
    originalBytes: bytes,
    name: file.name,
    mediaType: file.mimeType ?? mediaTypeForImageName(file.name),
  );
}

Future<PickedImageFile?> _pickDesktopPhotoFile() async {
  final file = await openFile(acceptedTypeGroups: [_petPhotoTypes]);
  if (file == null) return null;
  final bytes = await file.readAsBytes();
  final mediaType = file.mimeType ?? mediaTypeForImageName(file.name);

  final tempDir = await getTemporaryDirectory();
  final extension = file.name.split('.').last;
  final tempPath =
      '${tempDir.path}/pet_photo_pick.${DateTime.now().millisecondsSinceEpoch}.$extension';
  final tempFile = File(tempPath);
  await tempFile.writeAsBytes(bytes);

  try {
    return await _cropPickedImage(
      sourcePath: tempPath,
      originalBytes: bytes,
      name: file.name,
      mediaType: mediaType,
    );
  } finally {
    try {
      await tempFile.delete();
    } catch (_) {}
  }
}

Future<PickedImageFile> _cropPickedImage({
  required String sourcePath,
  required List<int> originalBytes,
  required String name,
  required String mediaType,
}) async {
  final croppedFile = await ImageCropper().cropImage(
    sourcePath: sourcePath,
    aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
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

  if (croppedFile == null) {
    return PickedImageFile(
      bytes: Uint8List.fromList(originalBytes),
      name: name,
      mediaType: mediaType,
    );
  }

  final croppedBytes = await croppedFile.readAsBytes();
  return PickedImageFile(
    bytes: croppedBytes,
    name: name,
    mediaType: 'image/jpeg',
  );
}
