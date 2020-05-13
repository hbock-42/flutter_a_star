import 'package:flutter/material.dart';
import 'package:flutter_a_start/models/board.dart';

class BoardWidget extends StatelessWidget {
  final Board board;

  const BoardWidget({Key key, this.board}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: buildBoard(),
    );
  }

  Widget buildBoard() {}
}
