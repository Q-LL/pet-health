import 'image_file_picker_stub.dart'
    if (dart.library.io) 'image_file_picker_io.dart'
    if (dart.library.js_interop) 'image_file_picker_web.dart'
    as platform;
import 'image_file_picker_types.dart';

export 'image_file_picker_types.dart';

Future<PickedImageFile?> pickPetPhotoFile() => platform.pickPetPhotoFile();

Future<bool> recoverLostPetPhotoSelection() =>
    platform.recoverLostPetPhotoSelection();
