import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _wordHistoryKey = 'word_history';
  static const String _quizResultsKey = 'quiz_results';

  // Save a word to history (only if it doesn't already exist)
  Future<void> addWordToHistory(String word, String definition) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_wordHistoryKey) ?? [];
    
    // Check if word already exists in history
    bool exists = history.any((item) {
      final decoded = json.decode(item);
      return decoded['word'].toLowerCase() == word.toLowerCase();
    });

    if (!exists) {
      history.add(json.encode({
        'word': word,
        'definition': definition,
        'timestamp': DateTime.now().toIso8601String(),
      }));
      await prefs.setStringList(_wordHistoryKey, history);
    }
  }

  // Get all searched words
  Future<List<Map<String, String>>> getWordHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_wordHistoryKey) ?? [];
    return history.map((item) {
      final Map<String, dynamic> decoded = json.decode(item);
      return {
        'word': decoded['word'] as String,
        'definition': decoded['definition'] as String,
      };
    }).toList();
  }

  // Save quiz result
  Future<void> saveQuizResult(int score, int total) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> results = prefs.getStringList(_quizResultsKey) ?? [];
    
    results.add(json.encode({
      'score': score,
      'total': total,
      'timestamp': DateTime.now().toIso8601String(),
    }));
    
    await prefs.setStringList(_quizResultsKey, results);
  }

  // Get quiz results
  Future<List<Map<String, dynamic>>> getQuizResults() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> results = prefs.getStringList(_quizResultsKey) ?? [];
    return results.map((item) => json.decode(item) as Map<String, dynamic>).toList();
  }
}
