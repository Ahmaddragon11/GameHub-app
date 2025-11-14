import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../models/bird.dart';
import '../models/pipe.dart';

class GameCanvas extends StatelessWidget {
  final Bird bird;
  final List<Pipe> pipes;

  const GameCanvas({super.key, required this.bird, required this.pipes});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 9 / 16,
      child: ClipRect(
        child: CustomPaint(
          painter: GameCanvasPainter(bird: bird, pipes: pipes),
          child: Container(),
        ),
      ),
    );
  }
}

class GameCanvasPainter extends CustomPainter {
  final Bird bird;
  final List<Pipe> pipes;

  GameCanvasPainter({required this.bird, required this.pipes});

  @override
  void paint(Canvas canvas, Size size) {
    // Background
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF87CEEB), Color(0xFF4682B4)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Pipes
    final pipePaint = Paint()..color = Colors.green.shade800;
    final pipeBorderPaint = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
      
    for (final pipe in pipes) {
      final pipeX = pipe.x * size.width;
      final pipeWidth = Pipe.width * size.width;
      final gapY = pipe.gapY * size.height;
      final gapHeight = Pipe.gapHeight * size.height;

      final topPipeRect = Rect.fromLTWH(pipeX, 0, pipeWidth, gapY - gapHeight / 2);
      final bottomPipeRect = Rect.fromLTWH(pipeX, gapY + gapHeight / 2, pipeWidth, size.height);

      canvas.drawRect(topPipeRect, pipePaint);
      canvas.drawRect(bottomPipeRect, pipePaint);
      canvas.drawRect(topPipeRect, pipeBorderPaint);
      canvas.drawRect(bottomPipeRect, pipeBorderPaint);
    }

    // Bird
    final birdPaint = Paint()..color = AppTheme.gameColors['flappyBird'] ?? Colors.orange;
    final birdEyePaint = Paint()..color = Colors.white;
    final birdPupilPaint = Paint()..color = Colors.black;
    final birdBeakPaint = Paint()..color = Colors.yellow.shade700;
    final birdCenterX = size.width * 0.5;
    final birdCenterY = bird.y * size.height;
    final birdRadius = (Bird.size * size.width) / 2;

    canvas.save();
    canvas.translate(birdCenterX, birdCenterY);
    canvas.rotate(bird.rotation);
    canvas.translate(-birdCenterX, -birdCenterY);

    canvas.drawCircle(Offset(birdCenterX, birdCenterY), birdRadius, birdPaint);
    
    // Eye
    final eyeRadius = birdRadius * 0.2;
    final eyeOffsetX = birdRadius * 0.3;
    final eyeOffsetY = -birdRadius * 0.4;
    canvas.drawCircle(Offset(birdCenterX + eyeOffsetX, birdCenterY + eyeOffsetY), eyeRadius, birdEyePaint);
    canvas.drawCircle(Offset(birdCenterX + eyeOffsetX + 1, birdCenterY + eyeOffsetY), eyeRadius * 0.5, birdPupilPaint);
    
    // Beak
    final beakPath = Path()
      ..moveTo(birdCenterX + birdRadius, birdCenterY)
      ..lineTo(birdCenterX + birdRadius * 1.5, birdCenterY - birdRadius * 0.3)
      ..lineTo(birdCenterX + birdRadius * 1.5, birdCenterY + birdRadius * 0.3)
      ..close();
    canvas.drawPath(beakPath, birdBeakPaint);

    canvas.restore();
    
    // Ground
    final groundPaint = Paint()..color = Colors.green.shade600;
    canvas.drawRect(Rect.fromLTWH(0, size.height * 0.95, size.width, size.height * 0.05), groundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
