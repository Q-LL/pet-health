import 'package:file_selector/file_selector.dart';

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
  return PickedImageFile(
    bytes: await file.readAsBytes(),
    name: file.name,
    mediaType: file.mimeType ?? mediaTypeForImageName(file.name),
  );
}

Future<bool> recoverLostPetPhotoSelection() async => false;
