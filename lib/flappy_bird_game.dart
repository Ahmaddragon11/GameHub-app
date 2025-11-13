import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:myapp/high_score_manager.dart';

class FlappyBirdGameScreen extends StatefulWidget {
  const FlappyBirdGameScreen({super.key});

  @override
  State<FlappyBirdGameScreen> createState() => _FlappyBirdGameScreenState();
}

class _FlappyBirdGameScreenState extends State<FlappyBirdGameScreen> {
  // Game settings
  static const double birdSize = 50;
  static const double gravity = 9.8;
  static const double jumpStrength = -4.9;
  static const double pipeWidth = 80;
  static const double pipeGap = 200;

  // Game state
  double birdY = 0;
  double birdVelocity = 0;
  double time = 0;
  List<double> pipeX = [0, 0];
  List<double> pipeHeight = [0, 0];
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
    final loadedHighScore = await _highScoreManager.getHighScore('flappy_bird');
    setState(() {
      highScore = loadedHighScore;
    });
  }

  void startGame() {
    setState(() {
      birdY = 0;
      birdVelocity = 0;
      time = 0;
      score = 0;
      pipeX[0] = MediaQuery.of(context).size.width;
      pipeX[1] = MediaQuery.of(context).size.width + MediaQuery.of(context).size.width / 2;
      pipeHeight[0] = 150;
      pipeHeight[1] = 200;
      isPlaying = true;
    });

    gameLoop?.cancel();
    gameLoop = Timer.periodic(const Duration(milliseconds: 60), (timer) {
      if (isPlaying) {
        updateGame();
      }
    });
  }

  void updateGame() {
    setState(() {
      time += 0.05;
      birdVelocity += gravity * 0.05;
      birdY += birdVelocity;

      // Move pipes
      for (int i = 0; i < pipeX.length; i++) {
        pipeX[i] -= 5;
        if (pipeX[i] < -pipeWidth) {
          pipeX[i] += MediaQuery.of(context).size.width * 1.5;
          pipeHeight[i] = math.Random().nextDouble() * 200 + 100;
          score++;
        }
      }

      // Check for collisions
      if (birdY > MediaQuery.of(context).size.height - birdSize || birdY < 0) {
        gameOver();
      }

      for (int i = 0; i < pipeX.length; i++) {
        if (pipeX[i] < birdSize &&
            pipeX[i] + pipeWidth > 0 &&
            (birdY < pipeHeight[i] || birdY + birdSize > pipeHeight[i] + pipeGap)) {
          gameOver();
        }
      }
    });
  }

  void jump() {
    if (isPlaying) {
      setState(() {
        birdVelocity = jumpStrength;
      });
    }
  }

  void gameOver() {
    setState(() {
      isPlaying = false;
    });
    gameLoop?.cancel();

    if (score > highScore) {
      _highScoreManager.setHighScore('flappy_bird', score);
      setState(() {
        highScore = score;
      });
    }

    showDialog(
      context: context,
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: jump,
        child: Stack(
          children: [
            // Background
            Container(
              color: Colors.lightBlueAccent,
            ),

            // Pipes
            for (int i = 0; i < pipeX.length; i++) ...[
              Positioned(
                left: pipeX[i],
                top: 0,
                child: Container(
                  width: pipeWidth,
                  height: pipeHeight[i],
                  color: Colors.green,
                ),
              ),
              Positioned(
                left: pipeX[i],
                bottom: 0,
                child: Container(
                  width: pipeWidth,
                  height: MediaQuery.of(context).size.height - pipeHeight[i] - pipeGap,
                  color: Colors.green,
                ),
              ),
            ],

            // Bird
            AnimatedContainer(
              duration: const Duration(milliseconds: 0),
              alignment: Alignment(0, birdY / (MediaQuery.of(context).size.height / 2)),
              child: Container(
                width: birdSize,
                height: birdSize,
                decoration: const BoxDecoration(
                  color: Colors.yellow,
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Score
            Positioned(
              top: 50,
              left: 20,
              child: Text(
                'Score: $score',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              top: 80,
              left: 20,
              child: Text(
                'High Score: $highScore',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
