import 'package:eparkir/utils/color.dart';
import 'package:eparkir/utils/textStyle.dart';
import 'package:eparkir/widgets/common/history.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
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
          style: TxtStyle().title.copyWith(color: Colors.teal),
        ),
        backgroundColor: ColorApp().colorTeal100,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: height,
            width: width,
            color: ColorApp().colorTeal100,
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
