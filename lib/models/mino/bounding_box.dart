import 'package:tetris_flutter/models/models.dart';

/// Represents information regarding the rotated bounding box of a [Mino].
class MinoBoundingBox {
  const MinoBoundingBox(this.tiles);

  /// The tiles that make up the bounding box.
  final List<List<bool>> tiles;

  int get size => tiles.length;

  List<Position> getOccupiedTiles() {
    final occupiedTiles = <Position>[];
    for (var y = 0; y < size; y++) {
      for (var x = 0; x < size; x++) {
        if (tiles[y][x]) {
          occupiedTiles.add(Position(x, y));
        }
      }
    }
    return occupiedTiles;
  }

  MinoBoundingBox rotated(Rotation rotation) {
    final rotatedTiles =
        List<List<bool>>.generate(size, (_) => List<bool>.filled(size, false));
    for (var y = 0; y < size; y++) {
      for (var x = 0; x < size; x++) {
        final tile = tiles[y][x];
        switch (rotation) {
          case Rotation.none:
            rotatedTiles[y][x] = tile;
            break;
          case Rotation.clockwise:
            rotatedTiles[x][size - y - 1] = tile;
            break;
          case Rotation.half:
            rotatedTiles[size - y - 1][size - x - 1] = tile;
            break;
          case Rotation.counterClockwise:
            rotatedTiles[size - x - 1][y] = tile;
            break;
        }
      }
    }
    return MinoBoundingBox(rotatedTiles);
  }
}
