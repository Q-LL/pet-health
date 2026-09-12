import 'local_video_controller_stub.dart'
    if (dart.library.io) 'local_video_controller_io.dart'
    as platform;
import 'package:video_player/video_player.dart';

VideoPlayerController createLocalVideoController(String reference) =>
    platform.createLocalVideoController(reference);
