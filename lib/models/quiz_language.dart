enum QuizLanguage {
  korean('ko', '한국어'),
  english('en', 'English');

  final String code;
  final String displayName;
  
  const QuizLanguage(this.code, this.displayName);
} 