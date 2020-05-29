import 'package:eparkir/widgets/common/history.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  Color color = Colors.teal[100];
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData().copyWith(color: Colors.teal),
        elevation: 0,
        title: Text(
          "History",
          style: TextStyle(color: Colors.teal, fontFamily: 'Lemonada'),
        ),
        backgroundColor: color,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: height,
            width: width,
            color: color,
          ),
          HistoryBody(
            height: height,
            width: width,
          ),
        ],
      ),
    );
  }
}
