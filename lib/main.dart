import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tetris_flutter/input/input.dart';
import 'package:tetris_flutter/models/models.dart';
import 'package:tetris_flutter/tetris/tetris.dart';
import 'package:tetris_flutter/widgets/board.dart';

void main() {
  runApp(const TetrisApp());
}

class TetrisApp extends StatelessWidget {
  const TetrisApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tetris',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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
    focusNode.requestFocus();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: MultiBlocProvider(
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
            child: Stack(
              children: [
                const SizedBox(width: 200, child: Board()),
                const SizedBox(height: 20),
                Row(
                  children: [
                    ElevatedButton(
                      child: const Text('Fall piece'),
                      onPressed: () {
                        context.read<TetrisBloc>().add(const PieceFell());
                      },
                    ),
                    ElevatedButton(
                      child: const Text('Left'),
                      onPressed: () {
                        context
                            .read<TetrisBloc>()
                            .add(PieceShifted(Direction.left));
                      },
                    ),
                    ElevatedButton(
                      child: const Text('Right'),
                      onPressed: () {
                        context
                            .read<TetrisBloc>()
                            .add(PieceShifted(Direction.right));
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
