import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameOverDialog extends StatefulWidget {
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
  State<GameOverDialog> createState() => _GameOverDialogState();
}

class _GameOverDialogState extends State<GameOverDialog> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );

    if (widget.isNewHighScore) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.grey[850]?.withOpacity(0.9),
      title: const Center(
        child: Text(
          'انتهت اللعبة!',
          style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.isNewHighScore)
            ScaleTransition(
              scale: _scaleAnimation,
              child: const Text(
                '🎉 نتيجة قياسية جديدة! 🎉',
                style: TextStyle(color: Colors.amber, fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          const SizedBox(height: 20),
          Text(
            'النتيجة: ${widget.score}',
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(height: 10),
          Text(
            'أعلى نتيجة: ${widget.highScore}',
            style: const TextStyle(color: Colors.white70, fontSize: 18),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () {
            widget.onExit();
            Get.back(); // Close the dialog
          },
          child: const Text('الخروج', style: TextStyle(color: Colors.white, fontSize: 16)),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () {
            Get.back(); // Close the dialog
            widget.onReplay();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          ),
          child: const Text('إعادة اللعب', style: TextStyle(fontSize: 16, color: Colors.white)),
        ),
      ],
    );
  }
}
