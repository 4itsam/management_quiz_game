
import 'package:flutter/material.dart';
import 'package:management_game/gen/assets.gen.dart';
import '../models/question.dart';
import 'game_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // لوگو و عنوان
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          Image.asset(Assets.images.shakhes.path, scale: 5),
                          const SizedBox(height: 16),
                          const Text(
                            'بازی مدیریت مالی',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "انجمن علمی مدیریت مالی شاخص\nدانشگاه سیستان و بلوچستان",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // انتخاب سطح دشواری
                    const Text(
                      'سطح دشواری را انتخاب کنید:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // دکمه‌های سطح دشواری
                    _buildDifficultyButton(
                      context,
                      'آسان',
                      'سوالات پایه مدیریت مالی',
                      Icons.sentiment_satisfied,
                      Colors.green,
                      Difficulty.easy,
                    ),

                    const SizedBox(height: 16),

                    _buildDifficultyButton(
                      context,
                      'متوسط',
                      'سوالات پیشرفته مدیریت مالی',
                      Icons.sentiment_neutral,
                      Colors.orange,
                      Difficulty.medium,
                    ),

                    const SizedBox(height: 16),

                    _buildDifficultyButton(
                      context,
                      'سخت',
                      'سوالات تخصصی مدیریت مالی',
                      Icons.sentiment_dissatisfied,
                      Colors.red,
                      Difficulty.hard,
                    ),

                    const SizedBox(height: 40),

                    // اطلاعات بازی
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _InfoItem(
                            icon: Icons.quiz,
                            title: '۱۵ سوال',
                            subtitle: 'در هر سطح',
                          ),
                          _InfoItem(
                            icon: Icons.timer,
                            title: 'بدون محدودیت',
                            subtitle: 'زمان',
                          ),
                          _InfoItem(
                            icon: Icons.emoji_events,
                            title: 'امتیازدهی',
                            subtitle: 'بر اساس صحت',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // دکمه اطلاعات سازنده
          Positioned(
            bottom: 16,
            left: 16,
            child: Builder(
              builder: (context) => Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 64,
                              height: 64,
                              child: SvgPicture.asset(
                                'assets/images/dakto.svg',
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'انجمن علمی مدیریت مالی',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text("توسعه: داکتو", style: TextStyle(fontSize: 15)),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('بستن'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Icon(Icons.code_rounded),
                    ),
                  ),
                ),
              ),
            ),

        ],
      ),
    );
  }

  Widget _buildDifficultyButton(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    Difficulty difficulty,
  ) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GameScreen(difficulty: difficulty),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.9),
          foregroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          shadowColor: color.withOpacity(0.3),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          subtitle,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}
