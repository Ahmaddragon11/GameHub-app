import './position.dart';

enum Direction {
  up,
  down,
  left,
  right,
}

extension DirectionExtension on Direction {
  Direction get opposite {
    switch (this) {
      case Direction.up:
        return Direction.down;
      case Direction.down:
        return Direction.up;
      case Direction.left:
        return Direction.right;
      case Direction.right:
        return Direction.left;
    }
  }

  Position get delta {
    switch (this) {
      case Direction.up:
        return const Position(0, -1);
      case Direction.down:
        return const Position(0, 1);
      case Direction.left:
        return const Position(-1, 0);
      case Direction.right:
        return const Position(1, 0);
    }
  }

  bool get isHorizontal => this == Direction.left || this == Direction.right;
  bool get isVertical => this == Direction.up || this == Direction.down;
}
