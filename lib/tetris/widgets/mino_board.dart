import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tetris_flutter/models/models.dart';
import 'package:tetris_flutter/tetris/tetris.dart';

class MinoBoard extends StatelessWidget {
  const MinoBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.watch<MinoColorScheme>();
    final tiles = context.select((TetrisBloc bloc) => bloc.state.renderedTiles);
    return SizedBox(
      width: kTileSize * kBoardWidth,
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: kBoardWidth,
        children: [
          for (var y = 0; y < kBoardHeight; y++)
            for (var x = 0; x < kBoardWidth; x++)
              Container(
                height: kTileSize,
                width: kTileSize,
                foregroundDecoration: BoxDecoration(
                  border: Border.all(
                      color: tiles[y][x].isEmpty
                          ? Theme.of(context).dividerColor
                          : Theme.of(context).colorScheme.outline),
                ),
                decoration: BoxDecoration(
                  color: tiles[y][x].toColor(colorScheme),
                ),
              ),
        ],
      ),
    );
  }
}
