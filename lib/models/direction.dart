enum Direction {
  up,
  right,
  down,
  left,
}

extension DirectionExtension on Direction {
  int get x {
    switch (this) {
      case Direction.up:
        return 0;
      case Direction.down:
        return 0;
      case Direction.left:
        return -1;
      case Direction.right:
        return 1;
    }
  }

  int get y {
    switch (this) {
      case Direction.up:
        return -1;
      case Direction.down:
        return 1;
      case Direction.left:
        return 0;
      case Direction.right:
        return 0;
    }
  }
}