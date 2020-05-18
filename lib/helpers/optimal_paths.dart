import 'dart:math';

import 'package:flutter_a_start/helpers/a_star.dart';
import 'package:flutter_a_start/helpers/hungarian_algorithm.dart';
import 'package:meta/meta.dart';
import 'package:flutter_a_start/models/board.dart';
import 'package:flutter_a_start/models/pac.dart';
import 'package:flutter_a_start/helpers/list_extension.dart';

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
    List<List<int>> costs = _computeCosts();

    if (costs.length != costs.first.length) {
      costs = costs.squareArray();
    }
    var result = HungarianAlgorithm.findAssignments(costs);

    for (int i = 0; i < starts.length; i++) {
      if (result[i] < ends.length) {
        paths.add(_paths[i][result[i]]);
      }
    }
    return paths;
  }

  List<List<int>> _computeCosts() {
    var costs = List<List<int>>.generate(
        starts.length, (i) => List<int>(ends.length),
        growable: false);
    _paths = List<List<List<Point>>>.generate(
        starts.length, (i) => List<List<Point>>(ends.length),
        growable: false);
    for (var h = 0; h < starts.length; h++) {
      for (var w = 0; w < ends.length; w++) {
        var astar = AStar(
          board: board,
          start: starts[h],
          end: ends[w],
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
