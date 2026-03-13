import 'package:flutter/material.dart';
import '../models/word_model.dart';
import '../services/audio_service.dart';

class WordDetailScreen extends StatefulWidget {
  final WordModel wordData;

  const WordDetailScreen({super.key, required this.wordData});

  @override
  State<WordDetailScreen> createState() => _WordDetailScreenState();
}

class _WordDetailScreenState extends State<WordDetailScreen> {
  final AudioService _audioService = AudioService();

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }

  void _playAudio() {
    String? audioUrl;
    // Find the first available audio url from phonetics
    for (var phonetic in widget.wordData.phonetics) {
      if (phonetic.audio != null && phonetic.audio!.isNotEmpty) {
        audioUrl = phonetic.audio;
        break;
      }
    }
    _audioService.playAudio(audioUrl, widget.wordData.word);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.wordData.word),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Word, Phonetic, and Audio Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.wordData.word,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (widget.wordData.phonetic != null)
                        Text(
                          widget.wordData.phonetic!,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.deepPurple.shade300,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.volume_up),
                  iconSize: 40,
                  color: Colors.deepPurple,
                  onPressed: _playAudio,
                  tooltip: 'Play pronunciation',
                ),
              ],
            ),
            const Divider(height: 32),
            // Meanings list
            ...widget.wordData.meanings.map((meaning) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Part of speech
                    Text(
                      meaning.partOfSpeech,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Definitions
                    ...meaning.definitions.map((def) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '• ${def.definition}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            if (def.example != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                                child: Text(
                                  '"${def.example}"',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
