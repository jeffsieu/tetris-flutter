import 'package:flutter/material.dart';

import 'mino.dart';

abstract class MinoColorScheme {
  const MinoColorScheme();

  Color getColor(MinoType type);
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
}
