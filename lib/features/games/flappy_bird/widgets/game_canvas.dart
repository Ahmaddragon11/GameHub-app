import 'package:flutter/material.dart';
import 'dart:math'; // Import for sin and pi

import '../../../../core/theme/app_theme.dart';
import '../models/bird.dart';
import '../models/pipe.dart';

class GameCanvas extends StatelessWidget {
  final Bird bird;
  final List<Pipe> pipes;
  final double wingAnimation; // Value from 0.0 to 1.0 for wing flapping

  const GameCanvas({super.key, required this.bird, required this.pipes, required this.wingAnimation});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 9 / 16,
      child: ClipRect(
        child: CustomPaint(
          painter: GameCanvasPainter(bird: bird, pipes: pipes, wingAnimation: wingAnimation),
          child: Container(),
        ),
      ),
    );
  }
}

class GameCanvasPainter extends CustomPainter {
  final Bird bird;
  final List<Pipe> pipes;
  final double wingAnimation;

  GameCanvasPainter({required this.bird, required this.pipes, required this.wingAnimation});

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
    final birdColor = AppTheme.gameColors['flappyBird'] ?? Colors.orange;
    final birdPaint = Paint()..color = birdColor;
    final birdOutlinePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final birdEyePaint = Paint()..color = Colors.white;
    final birdPupilPaint = Paint()..color = Colors.black;
    final birdBeakPaint = Paint()..color = Colors.yellow.shade700;

    final birdCenterX = size.width * 0.5;
    final birdCenterY = bird.y * size.height;
    final birdWidth = Bird.size * size.width * 1.2; // Slightly wider
    final birdHeight = Bird.size * size.height * 0.8; // Slightly shorter
    final birdBodyRect = Rect.fromCenter(center: Offset(birdCenterX, birdCenterY), width: birdWidth, height: birdHeight);

    canvas.save();
    canvas.translate(birdCenterX, birdCenterY);
    canvas.rotate(bird.rotation);
    canvas.translate(-birdCenterX, -birdCenterY);

    // Bird body
    canvas.drawOval(birdBodyRect, birdPaint);
    canvas.drawOval(birdBodyRect, birdOutlinePaint);

    // Eye
    final eyeRadius = birdWidth * 0.08;
    final eyeOffsetX = birdWidth * 0.2;
    final eyeOffsetY = -birdHeight * 0.15;
    canvas.drawCircle(Offset(birdCenterX + eyeOffsetX, birdCenterY + eyeOffsetY), eyeRadius, birdEyePaint);
    canvas.drawCircle(Offset(birdCenterX + eyeOffsetX + 1, birdCenterY + eyeOffsetY), eyeRadius * 0.5, birdPupilPaint);

    // Beak
    final beakPath = Path()
      ..moveTo(birdCenterX + birdWidth / 2, birdCenterY)
      ..lineTo(birdCenterX + birdWidth / 2 + birdWidth * 0.2, birdCenterY - birdHeight * 0.1)
      ..lineTo(birdCenterX + birdWidth / 2 + birdWidth * 0.2, birdCenterY + birdHeight * 0.1)
      ..close();
    canvas.drawPath(beakPath, birdBeakPaint);
    canvas.drawPath(beakPath, birdOutlinePaint);

    // Wings
    final wingPaint = Paint()..color = birdColor.withOpacity(0.8);
    final wingOutlinePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Calculate wing rotation based on animation value
    final wingRotation = sin(wingAnimation * pi * 2) * 0.3; // Oscillates between -0.3 and 0.3 radians

    canvas.save();
    canvas.translate(birdCenterX - birdWidth * 0.2, birdCenterY - birdHeight * 0.1); // Pivot point for wing
    canvas.rotate(wingRotation);
    canvas.translate(-(birdCenterX - birdWidth * 0.2), -(birdCenterY - birdHeight * 0.1));

    final wingPath = Path()
      ..moveTo(birdCenterX - birdWidth * 0.1, birdCenterY - birdHeight * 0.2)
      ..quadraticBezierTo(
        birdCenterX - birdWidth * 0.3, birdCenterY - birdHeight * 0.5,
        birdCenterX - birdWidth * 0.4, birdCenterY - birdHeight * 0.2,
      )
      ..quadraticBezierTo(
        birdCenterX - birdWidth * 0.3, birdCenterY + birdHeight * 0.1,
        birdCenterX - birdWidth * 0.1, birdCenterY - birdHeight * 0.2,
      )
      ..close();
    canvas.drawPath(wingPath, wingPaint);
    canvas.drawPath(wingPath, wingOutlinePaint);
    canvas.restore(); // Restore wing rotation

    canvas.restore(); // Restore bird rotation
    
    // Ground
    final groundPaint = Paint()..color = Colors.green.shade600;
    canvas.drawRect(Rect.fromLTWH(0, size.height * 0.95, size.width, size.height * 0.05), groundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
