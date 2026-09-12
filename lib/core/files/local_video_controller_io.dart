import 'dart:io';

import 'package:video_player/video_player.dart';

VideoPlayerController createLocalVideoController(String reference) {
  if (Platform.isAndroid && reference.startsWith('content://')) {
    return VideoPlayerController.contentUri(Uri.parse(reference));
  }
  return VideoPlayerController.file(File(reference));
}
