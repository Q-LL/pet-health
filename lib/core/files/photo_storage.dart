import 'photo_storage_stub.dart'
    if (dart.library.io) 'photo_storage_io.dart'
    if (dart.library.js_interop) 'photo_storage_web.dart'
    as platform;
import 'photo_storage_types.dart';

export 'photo_storage_types.dart';

LocalPhotoStorage createLocalPhotoStorage() =>
    platform.createLocalPhotoStorage();
