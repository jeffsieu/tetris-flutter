import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tetris_flutter/models/models.dart';

part 'tetris_state.dart';

const Duration kMinoRestingDuration = Duration(milliseconds: 500);

class TetrisBloc extends Bloc<TetrisEvent, TetrisState> {
  TetrisBloc(TetrisState initialState) : super(initialState) {
    on<PieceFell>(_onPieceFell);
    on<PieceShifted>(_onPieceShifted);
    on<PieceRotated>(_onPieceRotated);
    on<PieceDropped>(_onPieceDropped);
    on<PieceSwapped>(_onPieceSwapped);

    fallTimer = Timer.periodic(const Duration(milliseconds: 300), _onTimerTick);
  }

  late Timer fallTimer;
  Timer? settleTimer;

  @override
  Future<void> close() async {
    fallTimer.cancel();
    super.close();
  }

  void _onTimerTick(Timer timer) {
    add(PieceShifted(Direction.down));
  }

  void _onSettleTimerTick() {
    settleTimer = null;
    add(const PieceDropped());
  }

  void _onPieceFell(PieceFell event, Emitter<TetrisState> emit) {
    emit(state.withMinoShifted(y: 1));
  }

  void _onPieceShifted(PieceShifted event, Emitter<TetrisState> emit) {
    if (state.isGameOver()) {
      emit(TetrisState.initial(GameSystemSpecs.standard()));
      return;
    }
    if (event.y == 1 && (settleTimer != null || !state.canActiveMinoFall())) {
      // If the piece can no longer fall, we start the settle timer.
      settleTimer ??= Timer(kMinoRestingDuration, _onSettleTimerTick);
      return;
    }

    final newState = state.withMinoShifted(x: event.x, y: event.y);

    if (state != newState) {
      // Reset the settle timer if the piece has shifted.
      settleTimer?.cancel();
      settleTimer = null;
      emit(newState);
    }
  }

  void _onPieceRotated(PieceRotated event, Emitter<TetrisState> emit) {
    settleTimer?.cancel();
    settleTimer = null;
    emit(state.withMinoRotated(event.rotation));
  }

  void _onPieceDropped(PieceDropped event, Emitter<TetrisState> emit) {
    settleTimer?.cancel();
    settleTimer = null;
    emit(state.withMinoDropped());
  }

  void _onPieceSwapped(PieceSwapped event, Emitter<TetrisState> emit) {
    settleTimer?.cancel();
    settleTimer = null;
    emit(state.withMinoSwapped());
  }
}

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
