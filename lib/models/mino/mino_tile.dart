import 'package:flutter/material.dart';

class MinoTile {
  MinoTile.empty()
      : color = Colors.transparent,
        isEmpty = true;
  const MinoTile(this.color) : isEmpty = false;

  final Color color;
  final bool isEmpty;
}
