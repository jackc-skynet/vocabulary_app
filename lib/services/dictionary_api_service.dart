import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/word_model.dart';

class DictionaryApiService {
  static const String _baseUrl = 'https://api.dictionaryapi.dev/api/v2/entries/en/';

  Future<List<WordModel>> fetchWord(String word) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl$word'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => WordModel.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        // Word not found
        return [];
      } else {
        throw Exception('Failed to load word: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<Map<String, String>>> fetchRandomWordsForQuiz() async {
    try {
      // 1. Get 15 random words (request more than 10 because some might not have definitions in the dictionary api)
      final randomResponse = await http.get(Uri.parse('https://random-word-api.herokuapp.com/word?number=15'));
      if (randomResponse.statusCode != 200) throw Exception('Failed to fetch random words');
      
      final List<dynamic> randomWords = json.decode(randomResponse.body);
      final List<Map<String, String>> validWordsWithDefs = [];

      // 2. Fetch definitions for these words until we have enough for a quiz
      for (String word in randomWords) {
        if (validWordsWithDefs.length >= 10) break;

        final dictResponse = await http.get(Uri.parse('$_baseUrl$word'));
        if (dictResponse.statusCode == 200) {
          final List<dynamic> jsonList = json.decode(dictResponse.body);
          final wordModel = WordModel.fromJson(jsonList.first);
          if (wordModel.meanings.isNotEmpty && wordModel.meanings.first.definitions.isNotEmpty) {
            validWordsWithDefs.add({
              'word': wordModel.word,
              'definition': wordModel.meanings.first.definitions.first.definition,
            });
          }
        }
      }

      return validWordsWithDefs;
    } catch (e) {
      throw Exception('Failed to generate random quiz: $e');
    }
  }
}
