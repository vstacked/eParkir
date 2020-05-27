import 'package:flutter/material.dart';

Padding datang(width, height, data) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 30.0),
    child: Container(
      width: width / 1.5,
      height: height / 7,
      color: Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text("Datang :"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                (data['datang'] != null) ? data['datang'] : "Belum Datang",
                style: TextStyle(fontSize: 40),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
