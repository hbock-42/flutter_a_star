import 'dart:math';

enum PacType {
  rock,
  paper,
  scissors,
}

class Pac {
  final int id;
  Point position;
  PacType type;
  int speedTurnLeft;
  int abilityCoolDown;
  Pac(
    this.id,
    this.position,
    this.type,
    this.speedTurnLeft,
    this.abilityCoolDown,
  );

  @override
  bool operator ==(other) {
    return super == (other) && other is Pac && id == other.id;
  }

  static PacType typeFromId(String id) {
    if (id == "ROCK") return PacType.rock;
    if (id == "PAPER") return PacType.paper;
    return PacType.scissors;
  }

  @override
  String toString() {
    return 'Pac $id is at $position, of type $type with $speedTurnLeft before speed end and $abilityCoolDown turn before he can use ability';
  }
}
