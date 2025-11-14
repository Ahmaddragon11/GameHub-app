import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../controllers/snake_controller.dart';
import '../models/direction.dart';
import '../models/game_state.dart';
import '../widgets/control_buttons.dart';
import '../widgets/game_board.dart';
import '../widgets/game_over_dialog.dart';

class SnakeView extends GetView<SnakeController> {
  const SnakeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Listener to show the GameOverDialog
    ever(controller.gameState, (GameState state) {
      if (state == GameState.gameOver) {
        Get.dialog(
          GameOverDialog(
            score: controller.score.value,
            highScore: controller.highScore.value,
            isNewHighScore: controller.score.value > controller.highScore.value,
            onReplay: () => controller.resetGame(),
            onExit: () => Get.back(), // Go back to home screen
          ),
          barrierDismissible: false,
        );
      }
    });

    return WillPopScope(
      onWillPop: () async {
        if (controller.gameState.value.isActive) {
          controller.pauseGame();
          final result = await Get.dialog<bool>(
            AlertDialog(
              title: const Text('الخروج من اللعبة'),
              content: const Text('هل أنت متأكد أنك تريد الخروج؟ ستفقد تقدمك الحالي.'),
              actions: [
                TextButton(onPressed: () => Get.back(result: false), child: const Text('البقاء')),
                TextButton(onPressed: () => Get.back(result: true), child: const Text('الخروج')),
              ],
            ),
          );
          if (result == false) {
            controller.resumeGame();
          }
          return result ?? false;
        } 
        return true;
      },
      child: Scaffold(
        backgroundColor: AppTheme.darkBackgroundColor,
        appBar: AppBar(
          title: const Text('لعبة الأفعى'),
          actions: [
            Obx(() => Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'النتيجة: ${controller.score.value}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                )),
            Obx(() => IconButton(
                  icon: Icon(controller.gameState.value == GameState.playing
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled),
                  onPressed: controller.gameState.value.canPause
                      ? () {
                          if (controller.gameState.value.isActive) {
                            controller.pauseGame();
                          } else {
                            controller.resumeGame();
                          }
                        }
                      : null,
                  tooltip: controller.gameState.value.isActive ? 'إيقاف مؤقت' : 'استئناف',
                )),
          ],
        ),
        body: GestureDetector(
          onVerticalDragUpdate: (details) {
            if (details.primaryDelta! < -2) {
              controller.changeDirection(Direction.up);
            } else if (details.primaryDelta! > 2) {
              controller.changeDirection(Direction.down);
            }
          },
          onHorizontalDragUpdate: (details) {
            if (details.primaryDelta! < -2) {
              controller.changeDirection(Direction.left);
            } else if (details.primaryDelta! > 2) {
              controller.changeDirection(Direction.right);
            }
          },
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildScoreBoard(),
                Obx(() => GameBoard(
                      snake: controller.snake,
                      food: controller.food.value,
                      gridSize: controller.gridSize,
                    )),
                _buildControls(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScoreBoard() {
    return Obx(() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _scoreTile('أعلى نتيجة', controller.highScore.value.toString(), Icons.star_border, Colors.amber),
              _scoreTile('السرعة', '${(220 - controller.speed.value) / 20 + 1}x', Icons.speed, Colors.lightBlueAccent),
            ],
          ),
        ));
  }

  Widget _scoreTile(String title, String value, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(color: Colors.white70, fontSize: 16)),
        const SizedBox(width: 8),
        Text(value, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildControls() {
    return Obx(() {
      final state = controller.gameState.value;
      if (state == GameState.idle || state == GameState.gameOver) {
        return ElevatedButton.icon(
          onPressed: () => controller.startGame(),
          icon: const Icon(Icons.play_arrow),
          label: Text(state == GameState.idle ? 'ابدأ اللعبة' : 'إعادة اللعب'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            textStyle: const TextStyle(fontSize: 20),
          ),
        );
      } else {
        return ControlButtons(
          enabled: controller.gameState.value.isActive,
          onDirectionChange: controller.changeDirection,
        );
      }
    });
  }
}
