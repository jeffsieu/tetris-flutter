part of 'input_bloc.dart';

class InputState {
  InputState.initial() : pressedKeys = {};
  const InputState({required this.pressedKeys});

  final Map<PhysicalKeyboardKey, bool> pressedKeys;

  InputState _copyWithKey(PhysicalKeyboardKey key, bool value) {
    return InputState(pressedKeys: Map.from(pressedKeys)..[key] = value);
  }

  InputState copyWithKeyUp(PhysicalKeyboardKey key) {
    return _copyWithKey(key, false);
  }

  InputState copyWithKeyDown(PhysicalKeyboardKey key) {
    return _copyWithKey(key, true);
  }

  bool isKeyUp(PhysicalKeyboardKey key) {
    return pressedKeys[key] == false;
  }

  bool isKeyDown(PhysicalKeyboardKey key) {
    return pressedKeys[key] == true;
  }
}
