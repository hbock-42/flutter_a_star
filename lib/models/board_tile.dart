import 'dart:math';

import 'package:meta/meta.dart';

enum TileType {
  wall,
  empty,
}

class BoardTile {
  final Point position;
  final TileType type;

  const BoardTile({@required this.position, @required this.type});
}
