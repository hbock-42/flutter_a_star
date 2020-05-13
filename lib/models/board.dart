import 'dart:math';

import 'board_tile.dart';

class Board {
  List<List<BoardTile>> lines;
  int get width => lines.first.length;
  int get height => lines.length;

  Board(this.lines);

  Board.random(int width, int height, double wallRatio) {
    wallRatio = max(0, min(1, wallRatio));
    Random rand = Random.secure();
    lines = List<List<BoardTile>>();
    for (var y = 0; y < height; y++) {
      lines.add(List<BoardTile>());
      for (var x = 0; x < width; x++) {
        var randBoardTile = BoardTile(
          position: Point(x, y),
          type: _createTileType(width, height, x, y, rand, wallRatio),
        );
        lines[y].add(randBoardTile);
      }
    }
  }

  TileType _createTileType(int boardWidth, int boardHeight, int tileX,
      int tileY, Random rand, double wallRatio) {
    if (tileX == 0 ||
        tileX + 1 == boardWidth ||
        tileY == 0 ||
        tileY + 1 == boardHeight) return TileType.wall;

    return rand.nextDouble() < wallRatio ? TileType.wall : TileType.empty;
  }
}
