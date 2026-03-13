import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FlutterTts _flutterTts = FlutterTts();

  AudioService() {
    _initTts();
  }

  void _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  Future<void> playAudio(String? audioUrl, String fallbackWord) async {
    try {
      if (audioUrl != null && audioUrl.isNotEmpty) {
        // Play from URL
        await _audioPlayer.play(UrlSource(audioUrl));
      } else {
        // Fallback to TTS
        await speakWord(fallbackWord);
      }
    } catch (e) {
      debugPrint('Error playing audio from url: $e, falling back to TTS');
      await speakWord(fallbackWord);
    }
  }

  Future<void> speakWord(String word) async {
    await _flutterTts.speak(word);
  }

  void dispose() {
    _audioPlayer.dispose();
    _flutterTts.stop();
  }
}
