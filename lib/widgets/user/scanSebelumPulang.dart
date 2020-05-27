import 'package:eparkir/view-models/homeUserViewModel.dart';
import 'package:flutter/material.dart';

Padding scanSebelumPulang(
    HomeUserViewModel model, String id, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 40),
    child: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: Center(
              child: Text(
            "Scan sebelum pulang!",
            style: TextStyle(color: Colors.red),
          )),
        ),
        Center(
          child: Column(
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  model.showQR(id, context);
                },
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
    ),
  );
}
