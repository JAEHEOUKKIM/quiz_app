import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/quiz_question.dart';
import '../models/quiz_language.dart';
import '../models/pair.dart';
import 'translation_service.dart';

class QuizService {
  final TranslationService _translationService = TranslationService();
  
  // 영어 퀴즈 API URL
  static const String englishBaseUrl = 'https://opentdb.com/api.php';
  
  // 네이버 API 설정
  static const String naverBaseUrl = 'https://openapi.naver.com/v1/search/kin.json';
  static const String clientId = 'dI6_phWubGSHx27nFYbs';     // 네이버 개발자 센터에서 발급받은 클라이언트 ID
  static const String clientSecret = '60muuATwvh'; // 네이버 개발자 센터에서 발급받은 클라이언트 시크릿

  final Random _random = Random();

  Future<List<QuizQuestion>> fetchQuestions(QuizLanguage language) async {
    try {
      if (language == QuizLanguage.korean) {
        return _getKoreanQuestions();
      } else {
        return _getEnglishQuestions();
      }
    } catch (e) {
      throw Exception('Error fetching questions: $e');
    }
  }

  Future<List<QuizQuestion>> _getKoreanQuestions() async {
    try {
      // 기본 한국어 퀴즈 반환 (API 연동이 안될 경우를 대비)
      return [
      QuizQuestion(
        id: '1',
        question: '대한민국의 수도는?',
        options: ['서울', '부산', '인천', '대전'],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: '2',
        question: '태극기의 가운데 원은 무엇을 상징하는가?',
        options: ['음양', '우주', '평화', '통일'],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: '3',
        question: '한글을 창제한 조선의 왕은?',
        options: ['세종대왕', '태종', '정조', '영조'],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: '4',
        question: '우리나라에서 가장 큰 섬은?',
        options: ['제주도', '거제도', '울릉도', '강화도'],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: '5',
        question: '한국의 전통 무예는?',
        options: ['태권도', '가라테', '유도', '쿵푸'],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: '6',
        question: '삼국시대를 구성하는 나라가 아닌 것은?',
        options: ['부여', '고구려', '백제', '신라'],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: '7',
        question: '한국의 국화는?',
        options: ['무궁화', '개나리', '진달래', '장미'],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: '8',
        question: '한국의 전통 악기가 아닌 것은?',
        options: ['피아노', '장구', '가야금', '대금'],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: '9',
        question: '김치의 주재료는?',
        options: ['배추', '상추', '양배추', '청경채'],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: '10',
        question: '한국의 첫 번째 수도는?',
        options: ['개성', '서울', '경주', '부여'],
        correctAnswerIndex: 0,
      ),
      ];
    } catch (e) {
      print('Error fetching Korean questions: $e');
      // 에러 발생 시에도 기본 퀴즈 반환
      return _getDefaultKoreanQuestions();
    }
  }

  String _extractAnswer(String description) {
    // "정답:" 또는 "답:" 다음에 오는 텍스트를 추출
    final RegExp answerRegExp = RegExp(r'(?:정답|답)[:：]\s*([^\n.,]+)');
    final match = answerRegExp.firstMatch(description);
    if (match != null) {
      return match.group(1)?.trim() ?? '';
    }
    return '';
  }

  List<String> _generateWrongAnswers(String correctAnswer) {
    // 기본 오답 풀
    final List<String> defaultWrongAnswers = [
      '알 수 없음',
      '해당 없음',
      '기타',
    ];
    
    // 정답의 길이와 유형에 따라 비슷한 오답 생성
    List<String> wrongAnswers = [];
    while (wrongAnswers.length < 3) {
      String wrongAnswer = defaultWrongAnswers[wrongAnswers.length];
      if (!wrongAnswers.contains(wrongAnswer) && wrongAnswer != correctAnswer) {
        wrongAnswers.add(wrongAnswer);
      }
    }
    
    return wrongAnswers;
  }

  List<QuizQuestion> _getDefaultKoreanQuestions() {
    return [
      QuizQuestion(
        id: '1',
        question: '대한민국의 수도는?',
        options: ['서울', '부산', '인천', '대전'],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: '2',
        question: '태극기의 가운데 원은 무엇을 상징하는가?',
        options: ['음양', '우주', '평화', '통일'],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: '3',
        question: '한글을 창제한 조선의 왕은?',
        options: ['세종대왕', '태종', '정조', '영조'],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: '4',
        question: '우리나라에서 가장 큰 섬은?',
        options: ['제주도', '거제도', '울릉도', '강화도'],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: '5',
        question: '한국의 전통 무예는?',
        options: ['태권도', '가라테', '유도', '쿵푸'],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: '6',
        question: '삼국시대를 구성하는 나라가 아닌 것은?',
        options: ['부여', '고구려', '백제', '신라'],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: '7',
        question: '한국의 국화는?',
        options: ['무궁화', '개나리', '진달래', '장미'],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: '8',
        question: '한국의 전통 악기가 아닌 것은?',
        options: ['피아노', '장구', '가야금', '대금'],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: '9',
        question: '김치의 주재료는?',
        options: ['배추', '상추', '양배추', '청경채'],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: '10',
        question: '한국의 첫 번째 수도는?',
        options: ['개성', '서울', '경주', '부여'],
        correctAnswerIndex: 0,
      ),   // ... 더 많은 기본 퀴즈 추가
    ];
  }

  Future<List<QuizQuestion>> _getEnglishQuestions() async {
    final response = await http.get(
      Uri.parse('$englishBaseUrl?amount=10&type=multiple'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List).map((questionData) {
        List<String> allAnswers = [
          ...List<String>.from(questionData['incorrect_answers']),
          questionData['correct_answer'],
        ]..shuffle(_random);
        
        return QuizQuestion(
          id: DateTime.now().toString(),
          question: questionData['question'],
          options: allAnswers,
          correctAnswerIndex: allAnswers.indexOf(questionData['correct_answer']),
        );
      }).toList();
    } else {
      throw Exception('Failed to load English questions');
    }
  }

  Future<Pair<String, List<String>>> translateQuestion(
    String question,
    List<String> options,
  ) async {
    try {
      // TranslationService를 사용하여 번역 수행
      return await _translationService.translateToKorean(question, options);
    } catch (e) {
      print('Translation error: $e');
      // 번역 실패 시 기본 사전 기반 번역으로 폴백
      return _fallbackTranslation(question, options);
    }
  }

  // 번역 API 실패 시 사용할 기본 사전 기반 번역
  Pair<String, List<String>> _fallbackTranslation(
    String question,
    List<String> options,
  ) {
    // 기본 사전
    final Map<String, String> dictionary = {
      'What': '무엇',
      'Where': '어디',
      'When': '언제',
      'Who': '누구',
      'How': '어떻게',
      'is': '은/는',
      'the': '',
      'a': '',
      'an': '',
      // 더 많은 기본 단어 추가 가능
    };

    String translatedQuestion = question;
    List<String> translatedOptions = [...options];

    dictionary.forEach((eng, kor) {
      translatedQuestion = translatedQuestion.replaceAll(
        RegExp(eng, caseSensitive: false),
        kor,
      );
      translatedOptions = translatedOptions.map((option) {
        return option.replaceAll(
          RegExp(eng, caseSensitive: false),
          kor,
        );
      }).toList();
    });

    return Pair(translatedQuestion, translatedOptions);
  }
}