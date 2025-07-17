import 'package:flutter/material.dart';
import 'dart:math';
import '../models/question.dart';
import '../data/questions.dart';
import 'result_screen.dart';

class GameScreen extends StatefulWidget {
  final Difficulty difficulty;

  const GameScreen({super.key, required this.difficulty});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late List<Question> questions;
  int currentQuestionIndex = 0;
  int score = 0;
  int? selectedAnswer;
  bool isAnswered = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    questions = QuestionsData.getQuestionsByDifficulty(widget.difficulty);
    questions.shuffle(Random());

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectAnswer(int answerIndex) {
    if (isAnswered) return;

    setState(() {
      selectedAnswer = answerIndex;
      isAnswered = true;

      if (answerIndex == questions[currentQuestionIndex].correctAnswer) {
        score++;
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _nextQuestion();
      }
    });
  }

  void _nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null;
        isAnswered = false;
      });
      _animationController.reset();
      _animationController.forward();
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            score: score,
            totalQuestions: questions.length,
            difficulty: widget.difficulty,
          ),
        ),
      );
    }
  }

  String _getDifficultyText() {
    switch (widget.difficulty) {
      case Difficulty.easy:
        return 'آسان';
      case Difficulty.medium:
        return 'متوسط';
      case Difficulty.hard:
        return 'سخت';
    }
  }

  Color _getDifficultyColor() {
    switch (widget.difficulty) {
      case Difficulty.easy:
        return Colors.green;
      case Difficulty.medium:
        return Colors.orange;
      case Difficulty.hard:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestionIndex];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _getDifficultyColor().withOpacity(0.8),
              _getDifficultyColor().withOpacity(0.6),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // هدر
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'سطح: ${_getDifficultyText()}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      'امتیاز: $score',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // نوار پیشرفت
                LinearProgressIndicator(
                  value: (currentQuestionIndex + 1) / questions.length,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 8,
                ),

                const SizedBox(height: 20),

                // شماره سوال
                Text(
                  'سوال ${currentQuestionIndex + 1} از ${questions.length}',
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),

                const SizedBox(height: 30),

                // سوال
                Expanded(
                  child: FadeTransition(
                    opacity: _animation,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            question.question,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 30),

                          // گزینه‌ها
                          Expanded(
                            child: ListView.builder(
                              itemCount: question.options.length,
                              itemBuilder: (context, index) {
                                final isCorrect =
                                    index == question.correctAnswer;
                                final isSelected = selectedAnswer == index;

                                Color backgroundColor = Colors.grey[100]!;
                                Color borderColor = Colors.grey[300]!;

                                if (isAnswered) {
                                  if (isCorrect) {
                                    backgroundColor = Colors.green[50]!;
                                    borderColor = Colors.green;
                                  } else if (isSelected && !isCorrect) {
                                    backgroundColor = Colors.red[50]!;
                                    borderColor = Colors.red;
                                  }
                                } else if (isSelected) {
                                  backgroundColor = _getDifficultyColor()
                                      .withOpacity(0.1);
                                  borderColor = _getDifficultyColor();
                                }

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () => _selectAnswer(index),
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: backgroundColor,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: borderColor,
                                            width: 2,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 24,
                                              height: 24,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: isAnswered && isCorrect
                                                    ? Colors.green
                                                    : isSelected
                                                    ? _getDifficultyColor()
                                                    : Colors.grey[300],
                                              ),
                                              child: isAnswered && isCorrect
                                                  ? const Icon(
                                                      Icons.check,
                                                      color: Colors.white,
                                                      size: 16,
                                                    )
                                                  : isSelected && !isCorrect
                                                  ? const Icon(
                                                      Icons.close,
                                                      color: Colors.white,
                                                      size: 16,
                                                    )
                                                  : null,
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                question.options[index],
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: isAnswered && isCorrect
                                                      ? Colors.green[800]
                                                      : isSelected && !isCorrect
                                                      ? Colors.red[800]
                                                      : Colors.black87,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          // توضیح (در صورت پاسخ)
                          if (isAnswered) ...[
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.blue[200]!),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.lightbulb,
                                    color: Colors.blue[600],
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      question.explanation,
                                      style: TextStyle(
                                        color: Colors.blue[800],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
