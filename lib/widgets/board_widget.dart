import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_a_start/helpers/a_star.dart';
import 'package:flutter_a_start/models/board.dart';
import 'package:flutter_a_start/models/board_tile.dart';

class BoardWidget extends StatefulWidget {
  final Board board;

  const BoardWidget({Key key, @required this.board}) : super(key: key);

  @override
  _BoardWidgetState createState() => _BoardWidgetState();
}

class _BoardWidgetState extends State<BoardWidget> {
  BoardTile start;
  BoardTile end;
  List<Point> path = List<Point>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var tileWidth = size.width / widget.board.lines?.first?.length;
    var tileHeight = size.height / widget.board.lines?.length;
    var tileSize = min(tileWidth, tileHeight);
    return Container(
      padding: MediaQuery.of(context).padding,
      child: buildBoard(tileSize),
    );
  }

  Widget buildTile(BoardTile boardTile, double tileSize) {
    Color tileColor =
        boardTile.type == TileType.wall ? Colors.grey : Colors.transparent;
    if (boardTile == start) {
      tileColor = Colors.green;
    } else if (boardTile == end) {
      tileColor = Colors.red;
    } else if (path.contains(boardTile.position)) {
      tileColor = Colors.blue;
    }
    return GestureDetector(
      onTap: () {
        if (start == null) {
          setState(() => start = boardTile);
        } else {
          setState(() => end = boardTile);
          var astar = AStar(
              board: widget.board, start: start.position, end: end.position);
          path = astar.calculatePath();
          start = null;
          end = null;
        }
      },
      child: Container(
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
          color: tileColor,
        ),
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
    widget.board.lines.forEach((row) => rows.add(buildRow(row, tileSize)));
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: rows);
  }
}
