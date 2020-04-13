import 'package:flutter/material.dart';

Align banner(width, height) {
  return Align(
    alignment: Alignment.centerRight,
    child: Container(
      width: width / 1.5,
      height: height / 3,
      color: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Sekarang Pukul :"),
            Text(
              "06.50",
              style: TextStyle(fontSize: 40),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "10 menit lagi kamu akan terlambat!",
              style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    ),
  );
}
