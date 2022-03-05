import 'dart:math';

import 'package:tetris_flutter/models/models.dart';

abstract class MinoBag {
  const MinoBag();

  MinoType draw();
}

class RandomGeneratorBag extends MinoBag {
  final Random _random = Random();

  final List<MinoType> remaining = [];

  @override
  MinoType draw() {
    if (remaining.isEmpty) {
      remaining.addAll([...MinoType.values]..shuffle(_random));
    }
    return remaining.removeLast();
  }
}
