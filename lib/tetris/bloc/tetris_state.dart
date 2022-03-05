part of 'tetris_bloc.dart';

const kBoardWidth = 10;
const kBoardHeight = 20;

class TetrisState extends Equatable {
  TetrisState.initial(this.gameSystemSpecs)
      : map = List.generate(
            kBoardHeight, (_) => List.filled(kBoardWidth, MinoTile.empty())),
        wasMinoHeld = false,
        heldMino = null {
    activeMino = bag.draw().toInitialMino(gameSystemSpecs);
    hintMino = getHintMino(activeMino, map);
    renderedTiles = getMapWithPiece();
  }

  TetrisState({
    required this.map,
    required this.gameSystemSpecs,
    required this.activeMino,
    required this.hintMino,
    required this.heldMino,
    required this.wasMinoHeld,
  }) {
    renderedTiles = getMapWithPiece();
  }

  final List<List<MinoTile>> map;
  final GameSystemSpecs gameSystemSpecs;
  late final List<List<MinoTile>> renderedTiles;
  late final Mino activeMino;
  late final Mino hintMino;
  final MinoType? heldMino;
  final bool wasMinoHeld;

  MinoBag get bag => gameSystemSpecs.bag;
  RotationSystem get rotationSystem => gameSystemSpecs.rotationSystem;

  bool fitsMino(Mino mino) {
    return minoFitsInMap(mino, map);
  }

  static minoFitsInMap(Mino mino, List<List<MinoTile>> map) {
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

    for (var position in hintMino.occupiedPositions) {
      final x = position.x;
      final y = position.y;
      mapCopy[y][x] = MinoTile(StandardMinoColorScheme().getHintColor());
    }

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
    final nextMino = (heldMino ?? bag.draw()).toInitialMino(gameSystemSpecs);
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
          activeMino: bag.draw().toInitialMino(gameSystemSpecs),
          wasMinoHeld: false,
        );
      }
    }

    return copyWith(
      activeMino: shiftedMino,
    );
  }

  static Mino getHintMino(Mino mino, List<List<MinoTile>> map) {
    var shiftedMino = mino.shifted(y: 1);
    while (minoFitsInMap(shiftedMino, map)) {
      mino = shiftedMino;
      shiftedMino = mino.shifted(y: 1);
    }
    return mino;
  }

  TetrisState withMinoDropped() {
    return copyWith(
      activeMino: hintMino,
      wasMinoHeld: false,
    ).withMinoShifted(y: 1);
  }

  TetrisState withMinoRotated(Rotation rotation) {
    final targetRotation = activeMino.rotation.add(rotation);
    final rotatedMino = activeMino.rotated(rotation);

    for (var offset in rotationSystem.getAlternativeOffsets(
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
    GameSystemSpecs? gameSystemSpecs,
    Mino? activeMino,
    MinoType? heldMino,
    bool? wasMinoHeld,
  }) {
    return TetrisState(
      map: map ?? this.map,
      gameSystemSpecs: gameSystemSpecs ?? this.gameSystemSpecs,
      activeMino: activeMino ?? this.activeMino,
      hintMino: activeMino != null
          ? getHintMino(activeMino, map ?? this.map)
          : hintMino,
      heldMino: heldMino ?? this.heldMino,
      wasMinoHeld: wasMinoHeld ?? this.wasMinoHeld,
    );
  }

  @override
  List<Object?> get props => [
        map,
        bag,
        activeMino,
        hintMino,
        heldMino,
        wasMinoHeld,
      ];
}

extension on MinoType {
  Mino toInitialMino(GameSystemSpecs movementSystem) {
    return Mino.initial(
      type: this,
      baseBoundingBox: movementSystem.boundingBoxProvider.getBoundingBox(this),
      boardWidth: kBoardWidth,
      boardHeight: kBoardHeight,
    );
  }
}
