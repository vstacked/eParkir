import 'package:eparkir/view-models/homeUserViewModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Align banner(width, height, HomeUserViewModel model) {
  int timeResult = 0;
  if (model.timeNow != null) {
    DateFormat dateFormat = new DateFormat.Hms();
    DateTime now = DateTime.now();
    DateTime open = dateFormat.parse(model.timeNow);
    open = new DateTime(now.year, now.month, now.day, open.hour, open.minute);
    DateTime close = dateFormat.parse("07:00:00");
    close =
        new DateTime(now.year, now.month, now.day, close.hour, close.minute);

    timeResult = open.difference(close).inMinutes;
  }

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
              model.timeNow ?? '',
              style: TextStyle(fontSize: 40),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              (timeResult > 0)
                  ? "Kamu terlambat :("
                  : "${timeResult.abs()} menit lg km terlambat!",
              style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    ),
  );
}
