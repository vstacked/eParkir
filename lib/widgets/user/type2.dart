import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eparkir/services/firestore/databaseReference.dart';
import 'package:eparkir/view-models/homeUserViewModel.dart';
import 'package:eparkir/widgets/user/datang.dart';
import 'package:eparkir/widgets/user/pulang.dart';
import 'package:eparkir/widgets/user/scanSebelumPulang.dart';
import 'package:eparkir/widgets/user/sudahScanType2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

StreamBuilder<DocumentSnapshot> type2(
    double height, double width, HomeUserViewModel model, String id) {
  int timeResult = 0;

  if (model.timeNow != null) {
    DateFormat dateFormat = new DateFormat.Hms();
    DateTime now = DateTime.now();
    DateTime open = dateFormat.parse(model.timeNow);
    open = new DateTime(now.year, now.month, now.day, open.hour, open.minute);
    DateTime close = dateFormat.parse("10:00:00");
    close =
        new DateTime(now.year, now.month, now.day, close.hour, close.minute);

    timeResult = open.difference(close).inMinutes;
  }
  return StreamBuilder(
    stream: databaseReference
        .collection('database')
        .document('tanggal')
        .collection(model.datePick)
        .document(id)
        .snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return Container();
      } else {
        int _pulang = 1;
        var data = snapshot.data.data;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              datang(width, height, data),
              pulang(width, height, _pulang, data),
              (timeResult < 0)
                  ? sudahScanType2(height, width, 0)
                  : (data['pulang'] == null)
                      ? scanSebelumPulang(model, id, context)
                      : sudahScanType2(height, width, 1)
            ],
          ),
        );
      }
    },
  );
}
