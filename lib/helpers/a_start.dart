import 'dart:math';

import 'package:meta/meta.dart';
import 'package:flutter_a_start/models/board.dart';

class AStar {
  final Board board;
  final Point start;
  final Point end;

  const AStar({@required this.board, @required this.start, @required this.end});
}
