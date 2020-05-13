import 'package:flutter/material.dart';
import 'package:flutter_a_start/models/board.dart';
import 'package:flutter_a_start/models/board_tile.dart';

class BoardWidget extends StatelessWidget {
  final Board board;

  const BoardWidget({Key key, @required this.board}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: buildBoard(),
    );
  }

  Widget buildTile(BoardTile boardTile) {
    return Container(
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

  Widget buildRow(List<BoardTile> row) {
    List<Widget> tiles = List<Widget>();
    row.forEach(
        (boardTile) => tiles.add(Expanded(child: buildTile(boardTile))));
    return Row(children: tiles);
  }

  Widget buildBoard() {
    List<Widget> rows = List<Widget>();
    board.lines.forEach((row) => rows.add(Expanded(child: buildRow(row))));
    return Column(children: rows);
  }
}
