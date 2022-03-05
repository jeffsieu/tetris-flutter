import 'package:tetris_flutter/models/models.dart';

abstract class RotationSystem {
  const RotationSystem();

  List<Position> getAlternativeOffsets(
      MinoType type, Rotation initialRotation, Rotation targetRotation);
}

class SuperRotationSystem extends RotationSystem {
  const SuperRotationSystem();

  @override
  List<Position> getAlternativeOffsets(
      MinoType type, Rotation initialRotation, Rotation targetRotation) {
    if (type == MinoType.O) {
      return [const Position(0, 0)];
    } else if (type == MinoType.I) {
      if (initialRotation == Rotation.none &&
          targetRotation == Rotation.clockwise) {
        return [
          const Position(0, 0),
          const Position(-2, 0),
          const Position(1, 0),
          const Position(-2, 1),
          const Position(1, -2),
        ];
      } else if (initialRotation == Rotation.clockwise &&
          targetRotation == Rotation.none) {
        return [
          const Position(0, 0),
          const Position(2, 0),
          const Position(-1, 0),
          const Position(2, -1),
          const Position(-1, 2),
        ];
      } else if (initialRotation == Rotation.clockwise &&
          targetRotation == Rotation.half) {
        return [
          const Position(0, 0),
          const Position(-1, 0),
          const Position(2, 0),
          const Position(-1, -2),
          const Position(2, 1),
        ];
      } else if (initialRotation == Rotation.half &&
          targetRotation == Rotation.clockwise) {
        return [
          const Position(0, 0),
          const Position(1, 0),
          const Position(-2, 0),
          const Position(1, 2),
          const Position(-2, -1),
        ];
      } else if (initialRotation == Rotation.half &&
          targetRotation == Rotation.counterClockwise) {
        return [
          const Position(0, 0),
          const Position(2, 0),
          const Position(-1, 0),
          const Position(2, -1),
          const Position(-1, 2),
        ];
      } else if (initialRotation == Rotation.counterClockwise &&
          targetRotation == Rotation.half) {
        return [
          const Position(0, 0),
          const Position(-2, 0),
          const Position(1, 0),
          const Position(-2, 1),
          const Position(1, -2),
        ];
      } else if (initialRotation == Rotation.counterClockwise &&
          targetRotation == Rotation.none) {
        return [
          const Position(0, 0),
          const Position(1, 0),
          const Position(-2, 0),
          const Position(1, 2),
          const Position(-2, -1),
        ];
      } else if (initialRotation == Rotation.none &&
          targetRotation == Rotation.counterClockwise) {
        return [
          const Position(0, 0),
          const Position(-1, 0),
          const Position(2, 0),
          const Position(-1, -2),
          const Position(2, 1),
        ];
      }
    } else {
      if (initialRotation == Rotation.none &&
          targetRotation == Rotation.clockwise) {
        return [
          const Position(0, 0),
          const Position(-1, 0),
          const Position(-1, -1),
          const Position(0, 2),
          const Position(-1, 2),
        ];
      } else if (initialRotation == Rotation.clockwise &&
          targetRotation == Rotation.none) {
        return [
          const Position(0, 0),
          const Position(1, 0),
          const Position(1, 1),
          const Position(0, -2),
          const Position(1, -2),
        ];
      } else if (initialRotation == Rotation.clockwise &&
          targetRotation == Rotation.half) {
        return [
          const Position(0, 0),
          const Position(1, 0),
          const Position(1, 1),
          const Position(0, -2),
          const Position(1, -2),
        ];
      } else if (initialRotation == Rotation.half &&
          targetRotation == Rotation.clockwise) {
        return [
          const Position(0, 0),
          const Position(-1, 0),
          const Position(-1, -1),
          const Position(0, 2),
          const Position(-1, 2),
        ];
      } else if (initialRotation == Rotation.half &&
          targetRotation == Rotation.counterClockwise) {
        return [
          const Position(0, 0),
          const Position(1, 0),
          const Position(1, -1),
          const Position(0, 2),
          const Position(1, 2),
        ];
      } else if (initialRotation == Rotation.counterClockwise &&
          targetRotation == Rotation.half) {
        return [
          const Position(0, 0),
          const Position(-1, 0),
          const Position(-1, 1),
          const Position(0, -2),
          const Position(-1, -2),
        ];
      } else if (initialRotation == Rotation.counterClockwise &&
          targetRotation == Rotation.none) {
        return [
          const Position(0, 0),
          const Position(-1, 0),
          const Position(-1, 1),
          const Position(0, -2),
          const Position(-1, -2),
        ];
      } else if (initialRotation == Rotation.none &&
          targetRotation == Rotation.counterClockwise) {
        return [
          const Position(0, 0),
          const Position(1, 0),
          const Position(1, -1),
          const Position(0, 2),
          const Position(1, 2),
        ];
      }
    }
    return [const Position(0, 0)];
  }
}
