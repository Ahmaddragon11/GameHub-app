import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class SnakeGameScreen extends StatefulWidget {
  const SnakeGameScreen({super.key});

  @override
  State<SnakeGameScreen> createState() => _SnakeGameScreenState();
}

class _SnakeGameScreenState extends State<SnakeGameScreen> {
  static const int _gridSize = 20;
  List<Point<int>> _snake = [const Point(10, 10)];
  Point<int> _food = const Point(15, 15);
  String _direction = 'right';
  bool _isPlaying = false;
  int _score = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
  }

  void _startGame() {
    setState(() {
      _snake = [const Point(10, 10)];
      _food = const Point(15, 15);
      _direction = 'right';
      _isPlaying = true;
      _score = 0;
    });
    _timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      _updateSnake();
    });
  }

  void _updateSnake() {
    if (!_isPlaying) return;

    setState(() {
      Point<int> head = _snake.first;
      Point<int> newHead;

      switch (_direction) {
        case 'up':
          newHead = Point(head.x, head.y - 1);
          break;
        case 'down':
          newHead = Point(head.x, head.y + 1);
          break;
        case 'left':
          newHead = Point(head.x - 1, 0);
          break;
        case 'right':
          newHead = Point(head.x + 1, 0);
          break;
        default:
          return;
      }

      if (_snake.contains(newHead) ||
          newHead.x < 0 ||
          newHead.x >= _gridSize ||
          newHead.y < 0 ||
          newHead.y >= _gridSize) {
        _gameOver();
        return;
      }

      _snake.insert(0, newHead);

      if (newHead == _food) {
        _score++;
        _generateFood();
      } else {
        _snake.removeLast();
      }
    });
  }

  void _generateFood() {
    setState(() {
      _food = Point(
        Random().nextInt(_gridSize),
        Random().nextInt(_gridSize),
      );
    });
  }

  void _gameOver() {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
    });
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Game Over'),
        content: Text('Your score: $_score'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _startGame();
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Snake Game'),
      ),
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.delta.dy > 0 && _direction != 'up') {
            _direction = 'down';
          } else if (details.delta.dy < 0 && _direction != 'down') {
            _direction = 'up';
          }
        },
        onHorizontalDragUpdate: (details) {
          if (details.delta.dx > 0 && _direction != 'left') {
            _direction = 'right';
          } else if (details.delta.dx < 0 && _direction != 'right') {
            _direction = 'left';
          }
        },
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.black,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _gridSize,
                  ),
                  itemBuilder: (context, index) {
                    var x = index % _gridSize;
                    var y = index ~/ _gridSize;
                    var point = Point(x, y);
                    bool isSnake = _snake.contains(point);
                    bool isFood = point == _food;

                    return Container(
                      margin: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: isSnake
                            ? Colors.green
                            : isFood
                                ? Colors.red
                                : Colors.grey[800],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  },
                  itemCount: _gridSize * _gridSize,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Score: $_score',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: _isPlaying ? null : _startGame,
                    child: Text(_isPlaying ? 'Playing' : 'Start Game'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
