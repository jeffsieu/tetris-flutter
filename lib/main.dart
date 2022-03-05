import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tetris_flutter/tetris/tetris_bloc.dart';
import 'package:tetris_flutter/tetris_state.dart';
import 'package:tetris_flutter/widgets/board.dart';

import 'models/direction.dart';
import 'models/rotation.dart';

void main() {
  runApp(const TetrisApp());
}

class TetrisApp extends StatelessWidget {
  const TetrisApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
      body: BlocProvider(
        create: (context) => TetrisBloc(TetrisState.initial()),
        child: Builder(builder: (context) {
          return FocusableActionDetector(
            focusNode: focusNode,
            shortcuts: {
              const SingleActivator(LogicalKeyboardKey.arrowLeft):
                  _TetrisIntent(PieceShifted(Direction.left)),
              const SingleActivator(LogicalKeyboardKey.arrowRight):
                  _TetrisIntent(PieceShifted(Direction.right)),
              const SingleActivator(LogicalKeyboardKey.arrowDown):
                  _TetrisIntent(PieceShifted(Direction.down)),
              const SingleActivator(LogicalKeyboardKey.space):
                  const _TetrisIntent(PieceDropped()),
              const SingleActivator(LogicalKeyboardKey.keyZ):
                  const _TetrisIntent(PieceRotated(Rotation.counterclockwise)),
              const SingleActivator(LogicalKeyboardKey.keyX):
                  const _TetrisIntent(PieceRotated(Rotation.clockwise)),
              const SingleActivator(LogicalKeyboardKey.keyA):
                  const _TetrisIntent(PieceRotated(Rotation.half)),
              const SingleActivator(LogicalKeyboardKey.keyC):
                  const _TetrisIntent(PieceSwapped()),
            },
            actions: {
              _TetrisIntent: CallbackAction<_TetrisIntent>(
                onInvoke: (intent) {
                  context.read<TetrisBloc>().add(intent.event);
                  return null;
                },
              )
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

class _TetrisIntent extends Intent {
  const _TetrisIntent(this.event);

  final TetrisEvent event;
}
