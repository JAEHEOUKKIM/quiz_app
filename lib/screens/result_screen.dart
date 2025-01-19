import 'package:flutter/material.dart';
import '../models/quiz_question.dart';
import './home_screen.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final List<QuizQuestion> questions;

  const ResultScreen({
    Key? key,
    required this.score,
    required this.totalQuestions,
    required this.questions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final calculatedScore = (score / totalQuestions/10) * 100;

    return Scaffold(
      appBar: AppBar(
        title: const Text('퀴즈 결과'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // 상단 점수 표시 영역
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  '퀴즈 완료!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '점수: ${calculatedScore.toInt()} / 100',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // 정답 목록 영역
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 문제 번호
                        Text(
                          'Question ${index + 1}:',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        
                        // 문제 내용 (영어)
                        Text(
                          question.question,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        
                        // 문제 내용 (한글 번역)
                        if (question.translatedQuestion != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            question.translatedQuestion!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                        
                        const SizedBox(height: 12),
                        
                        // 정답 표시
                        const Text(
                          '정답:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 4),
                        
                        // 정답 (영어)
                        Text(
                          question.options[question.correctAnswerIndex],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                          ),
                        ),
                        
                        // 정답 (한글 번역)
                        if (question.translatedOptions != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            question.translatedOptions![question.correctAnswerIndex],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green[300],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // 하단 버튼
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (route) => false,
                );
              },
              child: const Text('처음으로 돌아가기'),
            ),
          ),
        ],
      ),
    );
  }
}