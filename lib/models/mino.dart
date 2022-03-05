import 'dart:math';

import 'package:tetris_flutter/models/models.dart';

class Mino {
  Mino.initial({
    required MinoType type,
    required MinoBoundingBox baseBoundingBox,
    required int boardWidth,
    required int boardHeight,
  }) : this(
          // Place it centered on the board
          position: Position((boardWidth - baseBoundingBox.size) ~/ 2, 0),
          type: type,
          baseBoundingBox: baseBoundingBox,
          rotation: Rotation.none,
        );

  Mino({
    required this.position,
    required this.type,
    required this.baseBoundingBox,
    required this.rotation,
  }) : occupiedPositions =
            getOccupiedPositions(position, baseBoundingBox.rotated(rotation));

  final Position position;
  final MinoType type;
  final MinoBoundingBox baseBoundingBox;
  final Rotation rotation;
  final List<Position> occupiedPositions;

  int get left => occupiedPositions.map((p) => p.x).reduce(min);
  int get right => occupiedPositions.map((p) => p.x).reduce(max);
  int get top => occupiedPositions.map((p) => p.y).reduce(min);
  int get bottom => occupiedPositions.map((p) => p.y).reduce(max);

  MinoBoundingBox get boundingBox => baseBoundingBox.rotated(rotation);

  static List<Position> getOccupiedPositions(
      Position position, MinoBoundingBox boundingBox) {
    final positions = <Position>[];
    for (var relativePosition in boundingBox.getOccupiedTiles()) {
      final x = relativePosition.x + position.x;
      final y = relativePosition.y + position.y;
      positions.add(Position(x, y));
    }
    return positions;
  }

  Mino shifted({int x = 0, int y = 0}) {
    return Mino(
      position: position.shifted(x: x, y: y),
      type: type,
      baseBoundingBox: baseBoundingBox,
      rotation: rotation,
    );
  }

  Mino rotated(Rotation rotation) {
    return Mino(
      position: position,
      type: type,
      baseBoundingBox: baseBoundingBox,
      rotation: this.rotation.add(rotation),
    );
  }
}
