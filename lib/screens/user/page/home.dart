import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eparkir/screens/login.dart';
import 'package:eparkir/services/firestore/databaseReference.dart';
import 'package:eparkir/view-models/homeUserViewModel.dart';
import 'package:eparkir/widgets/user/home/type1/quote.dart';
import 'package:eparkir/widgets/user/home/type2/sudahScan.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class Home extends StatefulWidget {
  final String id;
  Home({this.id});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  HomeUserViewModel homeUserViewModel = HomeUserViewModel();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: ViewModelBuilder<HomeUserViewModel>.reactive(
        viewModelBuilder: () => homeUserViewModel,
        onModelReady: (model) => model.initState(widget.id),
        disposeViewModel: false,
        builder: (context, model, child) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: StreamBuilder(
              stream: databaseReference
                  .collection('siswa')
                  .document(widget.id)
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                bool hadir = (snapshot?.data != null)
                    ? snapshot.data.data['hadir']
                    : false;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[welcome(), logOut(model)]),
                    ),
                    (hadir)
                        ? type2(height, width, model)
                        : type1(height, width, model)
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  GestureDetector logOut(HomeUserViewModel model) {
    return GestureDetector(
      child: Column(
        children: <Widget>[
          Icon(
            Icons.highlight_off,
            color: Colors.red,
            size: 20,
          ),
          Text(
            "Log Out",
            style: TextStyle(color: Colors.red, fontSize: 10),
          )
        ],
      ),
      onTap: () {
        model.resetPref();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Login()),
          (Route<dynamic> route) => false,
        );
      },
    );
  }

  StreamBuilder welcome() {
    return StreamBuilder(
      stream:
          databaseReference.collection('siswa').document(widget.id).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          String nama =
              (snapshot.data.exists) ? snapshot.data.data['nama'] : '';
          return ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 250),
              child: Text(
                "Selamat Datang, $nama",
                overflow: TextOverflow.ellipsis,
              ));
        }
      },
    );
  }

  Widget type1(height, width, HomeUserViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        banner(width, height, model),
        quote(),
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
                onPressed: () => model.showQR(widget.id, context),
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

  StreamBuilder<DocumentSnapshot> type2(
      height, width, HomeUserViewModel model) {
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
          .document(widget.id)
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
                    ? sudahScan(height, width, 0)
                    : (data['pulang'] == null)
                        ? scanSebelumPulang(model)
                        : sudahScan(height, width, 1)
              ],
            ),
          );
        }
      },
    );
  }

  Padding scanSebelumPulang(HomeUserViewModel model) {
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
                    model.showQR(widget.id, context);
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
                style:
                    TextStyle(color: Colors.red, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
