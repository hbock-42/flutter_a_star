import 'dart:math';

import 'package:flutter_a_start/helpers/a_star.dart';
import 'package:flutter_a_start/helpers/hungarian_algorithm.dart';
import 'package:meta/meta.dart';
import 'package:flutter_a_start/models/board.dart';
import 'package:flutter_a_start/models/pac.dart';

class OptimalPath {
  final Board board;
  final List<Point> starts;
  final List<Point> ends;
  List<Pac> allies;
  List<Pac> ennemies;
  List<List<List<Point>>> _paths;

  OptimalPath({
    @required this.board,
    @required this.starts,
    @required this.ends,
    List<Pac> allies,
    List<Pac> ennemies,
  });

  List<List<Point>> computePaths() {
    var paths = List<List<Point>>();
    var costs = _computeCosts();
    var result = HungarianAlgorithm.findAssignments(costs);

    for (int i = 0; i < result.length; i++) {
      paths.add(_paths[result[i]][i]);
    }
    return paths;
  }

  List<List<int>> _computeCosts() {
    var costs = List<List<int>>.generate(
        ends.length, (i) => List<int>(starts.length),
        growable: false);
    _paths = List<List<List<Point>>>.generate(
        ends.length, (i) => List<List<Point>>(starts.length),
        growable: false);
    for (var h = 0; h < ends.length; h++) {
      for (var w = 0; w < starts.length; w++) {
        var astar = AStar(
          board: board,
          start: starts[w],
          end: ends[h],
          allies: allies,
          ennemies: ennemies,
        );
        _paths[h][w] = astar.calculatePath();
        costs[h][w] = _paths[h][w].length;
      }
    }
    return costs;
  }
}
