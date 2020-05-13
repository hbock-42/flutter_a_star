import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_a_start/models/board.dart';
import 'package:flutter_a_start/models/board_tile.dart';

class BoardWidget extends StatelessWidget {
  final Board board;

  const BoardWidget({Key key, @required this.board}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var tileWidth = size.width / board.lines?.first?.length;
    var tileHeight = size.height / board.lines?.length;
    var tileSize = min(tileWidth, tileHeight);
    return Container(
      padding: MediaQuery.of(context).padding,
      child: buildBoard(tileSize),
    );
  }

  Widget buildTile(BoardTile boardTile, double tileSize) {
    return Container(
      width: tileSize,
      height: tileSize,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black,
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
      child: Container(
        color:
            boardTile.type == TileType.wall ? Colors.grey : Colors.transparent,
      ),
    );
  }

  Widget buildRow(List<BoardTile> row, double tileSize) {
    List<Widget> tiles = List<Widget>();
    row.forEach((boardTile) => tiles.add(buildTile(boardTile, tileSize)));
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: tiles);
  }

  Widget buildBoard(double tileSize) {
    List<Widget> rows = List<Widget>();
    board.lines.forEach((row) => rows.add(buildRow(row, tileSize)));
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: rows);
  }
}
