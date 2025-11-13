import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:myapp/high_score_manager.dart';

class SnakeGameScreen extends StatefulWidget {
  const SnakeGameScreen({super.key});

  @override
  State<SnakeGameScreen> createState() => _SnakeGameScreenState();
}

class _SnakeGameScreenState extends State<SnakeGameScreen> {
  // Game settings
  static const int gridSize = 20;
  static const int initialSnakeLength = 3;

  // Game state
  List<Point<int>> snake = [];
  Point<int> food = const Point(0, 0);
  Direction direction = Direction.right;
  bool isPlaying = false;
  int score = 0;
  int highScore = 0;

  // Game loop timer
  Timer? gameLoop;
  final HighScoreManager _highScoreManager = HighScoreManager();

  @override
  void initState() {
    super.initState();
    _loadHighScore();
    startGame();
  }

  Future<void> _loadHighScore() async {
    final loadedHighScore = await _highScoreManager.getHighScore('snake');
    if (mounted) {
      setState(() {
        highScore = loadedHighScore;
      });
    }
  }

  void startGame() {
    setState(() {
      // Initialize snake
      snake.clear();
      for (int i = 0; i < initialSnakeLength; i++) {
        snake.add(Point(initialSnakeLength - 1 - i, 0));
      }

      // Generate initial food
      generateFood();

      // Set initial direction and score
      direction = Direction.right;
      score = 0;
      isPlaying = true;
    });

    // Start game loop
    gameLoop?.cancel();
    gameLoop = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (isPlaying) {
        moveSnake();
      }
    });
  }

  void generateFood() {
    final random = Random();
    Point<int> newFood;
    do {
      newFood = Point(random.nextInt(gridSize), random.nextInt(gridSize));
    } while (snake.contains(newFood));
    if (mounted) {
      setState(() {
        food = newFood;
      });
    }
  }

  void moveSnake() {
    if (!mounted) return;
    setState(() {
      final head = snake.first;
      Point<int> newHead;

      switch (direction) {
        case Direction.up:
          newHead = Point(head.x, head.y - 1);
          break;
        case Direction.down:
          newHead = Point(head.x, head.y + 1);
          break;
        case Direction.left:
          newHead = Point(head.x - 1, head.y);
          break;
        case Direction.right:
          newHead = Point(head.x + 1, head.y);
          break;
      }

      // Check for wall collision
      if (newHead.x < 0 ||
          newHead.x >= gridSize ||
          newHead.y < 0 ||
          newHead.y >= gridSize) {
        gameOver();
        return;
      }

      // Check for self-collision
      if (snake.contains(newHead)) {
        gameOver();
        return;
      }

      snake.insert(0, newHead);

      // Check for food collision
      if (newHead == food) {
        score++;
        generateFood();
      } else {
        snake.removeLast();
      }
    });
  }

  void gameOver() {
    if (!mounted) return;
    setState(() {
      isPlaying = false;
    });
    gameLoop?.cancel();

    if (score > highScore) {
      _highScoreManager.setHighScore('snake', score);
      if (mounted) {
        setState(() {
          highScore = score;
        });
      }
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Text('Your score: $score\nHigh score: $highScore'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                startGame();
              },
              child: const Text('Play Again'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    gameLoop?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Snake'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Score: $score | High Score: $highScore',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (direction != Direction.up && details.delta.dy > 0) {
            direction = Direction.down;
          } else if (direction != Direction.down && details.delta.dy < 0) {
            direction = Direction.up;
          }
        },
        onHorizontalDragUpdate: (details) {
          if (direction != Direction.left && details.delta.dx > 0) {
            direction = Direction.right;
          } else if (direction != Direction.right && details.delta.dx < 0) {
            direction = Direction.left;
          }
        },
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridSize,
          ),
          itemBuilder: (context, index) {
            final x = index % gridSize;
            final y = index ~/ gridSize;
            final point = Point(x, y);

            if (snake.contains(point)) {
              return Container(
                color: Colors.green,
                margin: const EdgeInsets.all(1),
              );
            } else if (food == point) {
              return Container(
                color: Colors.red,
                margin: const EdgeInsets.all(1),
              );
            } else {
              return Container(
                color: Colors.grey[800],
                margin: const EdgeInsets.all(1),
              );
            }
          },
          itemCount: gridSize * gridSize,
        ),
      ),
    );
  }
}

enum Direction {
  up,
  down,
  left,
  right,
}
