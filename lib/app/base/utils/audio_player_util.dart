
import 'package:just_audio/just_audio.dart';

class AudioPlayerUtil{
  static AudioPlayer? _audioPlayer;
  static String? lastAudioUrl;

  static Future<void> stop() async{
    lastAudioUrl = null;
    await _audioPlayer?.stop();
    await _audioPlayer?.dispose();
    _audioPlayer = null;
  }

  static Future<void> play(String audioUrl) async{
    _audioPlayer ??= AudioPlayer();

    //await _audioPlayer?.setUrl(audioUrl)
    await _audioPlayer?.setAsset(audioUrl);
    lastAudioUrl = audioUrl;
    _audioPlayer?.play();
    _audioPlayer?.setLoopMode(LoopMode.off);
  }

  static Future<void> pause() async{
    await _audioPlayer?.pause();
  }

  static double? getVolume() {
    return _audioPlayer?.volume;
  }

  static void setVolume(double volume) {
    _audioPlayer?.setVolume(volume);
  }

  static bool isPlaying() {
    if (_audioPlayer != null) {
      return _audioPlayer!.playing;
    }
    return false;
  }
}