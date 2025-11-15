import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/flappy_bird_controller.dart';
import '../models/game_state.dart'; // Import GameState
import '../widgets/game_canvas.dart';
import '../widgets/game_over_dialog.dart';

class FlappyBirdView extends GetView<FlappyBirdController> {
  const FlappyBirdView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: controller.jump,
        child: Obx(
          () => Stack(
            children: [
              GameCanvas(
                bird: controller.bird.value,
                pipes: controller.pipes,
                wingAnimation: controller.wingAnimation.value,
              ),
              // Score display
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Text(
                    'النقاط: ${controller.score.value}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 3.0,
                          color: Colors.black,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // High Score display
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 90.0),
                  child: Text(
                    'أعلى نقطة: ${controller.highScore.value}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                      shadows: [
                        Shadow(
                          blurRadius: 3.0,
                          color: Colors.black,
                          offset: Offset(1.0, 1.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Game state overlay (Tap to Play, Paused)
              if (controller.gameState.value == GameState.idle)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'اضغط للعب',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: controller.startGame,
                        child: const Text('ابدأ اللعبة'),
                      ),
                    ],
                  ),
                ),
              if (controller.gameState.value == GameState.paused)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'متوقف مؤقتًا',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: controller.resumeGame,
                        child: const Text('استئناف'),
                      ),
                    ],
                  ),
                ),
              // Game Over Dialog
              if (controller.gameState.value == GameState.gameOver)
                GameOverDialog(
                  score: controller.score.value,
                  highScore: controller.highScore.value,
                  isNewHighScore: controller.score.value > controller.highScore.value, // Determine if it's a new high score
                  onReplay: controller.startGame,
                  onExit: () => Get.back(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
