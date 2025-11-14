import 'package:flutter/foundation.dart';
import './bird.dart';

@immutable
class Pipe {
  final double x;
  final double gapY;
  final bool scored;

  const Pipe({
    required this.x,
    required this.gapY,
    this.scored = false,
  });

  static const double width = 0.12;
  static const double gapHeight = 0.25;
  static const double speed = 0.005;

  Pipe copyWith({
    double? x,
    double? gapY,
    bool? scored,
  }) {
    return Pipe(
      x: x ?? this.x,
      gapY: gapY ?? this.gapY,
      scored: scored ?? this.scored,
    );
  }

  Pipe move() {
    return copyWith(x: x - speed);
  }

  bool isOffScreen() {
    return x < -width;
  }

  bool checkCollision(Bird bird) {
    final birdX = 0.5;
    final birdY = bird.y;
    final birdRadius = Bird.size / 2;

    final pipeLeft = x;
    final pipeRight = x + width;
    final gapTop = gapY - gapHeight / 2;
    final gapBottom = gapY + gapHeight / 2;

    // Check horizontal collision
    if (birdX + birdRadius > pipeLeft && birdX - birdRadius < pipeRight) {
      // Check vertical collision
      if (birdY - birdRadius < gapTop || birdY + birdRadius > gapBottom) {
        return true;
      }
    }
    return false;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Pipe && other.x == x && other.gapY == gapY && other.scored == scored;
  }

  @override
  int get hashCode => x.hashCode ^ gapY.hashCode ^ scored.hashCode;

  @override
  String toString() => 'Pipe(x: $x, gapY: $gapY, scored: $scored)';
}
