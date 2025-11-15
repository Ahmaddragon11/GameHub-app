import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import '../../../../core/services/database_service.dart';
import '../../../../core/services/storage_service.dart';
import '../models/direction.dart';
import '../models/game_state.dart';
import '../models/position.dart';

class SnakeController extends GetxController {
  // Game settings
  final int gridSize = 20;
  final _initialSpeed = 200;

  // Reactive state
  final snake = RxList<Position>();
  final food = const Position(0, 0).obs;
  final direction = Direction.right.obs;
  final nextDirection = Direction.right.obs;
  final gameState = GameState.idle.obs;
  final score = 0.obs;
  final highScore = 0.obs;
  final speed = 200.obs;

  // Services
  late final DatabaseService _databaseService;
  late final StorageService _storageService;
  Timer? _gameTimer;
  String? _userId;

  @override
  void onInit() {
    super.onInit();
    _databaseService = Get.find<DatabaseService>();
    _storageService = Get.find<StorageService>();
    _userId = _storageService.read<String>('user_id');
    _loadHighScore();
    resetGame();
  }

  void _loadHighScore() async {
    final result = await _databaseService.db.query(
      'game_scores',
      where: 'game_name = ? AND user_id = ?',
      whereArgs: ['Snake', _userId ?? 'guest'],
      orderBy: 'score DESC',
      limit: 1,
    );
    if (result.isNotEmpty) {
      highScore.value = result.first['score'] as int;
    }
  }

  void startGame() {
    if (gameState.value.isActive) return;
    if (gameState.value == GameState.gameOver) {
      resetGame();
    }
    gameState.value = GameState.playing;
    _gameTimer = Timer.periodic(Duration(milliseconds: speed.value), _gameLoop);
  }

  void pauseGame() {
    if (gameState.value == GameState.playing) {
      _gameTimer?.cancel();
      gameState.value = GameState.paused;
    }
  }

  void resumeGame() {
    if (gameState.value == GameState.paused) {
      gameState.value = GameState.playing;
      _gameTimer = Timer.periodic(Duration(milliseconds: speed.value), _gameLoop);
    }
  }

  void _gameLoop(Timer timer) {
    _moveSnake();
    if (_checkCollision()) {
      _gameOver();
    } else {
      _checkFoodCollision();
    }
  }

  void changeDirection(Direction newDir) {
    if (newDir.opposite != direction.value && newDir != direction.value) {
      nextDirection.value = newDir;
    }
  }

  void _moveSnake() {
    direction.value = nextDirection.value;
    final head = snake.first;
    final newHead = Position(head.x + direction.value.delta.x, head.y + direction.value.delta.y);

    snake.insert(0, newHead);
    // The tail is removed unless food is eaten, which happens in _checkFoodCollision
    // so we remove it here by default.
    snake.removeLast();
  }

  bool _checkCollision() {
    final head = snake.first;
    // Wall collision
    if (head.x < 0 || head.x >= gridSize || head.y < 0 || head.y >= gridSize) {
      return true;
    }
    // Self collision
    for (int i = 1; i < snake.length; i++) {
      if (head == snake[i]) {
        return true;
      }
    }
    return false;
  }

  void _checkFoodCollision() {
    if (snake.first == food.value) {
      score.value += 1;
      _adjustSpeed();
      _generateFood();
      // Grow the snake by not removing the tail this tick
      // We add a segment at the current tail position to make it grow smoothly
      snake.add(snake.last);
    }
  }

  void _adjustSpeed() {
    if (score.value % 5 == 0 && speed.value > 80) {
      speed.value = max(80, speed.value - 20); // Decrease duration, increase speed
      _gameTimer?.cancel();
      _gameTimer = Timer.periodic(Duration(milliseconds: speed.value), _gameLoop);
    }
  }

  void _generateFood() {
    final random = Random();
    Position newFoodPosition;
    do {
      newFoodPosition = Position(random.nextInt(gridSize), random.nextInt(gridSize));
    } while (snake.contains(newFoodPosition));
    food.value = newFoodPosition;
  }

  void _gameOver() {
    _gameTimer?.cancel();
    gameState.value = GameState.gameOver;
    if (score.value > highScore.value) {
      highScore.value = score.value;
      _saveScore();
    }
  }

  void _saveScore() async {
    await _databaseService.db.insert(
      'game_scores',
      {
        'user_id': _userId ?? 'guest',
        'game_name': 'Snake',
        'score': score.value,
        'created_at': DateTime.now().toIso8601String(),
      },
    );
  }

  void resetGame() {
    score.value = 0;
    speed.value = _initialSpeed;
    direction.value = Direction.right;
    nextDirection.value = Direction.right;
    snake.assignAll([
      const Position(5, 10),
      const Position(4, 10),
      const Position(3, 10),
    ]);
    _generateFood();
    gameState.value = GameState.idle;
  }

  @override
  void onClose() {
    _gameTimer?.cancel();
    super.onClose();
  }
}
