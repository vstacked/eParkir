import 'package:eparkir/utils/textStyle.dart';
import 'package:eparkir/view-models/homeUserViewModel.dart';
import 'package:flutter/material.dart';

class BannerType1 extends StatelessWidget {
  BannerType1(
      {this.width,
      this.height,
      this.model,
      @required this.open,
      @required this.timeNow});
  final double width;
  final double height;
  final HomeUserViewModel model;
  final DateTime open;
  final String timeNow;
  @override
  Widget build(BuildContext context) {
    TxtStyle style = TxtStyle();
    DateTime close = model.dateFormat.parse("07:00:00");
    close = new DateTime(model.now.year, model.now.month, model.now.day,
        close.hour, close.minute);
    int timeResult = open.difference(close).inMinutes;
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
              timeNow,
              style: style.desc.copyWith(fontSize: 40),
            ),
            Text(
              (timeResult > -1)
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
}
