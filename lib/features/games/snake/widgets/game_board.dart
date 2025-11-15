import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../models/position.dart';

class GameBoard extends StatelessWidget {
  final List<Position> snake;
  final Position food;
  final int gridSize;

  const GameBoard({super.key, required this.snake, required this.food, required this.gridSize});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black87,
          border: Border.all(color: AppTheme.accentColor, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomPaint(
          painter: GameBoardPainter(snake: snake, food: food, gridSize: gridSize),
        ),
      ),
    );
  }
}

class GameBoardPainter extends CustomPainter {
  final List<Position> snake;
  final Position food;
  final int gridSize;

  GameBoardPainter({required this.snake, required this.food, required this.gridSize});

  @override
  void paint(Canvas canvas, Size size) {
    final double cellSize = size.width / gridSize;
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.1)
      ..style = PaintingStyle.stroke;

    // Draw grid lines
    for (int i = 1; i < gridSize; i++) {
      canvas.drawLine(Offset(i * cellSize, 0), Offset(i * cellSize, size.height), gridPaint);
      canvas.drawLine(Offset(0, i * cellSize), Offset(size.width, i * cellSize), gridPaint);
    }

    // Draw food
    final foodPaint = Paint()..color = Colors.red.shade400;
    canvas.drawOval(
      Rect.fromCircle(
        center: Offset((food.x + 0.5) * cellSize, (food.y + 0.5) * cellSize),
        radius: cellSize / 2.2,
      ),
      foodPaint,
    );

    // Draw snake
    final snakeHeadPaint = Paint()..color = Colors.green.shade400;
    final snakeBodyPaint = Paint()..color = Colors.green.shade600;

    for (int i = 0; i < snake.length; i++) {
      final part = snake[i];
      final rect = Rect.fromLTWH(part.x * cellSize, part.y * cellSize, cellSize, cellSize);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect.inflate(-1.5), const Radius.circular(4)),
        i == 0 ? snakeHeadPaint : snakeBodyPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
