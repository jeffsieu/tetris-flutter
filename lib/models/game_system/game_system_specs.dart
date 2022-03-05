import 'package:tetris_flutter/models/models.dart';

class GameSystemSpecs {
  GameSystemSpecs.standard()
      : this(
          boundingBoxProvider: const StandardMinoBoundingBoxProvider(),
          rotationSystem: const SuperRotationSystem(),
          bag: RandomGeneratorBag(),
        );
  const GameSystemSpecs({
    required this.boundingBoxProvider,
    required this.rotationSystem,
    required this.bag,
  });

  final MinoBoundingBoxProvider boundingBoxProvider;
  final RotationSystem rotationSystem;
  final MinoBag bag;
}
