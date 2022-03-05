import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tetris_flutter/models/models.dart';

const double kTileSize = 12.0;

class MinoPiece extends StatelessWidget {
  const MinoPiece(this.mino, {Key? key}) : super(key: key);

  final Mino mino;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.watch<MinoColorScheme>();
    return SizedBox(
      width: kTileSize * (mino.right - mino.left + 1),
      height: kTileSize * (mino.bottom - mino.top + 1),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: mino.boundingBox.size,
        children: [
          for (var y = mino.top; y <= mino.bottom; y++)
            for (var x = mino.left; x <= mino.right; x++)
              Container(
                height: kTileSize,
                width: kTileSize,
                decoration: mino.boundingBox.tiles[y][x]
                    ? BoxDecoration(
                        color: MinoTile(mino.type).toColor(colorScheme),
                        border: Border.all(
                            color: Theme.of(context).colorScheme.outline),
                      )
                    : null,
              ),
        ],
      ),
    );
  }
}
