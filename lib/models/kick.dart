import 'package:tetris_flutter/models/mino.dart';
import 'package:tetris_flutter/models/rotation.dart';

// I Tetromino Wall Kick Data
// 0 means no rotation
// R means clockwise rotation
// L means counter-clockwise rotation
// 2 means 180 degree rotation
// Test 1	Test 2	Test 3	Test 4	Test 5
// 0->R	( 0, 0)	(-2, 0)	(+1, 0)	(-2,-1)	(+1,+2)
// R->0	( 0, 0)	(+2, 0)	(-1, 0)	(+2,+1)	(-1,-2)
// R->2	( 0, 0)	(-1, 0)	(+2, 0)	(-1,+2)	(+2,-1)
// 2->R	( 0, 0)	(+1, 0)	(-2, 0)	(+1,-2)	(-2,+1)
// 2->L	( 0, 0)	(+2, 0)	(-1, 0)	(+2,+1)	(-1,-2)
// L->2	( 0, 0)	(-2, 0)	(+1, 0)	(-2,-1)	(+1,+2)
// L->0	( 0, 0)	(+1, 0)	(-2, 0)	(+1,-2)	(-2,+1)
// 0->L	( 0, 0)	(-1, 0)	(+2, 0)	(-1,+2)	(+2,-1)

// J, L, S, T, Z Tetromino Wall Kick Data
// Test 1	Test 2	Test 3	Test 4	Test 5
// 0->R	( 0, 0)	(-1, 0)	(-1,+1)	( 0,-2)	(-1,-2)
// R->0	( 0, 0)	(+1, 0)	(+1,-1)	( 0,+2)	(+1,+2)
// R->2	( 0, 0)	(+1, 0)	(+1,-1)	( 0,+2)	(+1,+2)
// 2->R	( 0, 0)	(-1, 0)	(-1,+1)	( 0,-2)	(-1,-2)
// 2->L	( 0, 0)	(+1, 0)	(+1,+1)	( 0,-2)	(+1,-2)
// L->2	( 0, 0)	(-1, 0)	(-1,-1)	( 0,+2)	(-1,+2)
// L->0	( 0, 0)	(-1, 0)	(-1,-1)	( 0,+2)	(-1,+2)
// 0->L	( 0, 0)	(+1, 0)	(+1,+1)	( 0,-2)	(+1,-2)

class RotationSystem {
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
          targetRotation == Rotation.counterclockwise) {
        return [
          const Position(0, 0),
          const Position(2, 0),
          const Position(-1, 0),
          const Position(2, -1),
          const Position(-1, 2),
        ];
      } else if (initialRotation == Rotation.counterclockwise &&
          targetRotation == Rotation.half) {
        return [
          const Position(0, 0),
          const Position(-2, 0),
          const Position(1, 0),
          const Position(-2, 1),
          const Position(1, -2),
        ];
      } else if (initialRotation == Rotation.counterclockwise &&
          targetRotation == Rotation.none) {
        return [
          const Position(0, 0),
          const Position(1, 0),
          const Position(-2, 0),
          const Position(1, 2),
          const Position(-2, -1),
        ];
      } else if (initialRotation == Rotation.none &&
          targetRotation == Rotation.counterclockwise) {
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
          targetRotation == Rotation.counterclockwise) {
        return [
          const Position(0, 0),
          const Position(1, 0),
          const Position(1, -1),
          const Position(0, 2),
          const Position(1, 2),
        ];
      } else if (initialRotation == Rotation.counterclockwise &&
          targetRotation == Rotation.half) {
        return [
          const Position(0, 0),
          const Position(-1, 0),
          const Position(-1, 1),
          const Position(0, -2),
          const Position(-1, -2),
        ];
      } else if (initialRotation == Rotation.counterclockwise &&
          targetRotation == Rotation.none) {
        return [
          const Position(0, 0),
          const Position(-1, 0),
          const Position(-1, 1),
          const Position(0, -2),
          const Position(-1, -2),
        ];
      } else if (initialRotation == Rotation.none &&
          targetRotation == Rotation.counterclockwise) {
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
