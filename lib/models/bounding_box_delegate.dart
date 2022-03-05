import 'package:tetris_flutter/models/bounding_box.dart';
import 'package:tetris_flutter/models/mino.dart';

abstract class MinoBoundingBoxDelegate {
  MinoBoundingBox getBoundingBox(MinoType type);
}

class MinoBoundingBoxDelegateImpl extends MinoBoundingBoxDelegate {
  @override
  MinoBoundingBox getBoundingBox(MinoType type) {
    switch (type) {
      case MinoType.I:
        return const MinoBoundingBox([
          [false, false, false, false],
          [true, true, true, true],
          [false, false, false, false],
          [false, false, false, false],
        ]);
      case MinoType.J:
        return const MinoBoundingBox([
          [true, false, false],
          [true, true, true],
          [false, false, false],
        ]);
      case MinoType.L:
        return const MinoBoundingBox([
          [false, false, true],
          [true, true, true],
          [false, false, false],
        ]);
      case MinoType.O:
        return const MinoBoundingBox([
          [true, true],
          [true, true],
        ]);
      case MinoType.S:
        return const MinoBoundingBox([
          [false, true, true],
          [true, true, false],
          [false, false, false],
        ]);
      case MinoType.T:
        return const MinoBoundingBox([
          [false, true, false],
          [true, true, true],
          [false, false, false],
        ]);
      case MinoType.Z:
        return const MinoBoundingBox([
          [true, true, false],
          [false, true, true],
          [false, false, false],
        ]);
    }
  }
}
