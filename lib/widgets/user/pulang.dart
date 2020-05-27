import 'package:flutter/material.dart';

Align pulang(width, height, int _pulang, data) {
  return Align(
    alignment: Alignment.centerRight,
    child: Container(
      width: width / 1.5,
      height: height / 7,
      color: Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text("Pulang :"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                (data['pulang'] != null) ? data['pulang'] : "Belum Pulang",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
