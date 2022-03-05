part of 'tetris_bloc.dart';

abstract class TetrisEvent {
  const TetrisEvent();
}

class PieceFell extends TetrisEvent {
  const PieceFell();
}

class PieceShifted extends TetrisEvent {
  PieceShifted(Direction direction)
      : x = direction.x,
        y = direction.y;

  final int x;
  final int y;
}

class PieceRotated extends TetrisEvent {
  const PieceRotated(this.rotation);

  final Rotation rotation;
}

class PieceDropped extends TetrisEvent {
  const PieceDropped();
}

class PieceSwapped extends TetrisEvent {
  const PieceSwapped();
}

class GameReset extends TetrisEvent {
  const GameReset();
}
