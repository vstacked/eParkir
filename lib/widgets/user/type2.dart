import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eparkir/services/firestore.dart';
import 'package:eparkir/utils/textStyle.dart';
import 'package:eparkir/view-models/homeUserViewModel.dart';
import 'package:eparkir/widgets/user/scanSebelumPulang.dart';
import 'package:eparkir/widgets/user/sudahScanType2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

StreamBuilder<DocumentSnapshot> type2(
    double height, double width, HomeUserViewModel model, String id) {
  int timeResult = 0;
  TxtStyle style = TxtStyle();
  FirestoreServices services = FirestoreServices();

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
    stream: services.getUserTime(model.datePick, id),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return Container();
      } else {
        var data = snapshot.data.data;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              Container(
                height: 150,
                width: width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.2, 0.2),
                        blurRadius: 0.5,
                        spreadRadius: 0.5,
                      )
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          'Datang',
                          style: style.desc.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.lightGreen,
                          ),
                        ),
                        Text(
                          (data['datang'] != null)
                              ? data['datang']
                              : "Belum Datang",
                          style: style.desc.copyWith(
                            fontSize: 20,
                            color: Colors.lightGreen,
                          ),
                        )
                      ],
                    ),
                    VerticalDivider(
                      color: Colors.teal,
                      thickness: 1,
                      endIndent: 20,
                      indent: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          'Pulang',
                          style: style.desc.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        Text(
                          (data['pulang'] != null)
                              ? data['pulang']
                              : "Belum Pulang",
                          style: style.desc.copyWith(
                            fontSize: 20,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 75,
              ),
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
