import 'package:tetris_flutter/models/bounding_box_delegate.dart';
import 'package:tetris_flutter/models/kick.dart';
import 'package:tetris_flutter/models/mino_color_scheme.dart';
import 'package:tetris_flutter/models/rotation.dart';

import 'models/mino.dart';
import 'models/mino_bag.dart';
import 'models/mino_color.dart';

const kBoardWidth = 10;
const kBoardHeight = 20;

class TetrisState {
  TetrisState.initial()
      : map = List.generate(
            kBoardHeight, (_) => List.filled(kBoardWidth, MinoTile.empty())),
        wasMinoHeld = false,
        heldMino = null {
    bag = RandomGeneratorBag();
    activeMino = bag.draw().toInitialMino();
    renderedTiles = getMapWithPiece();
  }

  TetrisState({
    required this.map,
    required this.bag,
    required this.activeMino,
    required this.heldMino,
    required this.wasMinoHeld,
  }) {
    renderedTiles = getMapWithPiece();
  }

  final List<List<MinoTile>> map;
  late final List<List<MinoTile>> renderedTiles;
  late final MinoBag bag;
  late final Mino activeMino;
  final MinoType? heldMino;
  final bool wasMinoHeld;

  bool fitsMino(Mino mino) {
    return mino.left >= 0 &&
        mino.right < kBoardWidth &&
        mino.top >= 0 &&
        mino.bottom < kBoardHeight &&
        mino.occupiedPositions.every((position) {
          final x = position.x;
          final y = position.y;
          return map[y][x].isEmpty;
        });
  }

  bool isGameOver() {
    return !fitsMino(activeMino);
  }

  bool canActiveMinoFall() {
    return fitsMino(activeMino.shifted(y: 1));
  }

  List<List<MinoTile>> getMapWithPiece() {
    final mapCopy =
        List.generate(kBoardHeight, (y) => List<MinoTile>.from(map[y]));
    for (var position in activeMino.occupiedPositions) {
      final x = position.x;
      final y = position.y;
      mapCopy[y][x] =
          MinoTile(StandardMinoColorScheme().getColor(activeMino.type));
    }
    return mapCopy;
  }

  static List<List<MinoTile>> removeFullRows(List<List<MinoTile>> map) {
    bool isEmptyRow(List<MinoTile> row) {
      return row.every((tile) => !tile.isEmpty);
    }

    List<List<MinoTile>> newMap = List.generate(
        kBoardHeight, (_) => List.filled(kBoardWidth, MinoTile.empty()));

    for (var y = kBoardHeight - 1, oldY = kBoardHeight - 1; oldY >= 0; oldY--) {
      if (isEmptyRow(map[oldY])) {
        continue;
      }
      newMap[y--] = map[oldY];
    }

    return newMap;
  }

  TetrisState withMinoSwapped() {
    if (wasMinoHeld) {
      return this;
    }
    final nextMino = heldMino?.toInitialMino() ?? bag.draw().toInitialMino();
    return copyWith(
      wasMinoHeld: heldMino == null,
      heldMino: activeMino.type,
      activeMino: nextMino,
    );
  }

  TetrisState withMinoShifted({int x = 0, int y = 0}) {
    final shiftedMino = activeMino.shifted(x: x, y: y);
    if (!fitsMino(shiftedMino)) {
      if (y != 1) {
        return this;
      } else {
        return copyWith(
          map: removeFullRows(getMapWithPiece()),
          activeMino: bag.draw().toInitialMino(),
          wasMinoHeld: false,
        );
      }
    }

    return copyWith(
      activeMino: shiftedMino,
    );
  }

  TetrisState withMinoDropped() {
    var currentMino = activeMino;
    var shiftedMino = currentMino.shifted(y: 1);
    while (fitsMino(shiftedMino)) {
      currentMino = shiftedMino;
      shiftedMino = currentMino.shifted(y: 1);
    }
    return copyWith(
      activeMino: currentMino,
      wasMinoHeld: false,
    ).withMinoShifted(y: 1);
  }

  TetrisState withMinoRotated(Rotation rotation) {
    final targetRotation = activeMino.rotation.add(rotation);
    final rotatedMino = activeMino.rotated(rotation);

    for (var offset in RotationSystem().getAlternativeOffsets(
        activeMino.type, activeMino.rotation, targetRotation)) {
      final rotatedAndOffsetMino =
          rotatedMino.shifted(x: offset.x, y: offset.y);

      if (fitsMino(rotatedAndOffsetMino)) {
        return copyWith(
          activeMino: rotatedAndOffsetMino,
        );
      }
    }

    return this;
  }

  TetrisState copyWith({
    List<List<MinoTile>>? map,
    MinoBag? bag,
    Mino? activeMino,
    MinoType? heldMino,
    bool? wasMinoHeld,
  }) {
    return TetrisState(
      map: map ?? this.map,
      bag: bag ?? this.bag,
      activeMino: activeMino ?? this.activeMino,
      heldMino: heldMino ?? this.heldMino,
      wasMinoHeld: wasMinoHeld ?? this.wasMinoHeld,
    );
  }
}

extension on MinoType {
  Mino toInitialMino() {
    return Mino.initial(
      type: this,
      baseBoundingBox: MinoBoundingBoxDelegateImpl().getBoundingBox(this),
      boardWidth: kBoardWidth,
      boardHeight: kBoardHeight,
    );
  }
}
