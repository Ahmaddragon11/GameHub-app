import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/tic_tac_toe_controller.dart';
import '../models/game_mode.dart';
import '../models/game_state.dart';
import '../models/player.dart';

class TicTacToeView extends GetView<TicTacToeController> {
  const TicTacToeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.resetGame,
          ),
        ],
      ),
      body: Obx(
        () {
          if (controller.gameState.value == GameState.modeSelection) {
            return _buildModeSelection(context);
          } else {
            return _buildGameBoard(context);
          }
        },
      ),
    );
  }

  Widget _buildModeSelection(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'اختر وضع اللعب',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () => controller.startGame(GameMode.twoPlayer),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            child: const Text('لاعب ضد لاعب'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => controller.startGame(GameMode.vsAI),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            child: const Text('لاعب ضد الكمبيوتر'),
          ),
        ],
      ),
    );
  }

  Widget _buildGameBoard(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _getStatusText(),
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
        ),
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            margin: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: GridView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                final row = index ~/ 3;
                final col = index % 3;
                final player = controller.board[row][col].value;
                return GestureDetector(
                  onTap: () => controller.makeMove(row, col),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: Center(
                      child: Text(
                        player == Player.X ? 'X' : (player == Player.O ? 'O' : ''),
                        style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: player == Player.X ? Colors.blue : Colors.red,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        if (controller.gameState.value == GameState.gameOver)
          ElevatedButton(
            onPressed: controller.resetGame,
            child: const Text('إعادة اللعب'),
          ),
      ],
    );
  }

  String _getStatusText() {
    switch (controller.gameState.value) {
      case GameState.playing:
        return 'دور اللاعب: ${controller.currentPlayer.value == Player.X ? 'X' : 'O'}';
      case GameState.gameOver:
        if (controller.winner.value != null) {
          return 'اللاعب ${controller.winner.value == Player.X ? 'X' : 'O'} فاز!';
        } else {
          return 'تعادل!';
        }
      case GameState.paused:
        return 'متوقف مؤقتًا';
      case GameState.idle:
      case GameState.modeSelection:
        return '';
    }
  }
}
