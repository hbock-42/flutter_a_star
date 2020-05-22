import 'dart:io';
import 'dart:math';

import 'package:flutter_a_start/helpers/a_star.dart';
import 'package:flutter_a_start/helpers/optimal_paths.dart';
import 'package:flutter_a_start/models/board.dart';
import 'package:flutter_a_start/models/board_tile.dart';
import 'package:flutter_a_start/models/pac.dart';

class GameManager {
  static Board board;
  static List<Point> pellets = List<Point>();
  static List<Point> superPellets = List<Point>();
  static List<Pac> myPacs = List<Pac>();
  static List<Pac> enemyPacs = List<Pac>();
  static List<Pac> assignedAllyPacs = List<Pac>();
  static List<Pac> assignedEnemyPacs = List<Pac>();
  static List<Point> assignedSuperPellets = List<Point>();
  static List<Point> assignedPellets = List<Point>();
  static Map<Pac, Point> assignments = Map<Pac, Point>();
  static List<Point> _remaining = List<Point>();
  static List<Point> unVisitedPositions = List<Point>();
  static bool isFirstTurn = true;

  static List<Point> listAllyPacsPosition() {
    var positions = List<Point>();
    if (myPacs != null) {
      myPacs.forEach((pac) => positions.add(pac.position));
    }
    // if (enemyPacs != null) {
    //   enemyPacs.forEach((pac) => positions.add(pac.position));
    // }
    return positions;
  }

  static void computeUnVisitedPositions() {
    for (var row in board.lines) {
      for (var tile in row) {
        if (tile.type == TileType.empty) {
          unVisitedPositions.add(tile.position);
        }
      }
    }
  }

  // static List<Point> listRemainingAllyAndEnemyPositions() {
  //   var positions = List<Point>();
  //   if (myPacs != null) {
  //     myPacs.forEach((pac) {
  //       if (!assignedAllyPacs.contains(pac)) {
  //         positions.add(pac.position);
  //       }
  //     });
  //   }
  //   if (enemyPacs != null) {
  //     enemyPacs.forEach((pac) {
  //       if (assignedEnemyPacs.contains(pac)) {
  //         positions.add(pac.position);
  //       }
  //     });
  //   }
  //   return positions;
  // }

  static void _assignPathsForSuperPellets() {
    if (_remaining.length <= 0 || superPellets.length <= 0) return;
    var optimalPathInstance = OptimalPath(
      board: board,
      starts: _remaining,
      ends: superPellets,
    );
    List<List<Point>> paths = optimalPathInstance.computePaths();
    for (var h = 0; h < paths.length; h++) {
      for (var i = 0; i < myPacs.length; i++) {
        if (myPacs[i].position == paths[h].first) {
          assignedAllyPacs.add(myPacs[i]);
          _remaining.remove(myPacs[i].position);
          assignments[myPacs[i]] = paths[h][1];
          break;
        }
      }
      // for (var i = 0; i < enemyPacs.length; i++) {
      //   if (enemyPacs[i].position == paths[h].first) {
      //     assignedEnemyPacs.add(enemyPacs[i]);
      //     remaining.remove(enemyPacs[i].position);
      //     break;
      //   }
      // }
      for (var i = 0; i < superPellets.length; i++) {
        if (superPellets[i] == paths[h].last) {
          assignedSuperPellets.add(superPellets[i]);
          break;
        }
      }
    }
  }

  static bool _containsAllyPacsPosition(List<Point> positions) {
    for (var ally in myPacs) {
      if (positions.contains(ally.position)) {
        return true;
      }
    }
    return false;
  }

