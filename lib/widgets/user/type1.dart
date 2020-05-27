import 'package:eparkir/view-models/homeUserViewModel.dart';
import 'package:eparkir/widgets/user/banner.dart';
import 'package:eparkir/widgets/user/quoteType1.dart';
import 'package:flutter/material.dart';

Widget type1(double height, double width, HomeUserViewModel model, String id,
    BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      banner(width, height, model),
      quoteType1(),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Center(
            child: Text(
          "Kamu belum scan :(",
          style: TextStyle(color: Colors.red),
        )),
      ),
      Center(
        child: Column(
          children: <Widget>[
            FlatButton(
              onPressed: () => model.showQR(id, context),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Icon(
                  Icons.code,
                  color: Colors.white,
                  size: 50.0,
                ),
              ),
              shape: new CircleBorder(),
              color: Colors.blue,
            ),
            Text(
              "Tap untuk scan",
              style: TextStyle(fontSize: 10),
            )
          ],
        ),
      )
    ],
  );
}
