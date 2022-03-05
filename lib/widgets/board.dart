import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tetris_flutter/tetris/tetris.dart';

class Board extends StatelessWidget {
  const Board({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tiles = context.select((TetrisBloc bloc) => bloc.state.renderedTiles);
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: kBoardWidth,
      children: [
        for (var y = 0; y < kBoardHeight; y++)
          for (var x = 0; x < kBoardWidth; x++)
            Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                color: tiles[y][x].color,
                border: Border.all(color: Colors.grey),
              ),
            ),
      ],
    );
  }
}
