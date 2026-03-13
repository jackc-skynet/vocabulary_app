class QuizQuestion {
  final String word;
  final String correctAnswer;
  final List<String> options;

  QuizQuestion({
    required this.word,
    required this.correctAnswer,
    required this.options,
  });
}

class QuizResult {
  final int score;
  final int total;
  final DateTime date;

  QuizResult({
    required this.score,
    required this.total,
    required this.date,
  });

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      score: json['score'],
      total: json['total'],
      date: DateTime.parse(json['timestamp']),
    );
  }
}
