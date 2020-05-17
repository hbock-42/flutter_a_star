import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_a_start/helpers/optimal_paths.dart';
import 'package:flutter_a_start/models/board.dart';
import 'package:flutter_a_start/models/board_tile.dart';

class BoardWidget extends StatefulWidget {
  final int numberOfStart;
  final int numberOfEnd;
  final Board board;

  const BoardWidget({
    Key key,
    @required this.board,
    @required this.numberOfStart,
    @required this.numberOfEnd,
  }) : super(key: key);

  @override
  _BoardWidgetState createState() => _BoardWidgetState();
}

class _BoardWidgetState extends State<BoardWidget> {
  List<BoardTile> starts = List<BoardTile>();
  List<BoardTile> ends = List<BoardTile>();
  List<List<Point>> paths = List<List<Point>>();
  bool shouldReset = false;

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
    List<Point> flattenedPaths = paths.expand((i) => i).toList();
    Color tileColor =
        boardTile.type == TileType.wall ? Colors.grey : Colors.transparent;
    if (starts.contains(boardTile)) {
      tileColor = Colors.green;
    } else if (ends.contains(boardTile)) {
      tileColor = Colors.red;
    } else if (flattenedPaths.contains(boardTile.position)) {
      tileColor = Colors.blue;
    }
    return GestureDetector(
      onTap: () {
        if (starts.length < widget.numberOfStart) {
          setState(() {
            starts.add(boardTile);
            paths.add(List<Point>());
          });
        } else if (ends.length < widget.numberOfEnd) {
          setState(() => ends.add(boardTile));
        } else if (!shouldReset && ends.length == widget.numberOfEnd) {
          setState(() {
            var startsPosition = List<Point>();
            starts.forEach((elem) => startsPosition.add(elem.position));
            var endsPosition = List<Point>();
            ends.forEach((elem) => endsPosition.add(elem.position));
            var optimalPathInstance = OptimalPath(
                board: widget.board,
                starts: startsPosition,
                ends: endsPosition);
            paths = optimalPathInstance.computePaths();
            // for (var i = 0; i < widget.numberOfPath; i++) {
            //   var astar = AStar(
            //       board: widget.board,
            //       start: starts[i].position,
            //       end: ends[i].position);
            //   paths[i] = astar.calculatePath();
            // }
            shouldReset = true;
          });
        } else {
          setState(() {
            shouldReset = false;
            starts.clear();
            ends.clear();
            paths.clear();
          });
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
