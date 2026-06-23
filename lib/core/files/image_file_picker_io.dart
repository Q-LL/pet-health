import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';

import 'image_file_picker_types.dart';

const _petPhotoTypes = XTypeGroup(
  label: '狗狗照片',
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

  final croppedFile = await ImageCropper().cropImage(
    sourcePath: tempPath,
    aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 4),
    compressFormat: ImageCompressFormat.jpg,
    compressQuality: 90,
    uiSettings: [
      AndroidUiSettings(toolbarTitle: '裁剪照片', lockAspectRatio: true),
      IOSUiSettings(
        title: '裁剪照片',
        aspectRatioLockEnabled: true,
        resetAspectRatioEnabled: false,
      ),
    ],
  );

  try {
    await tempFile.delete();
  } catch (_) {}

  if (croppedFile == null) {
    return PickedImageFile(bytes: bytes, name: file.name, mediaType: mediaType);
  }

  final croppedBytes = await croppedFile.readAsBytes();
  return PickedImageFile(
    bytes: croppedBytes,
    name: file.name,
    mediaType: 'image/jpeg',
  );
}
