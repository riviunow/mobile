import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart' as audio_player;
import 'package:rvnow/shared/config/theme/colors.dart';
import 'package:rvnow/shared/constants/urls.dart';

class AudioPlayer extends StatefulWidget {
  final String url;

  AudioPlayer({super.key, required String url}) : url = "${Urls.mediaUrl}/$url";

  @override
  State<AudioPlayer> createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPlayer>
    with SingleTickerProviderStateMixin {
  late final audio_player.AudioPlayer _audioPlayer;
  late final AnimationController _animationController;
  bool _isPlaying = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = audio_player.AudioPlayer();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _isPlaying = state == audio_player.PlayerState.playing;
        if (_isPlaying) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      });
    });

    _audioPlayer.setSourceUrl(widget.url).catchError((error) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.release();
    _audioPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: AnimatedIcon(
            icon: AnimatedIcons.play_pause,
            progress: _animationController,
          ),
          onPressed: _hasError
              ? null
              : () {
                  if (_isPlaying) {
                    _audioPlayer.pause();
                  } else {
                    _audioPlayer.play(audio_player.UrlSource(widget.url));
                  }
                },
        ),
        if (_hasError)
          const Icon(
            Icons.error,
            color: AppColors.error,
          ),
      ],
    );
  }
}
