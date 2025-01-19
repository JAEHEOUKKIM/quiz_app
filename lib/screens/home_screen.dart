import 'package:flutter/material.dart';
import '../models/quiz_language.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  QuizLanguage selectedLanguage = QuizLanguage.korean;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('퀴즈 게임'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '퀴즈 게임에 오신 것을 환영합니다!',
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              DropdownButton<QuizLanguage>(
                value: selectedLanguage,
                items: QuizLanguage.values.map((language) {
                  return DropdownMenuItem(
                    value: language,
                    child: Text(language.displayName),
                  );
                }).toList(),
                onChanged: (QuizLanguage? value) {
                  if (value != null) {
                    setState(() {
                      selectedLanguage = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => QuizScreen(
                        language: selectedLanguage,  // language 파라미터 전달
                      ),
                    ),
                  );
                },
                child: const Text(
                  '게임 시작',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}