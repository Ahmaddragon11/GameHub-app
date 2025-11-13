import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class PongGameScreen extends StatefulWidget {
  const PongGameScreen({super.key});

  @override
  State<PongGameScreen> createState() => _PongGameScreenState();
}

class _PongGameScreenState extends State<PongGameScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  double _ballX = 0;
  double _ballY = 0;
  double _ballDirectionX = 1;
  double _ballDirectionY = 1;
  double _player1Y = 0;
  double _player2Y = 0;
  int _player1Score = 0;
  int _player2Score = 0;
  final double _paddleHeight = 100;
  final double _paddleWidth = 20;
  final double _ballSize = 20;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..addListener(_updateGame);
    _controller.repeat();
  }

  void _updateGame() {
    setState(() {
      _ballX += 5 * _ballDirectionX;
      _ballY += 5 * _ballDirectionY;

      // Ball collision with top and bottom walls
      if (_ballY < -1 || _ballY > 1) {
        _ballDirectionY *= -1;
        _playSound('wall_hit.wav');
      }

      // Ball collision with paddles
      if ((_ballX > 0.9 && _ballX < 0.95 && _ballY > _player2Y - 0.2 && _ballY < _player2Y + 0.2) ||
          (_ballX < -0.9 && _ballX > -0.95 && _ballY > _player1Y - 0.2 && _ballY < _player1Y + 0.2)) {
        _ballDirectionX *= -1;
        _playSound('paddle_hit.wav');
      }

      // Ball out of bounds
      if (_ballX > 1) {
        _player1Score++;
        _resetBall();
      } else if (_ballX < -1) {
        _player2Score++;
        _resetBall();
      }
    });
  }

  void _resetBall() {
    _ballX = 0;
    _ballY = 0;
    _ballDirectionX = _ballDirectionX == 1 ? -1 : 1;
    _ballDirectionY = _ballDirectionY == 1 ? -1 : 1;
  }

  Future<void> _playSound(String sound) async {
    await _audioPlayer.play(AssetSource('sounds/$sound'));
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          setState(() {
            // Player 1 controls
            _player1Y += details.delta.dy / (context.size!.height / 2);
            _player1Y = _player1Y.clamp(-1.0, 1.0);

            // Simple AI for Player 2
            _player2Y = _ballY.clamp(-1.0, 1.0);
          });
        },
        child: Stack(
          children: [
            // Center line
            Center(
              child: Container(
                width: 2,
                height: double.infinity,
                color: Colors.white24,
              ),
            ),
            // Scores
            Align(
              alignment: const Alignment(0, -0.8),
              child: Text(
                '$_player1Score - $_player2Score',
                style: const TextStyle(color: Colors.white, fontSize: 40),
              ),
            ),
            // Player 1 paddle
            Align(
              alignment: Alignment(-0.95, _player1Y),
              child: Container(
                width: _paddleWidth,
                height: _paddleHeight,
                color: Colors.white,
              ),
            ),
            // Player 2 paddle (AI)
            Align(
              alignment: Alignment(0.95, _player2Y),
              child: Container(
                width: _paddleWidth,
                height: _paddleHeight,
                color: Colors.white,
              ),
            ),
            // Ball
            Align(
              alignment: Alignment(_ballX, _ballY),
              child: Container(
                width: _ballSize,
                height: _ballSize,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
