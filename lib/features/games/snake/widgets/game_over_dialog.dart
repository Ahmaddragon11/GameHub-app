import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameOverDialog extends StatelessWidget {
  final int score;
  final int highScore;
  final bool isNewHighScore;
  final VoidCallback onReplay;
  final VoidCallback onExit;

  const GameOverDialog({
    super.key,
    required this.score,
    required this.highScore,
    required this.isNewHighScore,
    required this.onReplay,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.grey[850],
      title: const Center(
        child: Text(
          'انتهت اللعبة!',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isNewHighScore)
            const Text(
              '🎉 نتيجة قياسية جديدة! 🎉',
              style: TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          const SizedBox(height: 16),
          Text(
            'نتيجتك: $score',
            style: const TextStyle(color: Colors.white70, fontSize: 22),
          ),
          const SizedBox(height: 8),
          Text(
            'أعلى نتيجة: $highScore',
            style: const TextStyle(color: Colors.white70, fontSize: 18),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            onExit();
            Get.back(); // Close dialog
          },
          child: const Text('الخروج', style: TextStyle(color: Colors.white70)),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back(); // Close dialog
            onReplay();
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: const Text('إعادة اللعب'),
        ),
      ],
    );
  }
}
