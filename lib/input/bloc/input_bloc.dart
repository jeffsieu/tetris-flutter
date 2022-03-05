import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'input_state.dart';

/// The duration to wait before auto-repeating user input.
const Duration kDelayedAutoShiftDuration = Duration(milliseconds: 100);

/// The delay between each auto-repeated key press.
const Duration kAutoShiftDelay = Duration(milliseconds: 30);

class InputAction {
  const InputAction({required this.callback, required this.isRepeatable});
  final bool isRepeatable;
  final void Function() callback;

  void execute() {
    callback();
  }
}

class InputBloc extends Bloc<InputEvent, InputState> {
  InputBloc({required this.keyBindings}) : super(InputState.initial()) {
    on<InputKeyUpEvent>(_onKeyUp);
    on<InputKeyDownEvent>(_onKeyDown);
  }

  final Map<PhysicalKeyboardKey, InputAction> keyBindings;
  final Map<PhysicalKeyboardKey, InputActionExecutor> executors = {};

  void _onKeyUp(InputKeyUpEvent event, Emitter<InputState> emit) {
    emit(state.copyWithKeyUp(event.key));

    if (executors.containsKey(event.key)) {
      executors[event.key]!.cancel();
      executors.remove(event.key);
    }
  }

  void _onKeyDown(InputKeyDownEvent event, Emitter<InputState> emit) {
    if (!state.isKeyDown(event.key)) {
      if (keyBindings.containsKey(event.key)) {
        executors[event.key] = InputActionExecutor(keyBindings[event.key]!)
          ..execute();
      }
    }
    emit(state.copyWithKeyDown(event.key));
  }
}

class InputActionExecutor {
  InputActionExecutor(this.action);

  final InputAction action;
  Timer? timer;
  Timer? repeatTimer;

  void execute() {
    action.execute();

    if (action.isRepeatable) {
      repeatTimer = Timer(kDelayedAutoShiftDuration, () {
        timer = Timer.periodic(kAutoShiftDelay, (timer) {
          action.execute();
        });
      });
    }
  }

  void cancel() {
    timer?.cancel();
    repeatTimer?.cancel();
  }
}

abstract class InputEvent {
  const InputEvent(this.key);

  final PhysicalKeyboardKey key;
}

class InputKeyUpEvent extends InputEvent {
  const InputKeyUpEvent(PhysicalKeyboardKey key) : super(key);
}

class InputKeyDownEvent extends InputEvent {
  const InputKeyDownEvent(PhysicalKeyboardKey key) : super(key);
}
