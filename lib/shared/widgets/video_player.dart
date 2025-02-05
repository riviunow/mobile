import 'package:flutter/material.dart';
import 'package:rvnow/shared/config/theme/colors.dart';
import 'package:video_player/video_player.dart' as video_player;

class VideoPlayer extends StatefulWidget {
  final String url;

  const VideoPlayer({super.key, required this.url});

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late video_player.VideoPlayerController _controller;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _controller =
        video_player.VideoPlayerController.networkUrl(Uri.parse(widget.url))
          ..initialize().then((_) {
            if (mounted) {
              setState(() {});
            }
          }).catchError((error) {
            setState(() {
              _isError = true;
            });
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isError) {
      return const Center(
        child: Icon(
          Icons.error,
          color: AppColors.error,
        ),
      );
    }

    return _controller.value.isInitialized
        ? Stack(
            alignment: Alignment.bottomCenter,
            children: [
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: video_player.VideoPlayer(_controller),
              ),
              video_player.VideoProgressIndicator(_controller,
                  allowScrubbing: true),
              _PlayPauseOverlay(controller: _controller),
            ],
          )
        : const Center(child: CircularProgressIndicator());
  }
}

class _PlayPauseOverlay extends StatelessWidget {
  const _PlayPauseOverlay({super.key, required this.controller});

  final video_player.VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.value.isPlaying ? controller.pause() : controller.play();
      },
      child: Stack(
        children: <Widget>[
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 50),
            reverseDuration: const Duration(milliseconds: 200),
            child: controller.value.isPlaying
                ? const SizedBox.shrink()
                : Container(
                    color: Colors.black26,
                    child: const Center(
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 100.0,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
