import 'package:flutter/foundation.dart';

@immutable
class Bird {
  final double y;
  final double velocity;
  final double rotation;

  const Bird({
    required this.y,
    required this.velocity,
    required this.rotation,
  });

  static const double size = 0.08;
  static const double initialY = 0.5;

  Bird copyWith({
    double? y,
    double? velocity,
    double? rotation,
  }) {
    return Bird(
      y: y ?? this.y,
      velocity: velocity ?? this.velocity,
      rotation: rotation ?? this.rotation,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Bird &&
        other.y == y &&
        other.velocity == velocity &&
        other.rotation == rotation;
  }

  @override
  int get hashCode => y.hashCode ^ velocity.hashCode ^ rotation.hashCode;

  @override
  String toString() => 'Bird(y: $y, velocity: $velocity, rotation: $rotation)';
}
