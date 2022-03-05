import 'package:flutter/material.dart';

import 'package:tetris_flutter/models/models.dart';

abstract class MinoColorScheme {
  const MinoColorScheme();

  Color getColor(MinoType type);

  Color getHintColor();
}

class StandardMinoColorScheme extends MinoColorScheme {
  @override
  Color getColor(MinoType type) {
    switch (type) {
      case MinoType.I:
        return Colors.cyan;
      case MinoType.J:
        return Colors.blue;
      case MinoType.L:
        return Colors.orange;
      case MinoType.O:
        return Colors.yellow.shade700;
      case MinoType.S:
        return Colors.green;
      case MinoType.T:
        return Colors.purple;
      case MinoType.Z:
        return Colors.red;
    }
  }

  @override
  Color getHintColor() {
    return Colors.grey.shade600;
  }
}
