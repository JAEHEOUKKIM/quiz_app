class QuizResult {
  final int score;
  final int totalQuestions;
  final int correctAnswers;
  final Duration timeTaken;
  final DateTime dateTime;

  QuizResult({
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.timeTaken,
    required this.dateTime,
  });

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      score: json['score'] as int,
      totalQuestions: json['totalQuestions'] as int,
      correctAnswers: json['correctAnswers'] as int,
      timeTaken: Duration(seconds: json['timeTaken'] as int),
      dateTime: DateTime.parse(json['dateTime'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'timeTaken': timeTaken.inSeconds,
      'dateTime': dateTime.toIso8601String(),
    };
  }
}