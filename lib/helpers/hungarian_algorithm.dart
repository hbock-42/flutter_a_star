import 'dart:math';

// conversion of https://github.com/vivet/HungarianAlgorithm/blob/master/HungarianAlgorithm/HungarianAlgorithm.cs in dart

class HungarianAlgorithm {
  static const int _maxVal = 1000000000;
  static List<List<int>> _masks;
  static List<Location> _path;
  static Location _pathStart;

  static List<int> findAssignments(List<List<int>> costs) {
    var h = costs.length;
    var w = costs.length;

    for (var i = 0; i < h; i++) {
      var mini = _maxVal;
      for (var j = 0; j < w; j++) {
        mini = min(mini, costs[i][j]);
      }

      for (var j = 0; j < w; j++) {
        costs[i][j] -= mini;
      }
    }

    _masks = List<List<int>>.generate(h, (i) => List<int>.filled(w, 0));
    var rowsCovered = List<bool>.filled(h, false);
    var colsCovered = List<bool>.filled(w, false);

    for (var i = 0; i < h; i++) {
      for (var j = 0; j < w; j++) {
        if (costs[i][j] == 0 && !rowsCovered[i] && !colsCovered[j]) {
          _masks[i][j] = 1;
          rowsCovered[i] = true;
          colsCovered[j] = true;
        }
      }
    }
    _clearCovers(rowsCovered, colsCovered, w, h);
    _path = List<Location>.filled(w * h, Location(0, 0));
    _pathStart = Location(0, 0);
    var step = 1;

    while (step != -1) {
      switch (step) {
        case 1:
          step = _runStep1(colsCovered, w, h);
          break;

        case 2:
          step = _runStep2(costs, rowsCovered, colsCovered, w, h);
          break;

        case 3:
          step = _runStep3(rowsCovered, colsCovered, w, h);
          break;

        case 4:
          step = _runStep4(costs, rowsCovered, colsCovered, w, h);
          break;
      }
    }

    var agentsTasks = List<int>.filled(h, 0);
    for (var i = 0; i < h; i++) {
      for (var j = 0; j < w; j++) {
        if (_masks[i][j] == 1) {
          agentsTasks[i] = j;
          break;
        }
      }
    }
    return agentsTasks;
  }

  static int _runStep1(List<bool> colsCovered, int w, int h) {
    for (var i = 0; i < h; i++) {
      for (var j = 0; j < w; j++) {
        if (_masks[i][j] == 1) colsCovered[j] = true;
      }
    }

    var colsCoveredCount = 0;

    for (var j = 0; j < w; j++) {
      if (colsCovered[j]) colsCoveredCount++;
    }

    if (colsCoveredCount == h) return -1;

    return 2;
  }

  static int _runStep2(List<List<int>> costs, List<bool> rowsCovered,
      List<bool> colsCovered, int w, int h) {
    while (true) {
      var loc = _findZero(costs, rowsCovered, colsCovered, w, h);
      if (loc.row == -1) return 4;

      _masks[loc.row][loc.column] = 2;

      var starCol = _findStarInRow(w, loc.row);
      if (starCol != -1) {
        rowsCovered[loc.row] = true;
        colsCovered[starCol] = false;
      } else {
        _pathStart = loc;
        return 3;
      }
    }
  }

  static int _runStep3(
    List<bool> rowsCovered,
    List<bool> colsCovered,
    int w,
    int h,
  ) {
    var pathIndex = 0;
    _path[0] = _pathStart;

    while (true) {
      var row = _findStarInColumn(h, _path[pathIndex].column);
      if (row == -1) break;

      pathIndex++;
      _path[pathIndex] = Location(row, _path[pathIndex - 1].column);

      var col = _findPrimeInRow(w, _path[pathIndex].row);

      pathIndex++;
      _path[pathIndex] = Location(_path[pathIndex - 1].row, col);
    }

    _convertPath(pathIndex + 1);
    _clearCovers(rowsCovered, colsCovered, w, h);
    _clearPrimes(w, h);

    return 1;
  }

  static int _runStep4(List<List<int>> costs, List<bool> rowsCovered,
      List<bool> colsCovered, int w, int h) {
    var minValue = _findMinimum(costs, rowsCovered, colsCovered, w, h);

    for (var i = 0; i < h; i++) {
      for (var j = 0; j < w; j++) {
        if (rowsCovered[i]) costs[i][j] += minValue;
        if (!colsCovered[j]) costs[i][j] -= minValue;
      }
    }
    return 2;
  }

  static int _findMinimum(List<List<int>> costs, List<bool> rowsCovered,
      List<bool> colsCovered, int w, int h) {
    var minValue = _maxVal;

    for (var i = 0; i < h; i++) {
      for (var j = 0; j < w; j++) {
        if (!rowsCovered[i] && !colsCovered[j])
          minValue = min(minValue, costs[i][j]);
      }
    }

    return minValue;
  }

  static void _clearPrimes(int w, int h) {
    for (var i = 0; i < h; i++) {
      for (var j = 0; j < w; j++) {
        if (_masks[i][j] == 2) _masks[i][j] = 0;
      }
    }
  }

  static void _convertPath(int pathLength) {
    for (var i = 0; i < pathLength; i++) {
      if (_masks[_path[i].row][_path[i].column] == 1) {
        _masks[_path[i].row][_path[i].column] = 0;
      } else if (_masks[_path[i].row][_path[i].column] == 2) {
        _masks[_path[i].row][_path[i].column] = 1;
      }
    }
  }

  static int _findPrimeInRow(int w, int row) {
    for (var j = 0; j < w; j++) {
      if (_masks[row][j] == 2) return j;
    }

    return -1;
  }

  static int _findStarInColumn(int h, int col) {
    for (var i = 0; i < h; i++) {
      if (_masks[i][col] == 1) return i;
    }

    return -1;
  }

  static int _findStarInRow(int w, int row) {
    for (var j = 0; j < w; j++) {
      if (_masks[row][j] == 1) return j;
    }

    return -1;
  }

  static Location _findZero(List<List<int>> costs, List<bool> rowsCovered,
      List<bool> colsCovered, int w, int h) {
    for (var i = 0; i < h; i++) {
      for (var j = 0; j < w; j++) {
        if (costs[i][j] == 0 && !rowsCovered[i] && !colsCovered[j])
          return Location(i, j);
      }
    }

    return Location(-1, -1);
  }

  static void _clearCovers(
      List<bool> rowsCovered, List<bool> colsCovered, int w, int h) {
    for (var i = 0; i < h; i++) {
      rowsCovered[i] = false;
    }

    for (var j = 0; j < w; j++) {
      colsCovered[j] = false;
    }
  }
}

class Location {
  final int row;
  final int column;

  const Location(this.row, this.column);

  @override
  String toString() => '[$row,$column]';
}