  // static void _assignPathsForPellets() {
  //   if (remaining.length <= 0 ||
  //       pellets.length <= 0 ||
  //       !_containsAllyPacsPosition(remaining)) return;
  //   var optimalPathInstance = OptimalPath(
  //     board: board,
  //     starts: remaining,
  //     ends: pellets,
  //   );
  //   List<List<Point>> paths = optimalPathInstance.computePaths();
  //   for (var h = 0; h < paths.length; h++) {
  //     for (var i = 0; i < myPacs.length; i++) {
  //       if (myPacs[i].position == paths[h].first) {
  //         assignedAllyPacs.add(myPacs[i]);
  //         assignments[myPacs[i]] = paths[h][1];
  //         remaining.remove(myPacs[i].position);
  //         break;
  //       }
  //     }
  //     // for (var i = 0; i < enemyPacs.length; i++) {
  //     //   if (enemyPacs[i].position == paths[h].first) {
  //     //     assignedEnemyPacs.add(enemyPacs[i]);
  //     //     remaining.remove(enemyPacs[i].position);
  //     //     break;
  //     //   }
  //     // }
  //     for (var i = 0; i < pellets.length; i++) {
  //       if (pellets[i] == paths[h].last) {
  //         assignedPellets.add(pellets[i]);
  //         break;
  //       }
  //     }
  //   }
  // }

  static void _assignPathsForPellets() {
    if (_remaining.length <= 0 ||
        pellets.length <= 0 ||
        !_containsAllyPacsPosition(_remaining)) return;
    var optimalPathInstance = OptimalPath(
      board: board,
      starts: _remaining,
      ends: pellets,
    );
    // List<List<Point>> paths = optimalPathInstance.computePaths();
    List<List<Point>> targets = optimalPathInstance.computeNaiveTargets();
    for (var h = 0; h < targets.length; h++) {
      for (var i = 0; i < myPacs.length; i++) {
        if (myPacs[i].position == targets[h].first) {
          assignedAllyPacs.add(myPacs[i]);
          assignments[myPacs[i]] = targets[h].last;
          _remaining.remove(myPacs[i].position);
          break;
        }
      }
    }

    // for (var h = 0; h < paths.length; h++) {
    //   for (var i = 0; i < myPacs.length; i++) {
    //     if (myPacs[i].position == paths[h].first) {
    //       assignedAllyPacs.add(myPacs[i]);
    //       assignments[myPacs[i]] = paths[h][1];
    //       remaining.remove(myPacs[i].position);
    //       break;
    //     }
    //   }
    //   for (var i = 0; i < pellets.length; i++) {
    //     if (pellets[i] == paths[h].last) {
    //       assignedPellets.add(pellets[i]);
    //       break;
    //     }
    //   }
    // }
  }

  static void _assignRemainings() {
    if (_remaining.length <= 0 || unVisitedPositions.length <= 0) return;
    var optimalPathInstance = OptimalPath(
      board: board,
      starts: _remaining,
      ends: unVisitedPositions,
    );
    List<List<int>> costs = optimalPathInstance.computeNaiveCost();
    for (var h = 0; h < costs.length; h++) {
      int winnerCost;
      Point target;
      for (var i = 0; i < costs[h].length; i++) {
        if (winnerCost == null || costs[h][i] < winnerCost) {
          winnerCost = costs[h][i];
          target = unVisitedPositions[i];
        }
      }

      Pac myP = myPacs.firstWhere((pac) => pac.position == _remaining[h]);

      assignedAllyPacs.add(myP);
      assignments[myP] = target;
    }
    for (var mp in assignedAllyPacs) {
      if (_remaining.contains(mp.position)) {
        _remaining.remove(mp.position);
      }
    }
  }

  static void removeFromUnVisited() {
    for (var pac in myPacs) {
      unVisitedPositions.remove(pac.position);
    }
    for (var pac in enemyPacs) {
      unVisitedPositions.remove(pac.position);
    }
  }

