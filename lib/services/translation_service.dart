import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pair.dart';

class TranslationService {
  // Google Cloud Console에서 발급받은 API 키를 입력하세요
  static const String apiKey = 'AIzaSyDh1VDwkFJgI78caGF64g39ophqwfK6Wzg';
  static const String baseUrl = 'https://translation.googleapis.com/language/translate/v2';

  Future<Pair<String, List<String>>> translateToKorean(
    String question,
    List<String> options,
  ) async {
    try {
      // 모든 텍스트를 하나의 요청으로 번역
      final response = await http.post(
        Uri.parse('$baseUrl?key=$apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'q': [question, ...options],
          'target': 'ko',
          'source': 'en',
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final translations = data['data']['translations'] as List;
        
        // 첫 번째는 질문, 나머지는 옵션들
        final translatedQuestion = translations[0]['translatedText'] as String;
        final translatedOptions = translations.sublist(1).map((t) => t['translatedText'] as String).toList();

        return Pair(translatedQuestion, translatedOptions);
      } else {
        print('Translation API error: ${response.body}');
        throw Exception('Translation failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Translation error: $e');
      throw Exception('번역 중 오류가 발생했습니다');
    }
  }

  // 디버그용 메서드
  void printTranslationResponse(String responseBody) {
    try {
      final data = json.decode(responseBody);
      print('Translation API Response: $data');
    } catch (e) {
      print('Error parsing response: $e');
    }
  }
} 