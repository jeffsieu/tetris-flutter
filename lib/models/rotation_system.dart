import 'bounding_box.dart';

abstract class MinoRotationDelegate {
  MinoBoundingBox getBoundingBoxWithRotation(MinoBoundingBox piece, int rotation);
}