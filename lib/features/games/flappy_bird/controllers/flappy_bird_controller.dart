import 'dart:async';
import 'dart:math';

import 'package:flutter/animation.dart'; // Import for AnimationController
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/services/database_service.dart';
import '../../../../core/services/storage_service.dart';
import '../models/bird.dart';
import '../models/game_state.dart';
import '../models/pipe.dart';

class FlappyBirdController extends GetxController with GetSingleTickerProviderStateMixin {
  // Game constants
  static const double gravity = 0.0012;
  static const double jumpVelocity = -0.018;
  static const double maxVelocity = 0.025;
  static const int gameLoopDuration = 16; // ~60 FPS
  static const int pipeSpawnInterval = 1500; // milliseconds

  // Reactive state variables
  final Rx<Bird> bird = Rx<Bird>(const Bird(y: Bird.initialY, velocity: 0, rotation: 0));
  final RxList<Pipe> pipes = RxList<Pipe>();
  final Rx<GameState> gameState = Rx<GameState>(GameState.idle);
  final RxInt score = RxInt(0);
  final RxInt highScore = RxInt(0);

  // Services
  late final DatabaseService _databaseService;
  late final StorageService _storageService;

  // Timers
  Timer? _gameTimer;
  Timer? _pipeSpawnTimer;
  
  String? _userId;
  final Random _random = Random();

  // Animation for bird wings
  late AnimationController _wingAnimationController;
  late Animation<double> wingAnimation;

  @override
  void onInit() {
    super.onInit();
    _databaseService = Get.find<DatabaseService>();
    _storageService = Get.find<StorageService>();
    _loadData();
    resetGame();

    _wingAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150), // Fast flapping
    );
    wingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_wingAnimationController);
  }

  Future<void> _loadData() async {
    _userId = await _storageService.getUserId();
    if (_userId == null) {
      _userId = const Uuid().v4();
      await _storageService.setUserId(_userId!);
    }
    final savedScore = await _databaseService.getHighScore('Flappy Bird');
    highScore.value = savedScore;
  }

  void startGame() {
    if (gameState.value != GameState.playing) {
      resetGame();
      gameState.value = GameState.playing;
      _gameTimer = Timer.periodic(const Duration(milliseconds: gameLoopDuration), _gameLoop);
      _pipeSpawnTimer = Timer.periodic(const Duration(milliseconds: pipeSpawnInterval), (timer) => _spawnPipe());
      _wingAnimationController.repeat(reverse: true);
    }
  }

  void pauseGame() {
    if (gameState.value.canPause) {
      _gameTimer?.cancel();
      _pipeSpawnTimer?.cancel();
      _wingAnimationController.stop();
      gameState.value = GameState.paused;
    }
  }

  void resumeGame() {
    if (gameState.value == GameState.paused) {
      startGame();
    }
  }

  void jump() {
    if (gameState.value == GameState.playing) {
      bird.value = bird.value.copyWith(velocity: jumpVelocity);
    }
  }

  void _gameLoop(Timer timer) {
    // Apply gravity
    double newVelocity = bird.value.velocity + gravity;
    newVelocity = newVelocity.clamp(-double.infinity, maxVelocity);
    final newY = bird.value.y + newVelocity;

    // Calculate rotation
    final rotation = (newVelocity * 2.5).clamp(-0.8, 0.4); // Radians

    bird.value = bird.value.copyWith(y: newY, velocity: newVelocity, rotation: rotation);

    // Move pipes
    final newPipes = pipes.map((p) => p.move()).toList();
    pipes.assignAll(newPipes);
    pipes.removeWhere((p) => p.isOffScreen());
    
    _checkCollisions();
    _updateScore();
  }
  
  void _spawnPipe() {
    final gapY = _random.nextDouble() * 0.4 + 0.3; // 0.3 to 0.7
    pipes.add(Pipe(x: 1.0, gapY: gapY));
  }

  void _checkCollisions() {
    // Ground and ceiling collision
    if (bird.value.y > 0.95 || bird.value.y < 0.05) {
      _gameOver();
      return;
    }
    // Pipe collision
    for (final pipe in pipes) {
      if (pipe.checkCollision(bird.value)) {
        _gameOver();
        return;
      }
    }
  }

  void _updateScore() {
    for (int i = 0; i < pipes.length; i++) {
      final pipe = pipes[i];
      if (!pipe.scored && pipe.x + Pipe.width < 0.5) {
        score.value++;
        pipes[i] = pipe.copyWith(scored: true);
        if (score.value > highScore.value) {
          highScore.value = score.value;
        }
      }
    }
  }

  void _gameOver() {
    _gameTimer?.cancel();
    _pipeSpawnTimer?.cancel();
    _wingAnimationController.stop();
    gameState.value = GameState.gameOver;
    if (score.value > highScore.value) {
      highScore.value = score.value;
    }
    _saveScore();
  }

  Future<void> _saveScore() async {
    if (_userId != null) {
      await _databaseService.addScore('Flappy Bird', score.value);
    }
  }

  void resetGame() {
    gameState.value = GameState.idle;
    bird.value = const Bird(y: Bird.initialY, velocity: 0, rotation: 0);
    pipes.clear();
    score.value = 0;
    _gameTimer?.cancel();
    _pipeSpawnTimer?.cancel();
    _wingAnimationController.stop();
  }

  @override
  void onClose() {
    _gameTimer?.cancel();
    _pipeSpawnTimer?.cancel();
    _wingAnimationController.dispose();
    super.onClose();
  }
}
