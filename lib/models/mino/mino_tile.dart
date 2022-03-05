import 'package:tetris_flutter/models/models.dart';

class MinoTile {
  const MinoTile.empty()
      : type = null,
        isHint = false;
  const MinoTile.hint()
      : type = null,
        isHint = true;
  const MinoTile(this.type) : isHint = false;

  final MinoType? type;
  final bool isHint;
  bool get isEmpty => type == null;
}
