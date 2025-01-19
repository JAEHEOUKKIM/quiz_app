import 'package:flutter/material.dart';
import 'dart:async';
import '../models/quiz_question.dart';
import '../models/quiz_state.dart';
import '../models/quiz_language.dart';
import '../services/quiz_service.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final QuizLanguage language;

  const QuizScreen({
    super.key,
    required this.language,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  QuizState quizState = QuizState(
    questions: [],
    currentQuestionIndex: 0,
    score: 0,
    remainingTime: const Duration(seconds: 30),
    status: QuizStatus.loading,
  );
  Timer? timer;
  final int totalTime = 30;
  bool isTranslated = false;
  bool isLoading = false;
  final QuizService quizService = QuizService();
  
 

  Future<void> _initQuiz() async {
    try {
      final questions = await quizService.fetchQuestions(widget.language);
      if (mounted) {
        setState(() {
          quizState = QuizState(
            questions: questions,
            currentQuestionIndex: 0,
            score: 0,
            remainingTime: Duration(seconds: totalTime),
            status: QuizStatus.inProgress,
          );
        });
        _startTimer();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          quizState = quizState.copyWith(
            status: QuizStatus.error,
            errorMessage: '퀴즈를 불러오는데 실패했습니다.',
          );
        });
      }
    }
  }

  void _startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (quizState.remainingTime.inSeconds > 0) {
            quizState = quizState.copyWith(
              remainingTime: Duration(
                seconds: quizState.remainingTime.inSeconds - 1,
              ),
            );
          } else {
            _moveToNextQuestion();
          }
        });
      }
    });
  }

  void _moveToNextQuestion() {
    if (quizState.isLastQuestion) {
      _finishQuiz();
    } else {
      setState(() {
        quizState = quizState.copyWith(
          currentQuestionIndex: quizState.currentQuestionIndex + 1,
          remainingTime: Duration(seconds: totalTime),
        );
        isTranslated = false;  // 다음 문제로 넘어갈 때 항상 영어 상태로 설정
        isLoading = false;    // 로딩 상태 초기화
      });
    }
  }

  void _checkAnswer(int selectedIndex) {
    final currentQuestion = quizState.currentQuestion;
    final isCorrect = selectedIndex == currentQuestion.correctAnswerIndex;
    
    setState(() {
      if (isCorrect) {
        // 각 문제당 10점씩 부여 (10문제 * 10점 = 100점 만점)
        quizState = quizState.copyWith(
          score: quizState.score + 10,  // 1점에서 10점으로 변경
        );
      }
      
      timer?.cancel();
      _moveToNextQuestion();
    });
  }

  void _finishQuiz() {
    timer?.cancel();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          score: quizState.score,
          totalQuestions: quizState.questions.length,
          questions: quizState.questions,
        ),
      ),
    );
  }

  void _toggleTranslation() async {
    if (isLoading) return;

    try {
      setState(() {
        isLoading = true;
      });

      if (!isTranslated) {
        if (quizState.currentQuestion.translatedQuestion == null) {
          final translation = await quizService.translateQuestion(
            quizState.currentQuestion.question,
            quizState.currentQuestion.options,
          );

          if (mounted) {
            setState(() {
              final currentQuestions = [...quizState.questions];
              currentQuestions[quizState.currentQuestionIndex] = 
                  currentQuestions[quizState.currentQuestionIndex].copyWith(
                    translatedQuestion: translation.first,
                    translatedOptions: translation.second,
                  );
              
              quizState = quizState.copyWith(
                questions: currentQuestions,
              );
            });
          }
        }
      }

      if (mounted) {
        setState(() {
          isTranslated = !isTranslated;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('번역 중 오류가 발생했습니다.')),
        );
      }
    }
  }

  Widget _buildProgressBar() {
    return Column(
      children: [
        LinearProgressIndicator(
          value: (quizState.currentQuestionIndex + 1) / quizState.questions.length,
        ),
        const SizedBox(height: 10),
        Text(
          '문제 ${quizState.currentQuestionIndex + 1}/${quizState.questions.length}',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

Widget _buildTranslateButton() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: ElevatedButton.icon(
      onPressed: isLoading ? null : _toggleTranslation,
      icon: isLoading 
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Icon(isTranslated ? Icons.language : Icons.translate),
      label: Text(
        isLoading 
            ? '번역 중...' 
            : (isTranslated ? '영어로 보기' : '한글로 보기')
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isTranslated ? Colors.grey : Colors.blue,
        disabledBackgroundColor: Colors.blue.withOpacity(0.6),
      ),
    ),
  );
}

  @override
  void initState() {
    super.initState();
    isTranslated = false;
    _initQuiz();
  }

  Widget _buildQuestionCard() {
    final currentQuestion = quizState.currentQuestion;
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              isTranslated && currentQuestion.translatedQuestion != null
                  ? currentQuestion.translatedQuestion!
                  : currentQuestion.question,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (!isTranslated && widget.language == QuizLanguage.english)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  '* 번역 버튼을 눌러 한글로 볼 수 있습니다',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerOptions() {
    final currentQuestion = quizState.currentQuestion;
    final options = isTranslated && currentQuestion.translatedOptions != null
        ? currentQuestion.translatedOptions!
        : currentQuestion.options;

    return Expanded(
      child: ListView.builder(
        itemCount: options.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                textStyle: const TextStyle(fontSize: 18),
              ),
              onPressed: () => _checkAnswer(index),
              child: Text(options[index]),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (quizState.status == QuizStatus.loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (quizState.status == QuizStatus.error) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(quizState.errorMessage ?? '오류가 발생했습니다.'),
              ElevatedButton(
                onPressed: _initQuiz,
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('퀴즈'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                '${quizState.remainingTime.inSeconds}초',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildProgressBar(),
              if (widget.language == QuizLanguage.english)
                _buildTranslateButton(),
              _buildQuestionCard(),
              const SizedBox(height: 20),
              _buildAnswerOptions(),
            ],
          ),
        ),
      ),
    );
  }
}