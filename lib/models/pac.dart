import 'dart:math';

class Pac {
  final int id;
  final Point position;
  const Pac(this.id, this.position);

  @override
  bool operator ==(other) {
    return super == (other) && other is Pac && id == other.id;
  }

  @override
  String toString() {
    return 'Pac $id is at $position';
  }
}
