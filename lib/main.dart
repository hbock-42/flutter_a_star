import 'package:flutter/material.dart';
import 'package:flutter_a_start/models/board.dart';
import 'package:flutter_a_start/widgets/board_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    Board.parseRow("##### ##   #", 2);
    return BoardWidget(
      board: Board.random(
        30,
        25,
        0.2,
        hasHorizontalTunnel: true,
        hasVerticalTunnel: true,
      ),
    );
  }
}
