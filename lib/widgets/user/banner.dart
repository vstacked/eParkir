import 'package:eparkir/utils/textStyle.dart';
import 'package:eparkir/view-models/homeUserViewModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Align banner(width, height, HomeUserViewModel model) {
  TxtStyle style = TxtStyle();
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
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(-2.5, 2.5),
            blurRadius: 2.5,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            "Sekarang Pukul",
            style: style.desc.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            model.timeNow ?? '',
            style: style.desc.copyWith(fontSize: 40),
          ),
          Text(
            (timeResult > 0)
                ? "Kamu Terlambat"
                : "${timeResult.abs()} menit lagi Kamu terlambat!",
            style: style.desc.copyWith(
                color: Colors.red,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w800),
          ),
        ],
      ),
    ),
  );
}
