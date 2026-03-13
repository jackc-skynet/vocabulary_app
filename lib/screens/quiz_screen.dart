import 'package:flutter/material.dart';
import 'dart:math';
import '../models/quiz_model.dart';
import '../services/storage_service.dart';
import '../services/dictionary_api_service.dart';

class QuizScreen extends StatefulWidget {
  final bool isRandom;
  const QuizScreen({super.key, this.isRandom = false});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final StorageService _storageService = StorageService();
  final DictionaryApiService _apiService = DictionaryApiService();
  List<QuizQuestion> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isLoading = true;
  String? _error;
  bool _answered = false;
  int? _selectedIdx;

  @override
  void initState() {
    super.initState();
    _loadQuiz();
  }

  Future<void> _loadQuiz() async {
    try {
      List<Map<String, String>> sourceWords = [];

      if (widget.isRandom) {
        sourceWords = await _apiService.fetchRandomWordsForQuiz();
      } else {
        sourceWords = await _storageService.getWordHistory();
      }

      if (sourceWords.length < 4) {
        setState(() {
          _error = widget.isRandom 
            ? "Failed to fetch enough random words. Check your internet connection."
            : "You need to search at least 4 words to start a history quiz!";
          _isLoading = false;
        });
        return;
      }

      // Generate questions
      final List<QuizQuestion> generated = [];
      final random = Random();
      final numQuestions = min(10, sourceWords.length);
      
      // Shuffle source to get random words
      final shuffledSource = List<Map<String, String>>.from(sourceWords)..shuffle();

      for (int i = 0; i < numQuestions; i++) {
        final correctWord = shuffledSource[i]['word']!;
        final correctDef = shuffledSource[i]['definition']!;

        // For options, we can use words from the current source or the global history
        // To make it simpler, we'll use words from the current source first
        final otherOptions = sourceWords
            .where((w) => w['word'] != correctWord)
            .map((w) => w['definition']!)
            .toList();
        
        otherOptions.shuffle();
        
        final options = [correctDef];
        options.addAll(otherOptions.take(3));
        
        // If we still don't have 4 options (unlikely in random mode but possible), 
        // fallback to some placeholders or just take what we have
        while (options.length < 4) {
           options.add("Definition not available");
        }
        
        options.shuffle();

        generated.add(QuizQuestion(
          word: correctWord,
          correctAnswer: correctDef,
          options: options,
        ));
      }

      setState(() {
        _questions = generated;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = "Error loading quiz data: $e";
        _isLoading = false;
      });
    }
  }

  void _answer(int index) {
    if (_answered) return;
    setState(() {
      _selectedIdx = index;
      _answered = true;
      if (_questions[_currentQuestionIndex].options[index] == _questions[_currentQuestionIndex].correctAnswer) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _answered = false;
        _selectedIdx = null;
      });
    } else {
      _finishQuiz();
    }
  }

  Future<void> _finishQuiz() async {
    await _storageService.saveQuizResult(_score, _questions.length);
    if (!mounted) return;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Finished!'),
        content: Text('You scored $_score out of ${_questions.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Back to home
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(appBar: AppBar(title: const Text('Quiz')), body: const Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.info_outline, size: 64, color: Colors.orange),
                const SizedBox(height: 16),
                Text(_error!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 24),
                ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Go Back')),
              ],
            ),
          ),
        ),
      );
    }

    final question = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${_currentQuestionIndex + 1}/${_questions.length}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(value: (_currentQuestionIndex + 1) / _questions.length),
            const SizedBox(height: 32),
            Text(
              'What is the meaning of "${question.word}"?',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ...List.generate(question.options.length, (index) {
              final option = question.options[index];
              Color? color;
              if (_answered) {
                if (option == question.correctAnswer) {
                  color = Colors.green.shade100;
                } else if (_selectedIdx == index) {
                  color = Colors.red.shade100;
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: InkWell(
                  onTap: () => _answer(index),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: color,
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(option, style: const TextStyle(fontSize: 16)),
                  ),
                ),
              );
            }),
            const Spacer(),
            if (_answered)
              ElevatedButton(
                onPressed: _nextQuestion,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: Text(_currentQuestionIndex < _questions.length - 1 ? 'Next Question' : 'Show Result'),
              ),
          ],
        ),
      ),
    );
  }
}