  static void _correctSameAssignments() {
    var enemiesPos = List<Point>();
    enemyPacs.forEach((enemy) => enemiesPos.add(enemy.position));
    for (Pac pac1 in assignments.keys) {
      for (Pac pac2 in assignments.keys) {
        if (pac1 != pac2 &&
            assignments[pac1] == assignments[pac2] &&
            distance(pac1.position, pac2.position) <= 2) {
          bool newPac1AssignmentFound = false;
          bool newPac2AssignmentFound = false;
          Point newPos;
          bool pac2LeftPac1 = pac2.position.x < pac1.position.x;
          bool pac2TopPac1 = pac2.position.y < pac1.position.y;
          if (pac2LeftPac1) {
            newPos =
                convertForTunnelUseIfPossible(pac2.position + Point(-1, 0));
            if (isValidPoint(newPos) && !enemiesPos.contains(newPos)) {
              newPac2AssignmentFound = true;
            }
          }

          if (!pac2LeftPac1 && !newPac2AssignmentFound) {
            newPos = convertForTunnelUseIfPossible(pac2.position + Point(1, 0));
            if (isValidPoint(newPos) && !enemiesPos.contains(newPos)) {
              newPac2AssignmentFound = true;
            }
          }

          if (pac2TopPac1 && !newPac2AssignmentFound) {
            newPos =
                convertForTunnelUseIfPossible(pac2.position + Point(0, -1));
            if (isValidPoint(newPos) && !enemiesPos.contains(newPos)) {
              newPac2AssignmentFound = true;
            }
          }

          if (!pac2TopPac1 && !newPac2AssignmentFound) {
            newPos = convertForTunnelUseIfPossible(pac2.position + Point(0, 1));
            if (isValidPoint(newPos) && !enemiesPos.contains(newPos)) {
              newPac2AssignmentFound = true;
            }
          }

          if (!pac2LeftPac1 && !newPac2AssignmentFound) {
            newPos =
                convertForTunnelUseIfPossible(pac1.position + Point(-1, 0));
            if (isValidPoint(newPos) && !enemiesPos.contains(newPos)) {
              newPac1AssignmentFound = true;
            }
          }

          if (pac2LeftPac1 &&
              !newPac2AssignmentFound &&
              !newPac1AssignmentFound) {
            newPos = convertForTunnelUseIfPossible(pac1.position + Point(1, 0));
            if (isValidPoint(newPos) && !enemiesPos.contains(newPos)) {
              newPac1AssignmentFound = true;
            }
          }

          if (!pac2TopPac1 &&
              !newPac2AssignmentFound &&
              !newPac1AssignmentFound) {
            newPos =
                convertForTunnelUseIfPossible(pac1.position + Point(0, -1));
            if (isValidPoint(newPos) && !enemiesPos.contains(newPos)) {
              newPac1AssignmentFound = true;
            }
          }

          if (pac2TopPac1 &&
              !newPac2AssignmentFound &&
              !newPac1AssignmentFound) {
            newPos = convertForTunnelUseIfPossible(pac1.position + Point(0, 1));
            if (isValidPoint(newPos) && !enemiesPos.contains(newPos)) {
              newPac1AssignmentFound = true;
            }
          }

          if (newPac2AssignmentFound) {
            assignments[pac2] = newPos;
          } else if (newPac1AssignmentFound) {
            assignments[pac1] = newPos;
          }
        }
      }
    }
  }

  static void computeAssignments() {
    _remaining = listAllyPacsPosition();
    _assignPathsForSuperPellets();
    _assignPathsForPellets();
    _assignRemainings();
    _correctSameAssignments();
  }

  static void clearDatas() {
    pellets?.clear();
    superPellets?.clear();
    myPacs?.clear();
    enemyPacs?.clear();
    assignedAllyPacs?.clear();
    assignedEnemyPacs?.clear();
    assignedSuperPellets?.clear();
    assignedPellets?.clear();
    assignments?.clear();
    _remaining?.clear();
  }

  static int turnsBeforeTouch(Pac ally, Pac ennemy) {
    var dist = distance(ally.position, ennemy.position);
    var realDist = dist - dist * ennemy.speedTurnLeft;
    return realDist;
  }

  static int distance(Point a, Point b) {
    var astar = AStar(
      board: board,
      start: a,
      end: b,
    );
    return astar.calculatePath().length - 1;
  }

  static bool iWin(Pac ally, Pac ennemy) {
    if (ally.type == PacType.paper && ennemy.type == PacType.rock) return true;
    if (ally.type == PacType.rock && ennemy.type == PacType.scissors)
      return true;
    if (ally.type == PacType.scissors && ennemy.type == PacType.paper)
      return true;
    return false;
  }

  static String getWinningAbility(Pac ennemy) {
    if (ennemy.type == PacType.paper)
      return "SCISSORS";
    else if (ennemy.type == PacType.scissors)
      return "ROCK";
    else
      return "PAPER";
  }

