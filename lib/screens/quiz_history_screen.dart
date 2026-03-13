import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../models/quiz_model.dart';
import 'package:intl/intl.dart';

class QuizHistoryScreen extends StatefulWidget {
  const QuizHistoryScreen({super.key});

  @override
  State<QuizHistoryScreen> createState() => _QuizHistoryScreenState();
}

class _QuizHistoryScreenState extends State<QuizHistoryScreen> {
  final StorageService _storageService = StorageService();
  List<QuizResult> _results = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final rawResults = await _storageService.getQuizResults();
    setState(() {
      _results = rawResults.map((r) => QuizResult.fromJson(r)).toList().reversed.toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz History')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _results.isEmpty
              ? const Center(child: Text('No quiz history yet. Take a quiz!'))
              : ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final result = _results[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: result.score >= (result.total / 2) ? Colors.green.shade100 : Colors.red.shade100,
                          child: Text('${result.score}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        title: Text('Score: ${result.score} / ${result.total}'),
                        subtitle: Text(DateFormat('yyyy-MM-dd HH:mm').format(result.date)),
                        trailing: Icon(
                          result.score == result.total ? Icons.star : Icons.chevron_right,
                          color: Colors.amber,
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
