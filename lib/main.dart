import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tetris_flutter/input/input.dart';
import 'package:tetris_flutter/models/models.dart';
import 'package:tetris_flutter/tetris/tetris.dart';

void main() {
  runApp(const TetrisApp());
}

class TetrisApp extends StatelessWidget {
  const TetrisApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tetris',
      theme: FlexThemeData.dark(),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

final repeatableKeyBindings = {
  PhysicalKeyboardKey.arrowLeft: PieceShifted(Direction.left),
  PhysicalKeyboardKey.arrowRight: PieceShifted(Direction.right),
  PhysicalKeyboardKey.arrowDown: PieceShifted(Direction.down),
};

final nonRepeatableKeyBindings = {
  PhysicalKeyboardKey.shiftLeft: const PieceSwapped(),
  PhysicalKeyboardKey.space: const PieceDropped(),
  PhysicalKeyboardKey.keyZ: const PieceRotated(Rotation.counterClockwise),
  PhysicalKeyboardKey.keyX: const PieceRotated(Rotation.clockwise),
  PhysicalKeyboardKey.keyA: const PieceRotated(Rotation.half),
  PhysicalKeyboardKey.arrowUp: const PieceRotated(Rotation.clockwise),
  PhysicalKeyboardKey.keyR: const GameReset(),
};

class _MyHomePageState extends State<MyHomePage> {
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    focusNode.requestFocus();
    return Scaffold(
      body: Provider<MinoColorScheme>(
        create: (context) => StandardMinoColorScheme(brightness),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  TetrisBloc(TetrisState.initial(GameSystemSpecs.standard())),
            ),
            BlocProvider(
              create: (context) => InputBloc(
                keyBindings: {
                  ...repeatableKeyBindings.map(
                    (key, value) => MapEntry(
                      key,
                      InputAction(
                          callback: () {
                            context.read<TetrisBloc>().add(value);
                          },
                          isRepeatable: true),
                    ),
                  ),
                  ...nonRepeatableKeyBindings.map(
                    (key, value) => MapEntry(
                      key,
                      InputAction(
                          callback: () {
                            context.read<TetrisBloc>().add(value);
                          },
                          isRepeatable: false),
                    ),
                  ),
                },
              ),
            ),
          ],
          child: Builder(builder: (context) {
            final heldMino =
                context.select((TetrisBloc bloc) => bloc.state.heldMino);
            final nextMinoType =
                context.select((TetrisBloc bloc) => bloc.state.nextMinoType);
            return RawKeyboardListener(
              focusNode: focusNode,
              onKey: (event) {
                if (event is RawKeyDownEvent) {
                  context
                      .read<InputBloc>()
                      .add(InputKeyDownEvent(event.physicalKey));
                } else if (event is RawKeyUpEvent) {
                  context
                      .read<InputBloc>()
                      .add(InputKeyUpEvent(event.physicalKey));
                }
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: FittedBox(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                children: [
                                  const Text('Hold'),
                                  SizedBox(
                                    width: kTileSize * 4,
                                    height: kTileSize * 4,
                                    child: Center(
                                      child: heldMino != null
                                          ? MinoPiece(
                                              Mino(
                                                position: const Position(0, 0),
                                                baseBoundingBox: context
                                                    .read<TetrisBloc>()
                                                    .state
                                                    .gameSystemSpecs
                                                    .boundingBoxProvider
                                                    .getBoundingBox(heldMino),
                                                rotation: Rotation.none,
                                                type: heldMino,
                                              ),
                                              key: ValueKey(heldMino),
                                            )
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                              const MinoBoard(),
                              Column(
                                children: [
                                  const Text('Next'),
                                  SizedBox(
                                    width: kTileSize * 4,
                                    height: kTileSize * 4,
                                    child: Center(
                                      child: MinoPiece(
                                        Mino(
                                          position: const Position(0, 0),
                                          baseBoundingBox: context
                                              .read<TetrisBloc>()
                                              .state
                                              .gameSystemSpecs
                                              .boundingBoxProvider
                                              .getBoundingBox(nextMinoType),
                                          rotation: Rotation.none,
                                          type: nextMinoType,
                                        ),
                                        key: ValueKey(nextMinoType),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
