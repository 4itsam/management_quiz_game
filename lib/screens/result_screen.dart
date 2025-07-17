import 'package:flutter/material.dart';
import '../models/question.dart';
import 'home_screen.dart';
import 'game_screen.dart';

class ResultScreen extends StatefulWidget {
  final int score;
  final int totalQuestions;
  final Difficulty difficulty;

  const ResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.difficulty,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scoreAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _scoreAnimation = Tween<double>(begin: 0, end: widget.score.toDouble())
        .animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );
    _progressAnimation =
        Tween<double>(
          begin: 0,
          end: widget.score / widget.totalQuestions,
        ).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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

  String _getResultMessage() {
    final percentage = (widget.score / widget.totalQuestions) * 100;
    if (percentage >= 80) {
      return 'عالی! شما در این سطح مهارت بالایی دارید';
    } else if (percentage >= 60) {
      return 'خوب! شما در این سطح عملکرد مناسبی داشتید';
    } else if (percentage >= 40) {
      return 'متوسط! نیاز به مطالعه بیشتر دارید';
    } else {
      return 'ضعیف! پیشنهاد می‌شود بیشتر مطالعه کنید';
    }
  }

  Color _getResultColor() {
    final percentage = (widget.score / widget.totalQuestions) * 100;
    if (percentage >= 80) {
      return Colors.green;
    } else if (percentage >= 60) {
      return Colors.orange;
    } else if (percentage >= 40) {
      return Colors.yellow[700]!;
    } else {
      return Colors.red;
    }
  }

  IconData _getResultIcon() {
    final percentage = (widget.score / widget.totalQuestions) * 100;
    if (percentage >= 80) {
      return Icons.emoji_events;
    } else if (percentage >= 60) {
      return Icons.thumb_up;
    } else if (percentage >= 40) {
      return Icons.school;
    } else {
      return Icons.sentiment_dissatisfied;
    }
  }

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // هدر
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'نتیجه آزمون',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
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
                  ],
                ),

                const SizedBox(height: 40),

                // کارت نتیجه
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // آیکون نتیجه
                        Icon(
                          _getResultIcon(),
                          size: 80,
                          color: _getResultColor(),
                        ),

                        const SizedBox(height: 24),

                        // پیام نتیجه
                        Text(
                          _getResultMessage(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: _getResultColor(),
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 32),

                        // امتیاز
                        AnimatedBuilder(
                          animation: _scoreAnimation,
                          builder: (context, child) {
                            return Text(
                              '${_scoreAnimation.value.toInt()}',
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: _getResultColor(),
                              ),
                            );
                          },
                        ),

                        Text(
                          'از ${widget.totalQuestions} سوال',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // نوار پیشرفت
                        AnimatedBuilder(
                          animation: _progressAnimation,
                          builder: (context, child) {
                            return Column(
                              children: [
                                LinearProgressIndicator(
                                  value: _progressAnimation.value,
                                  backgroundColor: Colors.grey[300],
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    _getResultColor(),
                                  ),
                                  minHeight: 12,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${(_progressAnimation.value * 100).toInt()}%',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: _getResultColor(),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),

                        const SizedBox(height: 40),

                        // آمار
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem(
                              'صحیح',
                              widget.score,
                              Colors.green,
                              Icons.check_circle,
                            ),
                            _buildStatItem(
                              'غلط',
                              widget.totalQuestions - widget.score,
                              Colors.red,
                              Icons.cancel,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // دکمه‌ها
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: _getDifficultyColor(),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 8,
                        ),
                        child: const Text(
                          'بازگشت به خانه',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  GameScreen(difficulty: widget.difficulty),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _getDifficultyColor(),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 8,
                        ),
                        child: const Text(
                          'تلاش مجدد',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, int value, Color color, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}
