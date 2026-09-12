import 'album_asset_service_stub.dart'
    if (dart.library.io) 'album_asset_service_io.dart'
    as platform;
import 'album_asset_types.dart';

export 'album_asset_types.dart';

AlbumAssetService createAlbumAssetService() =>
    platform.createAlbumAssetService();