  static bool isValidPoint(Point position) {
    if (position.x < 0 ||
        position.y < 0 ||
        position.x >= board.width ||
        position.y >= board.height) {
      return false;
    }
    return board.lines[position.y][position.x].type == TileType.empty;
  }

  static Point convertForTunnelUseIfPossible(Point newP) {
    if (board.hasHorizontalTunnel) {
      if (newP.x < 0 && board.horizontalTunnelPositions.contains(newP.y)) {
        newP = Point(board.width - 1, newP.y);
      } else if (newP.x == board.width &&
          board.horizontalTunnelPositions.contains(newP.y)) {
        newP = Point(0, newP.y);
      }
    }

    if (board.hasVerticalTunnel) {
      if (newP.y < 0 && board.verticalTunnelPositions.contains(newP.x)) {
        newP = Point(newP.x, board.height - 1);
      } else if (newP.y == board.height &&
          board.verticalTunnelPositions.contains(newP.x)) {
        newP = Point(newP.x, 0);
      }
    }
    return newP;
  }

  static String getCommand() {
    String command;
    for (MapEntry<Pac, Point<num>> entry in assignments.entries) {
      Pac me = entry.key;
      String ability = "MOVE";
      if (isFirstTurn) {
        if (me.abilityCoolDown == 0) {
          ability = "SPEED";
        }
      }
      String type;
      Point newPosition = entry.value;
      for (var ennemy in enemyPacs) {
        bool win = iWin(me, ennemy);
        int dist = distance(me.position, ennemy.position);
        if (dist <= 3 && !win) {
          if (me.abilityCoolDown == 0) {
            ability = 'SWITCH';
            type = getWinningAbility(ennemy);
          } else {
            Point newPos = me.position;
            bool canGoLeft = me.position.x < ennemy.position.x;
            bool canGoTop = me.position.y < ennemy.position.y;
            Point tmp;
            bool newPoseFound = false;
            if (canGoLeft) {
              tmp = convertForTunnelUseIfPossible(newPos + Point(-1, 0));
              if (isValidPoint(tmp)) {
                newPos = tmp;
                newPoseFound = true;
              }
            }
            if (!newPoseFound && !canGoLeft) {
              tmp = convertForTunnelUseIfPossible(newPos + Point(1, 0));
              if (isValidPoint(tmp)) {
                newPos = tmp;
                newPoseFound = true;
              }
            }
            if (!newPoseFound && !canGoTop) {
              tmp = convertForTunnelUseIfPossible(newPos + Point(0, 1));
              if (isValidPoint(tmp)) {
                newPos = tmp;
                newPoseFound = true;
              }
            }
            if (!newPoseFound && canGoTop) {
              tmp = convertForTunnelUseIfPossible(newPos + Point(0, -1));
              if (isValidPoint(tmp)) {
                newPos = tmp;
                newPoseFound = true;
              }
            }
            if (newPoseFound) {
              newPosition = newPos;
            }
          }
          break;
        } else if (dist <= 3 && win && me.abilityCoolDown == 0) {
          ability = 'SPEED';
          break;
        }
      }
      if (command == null) {
        command = com(ability, entry.key.id, type, newPosition, true);
      } else {
        command += com(ability, entry.key.id, type, newPosition, false);
      }
    }
    isFirstTurn = false;
    return command;
  }

  static String com(
      String command, int pacId, String type, Point position, bool first) {
    if (command == "MOVE") return moveCommand(pacId, position, first);
    if (command == "SWITCH") return switchCommand(pacId, type, first);
    if (command == "SPEED") return speedCommand(pacId, first);
    return 'oups';
  }

  static String moveCommand(int pacId, Point position, bool first) =>
      "${first ? "" : " | "}MOVE $pacId ${position.x} ${position.y}";
  static String switchCommand(int pacId, String type, bool first) =>
      "${first ? "" : " | "}SWITCH $pacId $type";
  static String speedCommand(int pacId, bool first) =>
      "${first ? "" : " | "}SPEED $pacId";

  static void debug(String message) => stderr.writeln(message);
}
