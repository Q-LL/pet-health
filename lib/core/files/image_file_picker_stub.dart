import 'image_file_picker_types.dart';

Future<PickedImageFile?> pickPetPhotoFile() {
  throw UnsupportedError('当前平台不支持选择图片');
}

Future<bool> recoverLostPetPhotoSelection() async => false;
