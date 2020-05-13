import 'dart:math';

import 'package:flutter_a_start/models/board_tile.dart';
import 'package:meta/meta.dart';
import 'package:flutter_a_start/models/board.dart';

class AStar {
  final Board board;
  final Point start;
  final Point end;
  List<Point> path;
  Random rand;

  AStar({@required this.board, @required this.start, @required this.end});

  List<Point> calculatePath() {
    print("start:$start");
    print("end:$end");
    rand = Random.secure();
    Set<Point> openSet = Set<Point>();
    openSet.add(start);

    var cameFrom = Map<Point, Point>();

    var gScores = Map<Point, double>();
    gScores[start] = 0;

    var fScores = Map<Point, double>();
    fScores[start] = minCostToEnd(start);

    while (openSet.length > 0) {
      Point<num> current = getPointWithLowestFscore(openSet, fScores);
      print(cameFrom);
      if (current == end) {
        return _reconstructPath(cameFrom, current);
      }
      openSet.remove(current);
      List<Point> neighbors = _getNeighbors(current);
      print("neigbors: " + neighbors.toString());
      for (var neighbor in neighbors) {
        var tentativeGScore = gScores[current] + 1;
        if (!gScores.containsKey(neighbor)) {
          gScores[neighbor] = double.maxFinite;
        }
        if (tentativeGScore < gScores[neighbor]) {
          cameFrom[neighbor] = current;
          gScores[neighbor] = tentativeGScore;
          fScores[neighbor] = gScores[neighbor] + minCostToEnd(neighbor);
          if (!openSet.contains(neighbor)) {
            openSet.add(neighbor);
          }
        }
      }
    }
    return List<Point>();
  }

  List<Point> _getNeighbors(Point current) {
    var possibleNeighbors = List<Point>();
    possibleNeighbors.add(current + Point(0, -1));
    possibleNeighbors.add(current + Point(0, 1));
    possibleNeighbors.add(current + Point(-1, 0));
    possibleNeighbors.add(current + Point(1, 0));
    var neighbors = List<Point>();
    for (var point in possibleNeighbors) {
      if (_isValidPointPath(point)) {
        neighbors.add(point);
      }
    }
    return neighbors;
  }

  bool _isValidPointPath(Point point) {
    if (point.x < 0 ||
        point.y < 0 ||
        point.x >= board.width ||
        point.y >= board.height) {
      return false;
    }

    if (board.lines[point.y][point.x].type == TileType.wall) {
      return false;
    }

    return true;
  }

  List<Point> _reconstructPath(Map<Point, Point> cameFrom, Point current) {
    var totalPath = [current];
    while (cameFrom.containsKey(current)) {
      current = cameFrom[current];
      totalPath.insert(0, current);
    }
    return totalPath;
  }

  Point getPointWithLowestFscore(
      Set<Point> openSet, Map<Point, double> fScores) {
    Point<num> winner = openSet.first;
    openSet.forEach((point) {
      if (fScores[point] < fScores[winner]) {
        winner = point;
      } else if (fScores[point] == fScores[winner] && rand.nextBool()) {
        // we change the winner randomly so if there is multiple path with the same score
        // this is not always the same that will win
        winner = point;
      }
    });
    return winner;
  }

  double minCostToEnd(Point point) =>
      (end.x - point.x).abs().toDouble() + (end.y - point.y).abs().toDouble();
}
