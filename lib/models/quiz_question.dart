class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  String? translatedQuestion;
  List<String>? translatedOptions;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    this.translatedQuestion,
    this.translatedOptions,
  });

  // JSON 직렬화를 위한 팩토리 생성자
  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'] as String,
      question: json['question'] as String,
      options: List<String>.from(json['options']),
      correctAnswerIndex: json['correctAnswerIndex'] as int,
      translatedQuestion: json['translatedQuestion'] as String?,
      translatedOptions: json['translatedOptions'] != null 
          ? List<String>.from(json['translatedOptions'])
          : null,
    );
  }

  // JSON 변환을 위한 메서드
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'translatedQuestion': translatedQuestion,
      'translatedOptions': translatedOptions,
    };
  }

  // 복사본을 만드는 메서드
  QuizQuestion copyWith({
    String? id,
    String? question,
    List<String>? options,
    int? correctAnswerIndex,
    String? translatedQuestion,
    List<String>? translatedOptions,
  }) {
    return QuizQuestion(
      id: id ?? this.id,
      question: question ?? this.question,
      options: options ?? this.options,
      correctAnswerIndex: correctAnswerIndex ?? this.correctAnswerIndex,
      translatedQuestion: translatedQuestion ?? this.translatedQuestion,
      translatedOptions: translatedOptions ?? this.translatedOptions,
    );
  }
}