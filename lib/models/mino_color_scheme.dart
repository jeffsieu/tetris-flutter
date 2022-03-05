import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:tetris_flutter/models/models.dart';

abstract class MinoColorScheme {
  const MinoColorScheme();

  Color getColor(MinoType type);

  Color getHintColor();
}

class StandardMinoColorScheme extends MinoColorScheme {
  const StandardMinoColorScheme(this.brightness);

  final Brightness brightness;
  final _LightStandardMinoColorScheme _light =
      const _LightStandardMinoColorScheme();
  final _DarkStandardMinoColorScheme _dark =
      const _DarkStandardMinoColorScheme();

  @override
  Color getColor(MinoType type) {
    return brightness == Brightness.light
        ? _light.getColor(type)
        : _dark.getColor(type);
  }

  @override
  Color getHintColor() {
    return brightness == Brightness.light
        ? _light.getHintColor()
        : _dark.getHintColor();
  }
}

class _LightStandardMinoColorScheme extends MinoColorScheme {
  const _LightStandardMinoColorScheme();

  static const double tone = 25.0;

  static final Map<MinoType, Color> _colors = {
    MinoType.I: Colors.cyan,
    MinoType.J: Colors.blue,
    MinoType.L: Colors.orange,
    MinoType.O: Colors.yellow,
    MinoType.S: Colors.green,
    MinoType.T: Colors.purple,
    MinoType.Z: Colors.red,
  }.map((type, color) =>
      MapEntry(type, color.toHctColor().copyWith(tone: tone).toColor()));

  static final Color _hintColor =
      Colors.grey.toHctColor().copyWith(tone: 100 - tone).toColor();

  @override
  Color getColor(MinoType type) {
    return _colors[type]!;
  }

  @override
  Color getHintColor() {
    return _hintColor;
  }
}

class _DarkStandardMinoColorScheme extends MinoColorScheme {
  const _DarkStandardMinoColorScheme();

  static const double tone = 75.0;

  static final Map<MinoType, Color> _colors = {
    MinoType.I: Colors.cyan,
    MinoType.J: Colors.blue,
    MinoType.L: Colors.orange,
    MinoType.O: Colors.yellow,
    MinoType.S: Colors.green,
    MinoType.T: Colors.purple,
    MinoType.Z: Colors.red,
  }.map((type, color) =>
      MapEntry(type, color.toHctColor().copyWith(tone: tone).toColor()));

  static final Color _hintColor =
      Colors.grey.toHctColor().copyWith(tone: 100 - tone).toColor();

  @override
  Color getColor(MinoType type) {
    return _colors[type]!;
  }

  @override
  Color getHintColor() {
    return _hintColor;
  }
}

extension on Color {
  HctColor toHctColor() {
    return HctColor.fromInt(value);
  }
}

extension on HctColor {
  HctColor copyWith({
    double? hue,
    double? chroma,
    double? tone,
  }) {
    return HctColor.from(
      hue ?? this.hue,
      chroma ?? this.chroma,
      tone ?? this.tone,
    );
  }

  Color toColor() {
    return Color(toInt());
  }
}

extension MinoTileExtension on MinoTile {
  Color toColor(MinoColorScheme colorScheme) {
    if (!isEmpty) {
      return colorScheme.getColor(type!);
    } else {
      if (isHint) {
        return colorScheme.getHintColor();
      } else {
        return Colors.transparent;
      }
    }
  }
}
