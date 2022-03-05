enum Rotation {
  clockwise,
  counterclockwise,
  half,
  none,
}

extension RotationExtension on Rotation {
  int get turns {
    switch (this) {
      case Rotation.clockwise:
        return 1;
      case Rotation.counterclockwise:
        return 3;
      case Rotation.half:
        return 2;
      case Rotation.none:
        return 0;
    }
  }

  Rotation add(Rotation other) {
    final int turns = (this.turns + other.turns) % 4;
    if (turns == 0) {
      return Rotation.none;
    } else if (turns == 1) {
      return Rotation.clockwise;
    } else if (turns == 2) {
      return Rotation.half;
    } else if (turns == 3) {
      return Rotation.counterclockwise;
    } else {
      throw Exception('Invalid rotation: $turns');
    }
  }
}
