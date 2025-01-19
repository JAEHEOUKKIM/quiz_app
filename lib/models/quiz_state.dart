import 'quiz_question.dart';

enum QuizStatus {
  initial,
  loading,
  inProgress,
  paused,
  completed,
  error,
}

class QuizState {
  final List<QuizQuestion> questions;
  final int currentQuestionIndex;
  final int score;
  final Duration remainingTime;
  final QuizStatus status;
  final String? errorMessage;

  const QuizState({
    required this.questions,
    required this.currentQuestionIndex,
    required this.score,
    required this.remainingTime,
    required this.status,
    this.errorMessage,
  });

  QuizQuestion get currentQuestion => questions[currentQuestionIndex];
  bool get isLastQuestion => currentQuestionIndex == questions.length - 1;

  QuizState copyWith({
    List<QuizQuestion>? questions,
    int? currentQuestionIndex,
    int? score,
    Duration? remainingTime,
    QuizStatus? status,
    String? errorMessage,
  }) {
    return QuizState(
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      score: score ?? this.score,
      remainingTime: remainingTime ?? this.remainingTime,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
} 