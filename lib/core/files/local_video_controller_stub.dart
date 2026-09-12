import 'package:video_player/video_player.dart';

VideoPlayerController createLocalVideoController(String reference) {
  return VideoPlayerController.networkUrl(Uri.parse(reference));
}
