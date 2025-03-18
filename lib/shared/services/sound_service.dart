import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundService {
  final SharedPreferences _preferences;
  final AudioPlayer _sfxPlayer = AudioPlayer();
  final AudioPlayer _bgmPlayer = AudioPlayer();
  bool _isBackgroundPlaying = false;

  bool get playBgm => _preferences.getBool('playBgM') ?? true;
  double get bgmVolume => _bgmPlayer.volume;

  SoundService(this._preferences) {
    final volume = _preferences.getDouble('bgmVolume');
    if (volume != null) {
      _bgmPlayer.setVolume(volume);
    } else {
      _bgmPlayer.setVolume(0.3);
      _preferences.setDouble('bgmVolume', 0.3);
    }
  }

  Future<void> _playSound(
    String assetPath,
  ) async {
    await _sfxPlayer.play(AssetSource(assetPath));
  }

  Future<void> playCorrectSound() async {
    await _playSound('sounds/correct.wav');
  }

  Future<void> playWrongSound() async {
    await _playSound('sounds/wrong.wav');
  }

  Future<void> playClickSound() async {
    await _playSound('sounds/click.wav');
  }

  Future<void> playWinSound() async {
    await _playSound('sounds/win.wav');
  }

  Future<void> playLoseSound() async {
    await _playSound('sounds/lose.wav');
  }

  Future<void> playFlipSound() async {
    await _playSound('sounds/flip.wav');
  }

  Future<void> toggleBgPlayMode(bool playBgm) async {
    _preferences.setBool('playBgM', playBgm);
    if (playBgm) {
      await playBackgroundMusic();
    } else {
      await stopBackgroundMusic();
    }
  }

  Future<void> playBackgroundMusic() async {
    if (!_isBackgroundPlaying && _preferences.getBool('playBgM') == true) {
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgmPlayer.play(AssetSource('sounds/background.wav'));
      _isBackgroundPlaying = true;
    }
  }

  Future<void> stopBackgroundMusic() async {
    await _bgmPlayer.stop();
    _isBackgroundPlaying = false;
  }

  Future<void> pauseBackgroundMusic() async {
    if (_isBackgroundPlaying) {
      await _bgmPlayer.pause();
    }
  }

  Future<void> resumeBackgroundMusic() async {
    if (_isBackgroundPlaying) {
      await Future.delayed(const Duration(seconds: 1));
      await _bgmPlayer.resume();
    }
  }

  Future<void> setBackgroundMusicVolume(double volume) async {
    await _bgmPlayer.setVolume(volume);
    _preferences.setDouble('bgmVolume', volume);
  }
}
