import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eparkir/screens/login.dart';
import 'package:eparkir/screens/user/page/showQr.dart';
import 'package:eparkir/services/firestore/databaseReference.dart';
import 'package:eparkir/widgets/user/home/type1/quote.dart';
import 'package:eparkir/widgets/user/home/type2/sudahScan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

class Home extends StatefulWidget {
  final String id;
  Home({this.id});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String text = "Belum Pulang";
  String resul11t = "";
  int checkType;
  void press() {
    setState(() {
      text = "15.40";
    });
  }

  String datePick = DateFormat('dd-MM-yyyy').format(DateTime.now());

  void resetPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt("value", 2);
    preferences.setString("id", '');
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ShowQr()),
    );

    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text("$result")));

    setState(() {
      resul11t = result;
    });
  }

  String timeNow;
  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
  }

  _getTime() {
    String _timeNow = DateFormat('Hms').format(DateTime.now());
    if (mounted)
      setState(() {
        timeNow = _timeNow;
      });
  }

  Future<ui.Image> _loadOverlayImage() async {
    final completer = Completer<ui.Image>();
    final byteData = await rootBundle.load('assets/images/4.0x/logo_yakka.png');
    ui.decodeImageFromList(byteData.buffer.asUint8List(), completer.complete);
    return completer.future;
  }

  final message =
      // ignore: lines_longer_than_80_chars
      '17006912';

  void showQR(idUser) async {
    String nis;
    var test2 =
        databaseReference.collection('siswa').document(idUser).snapshots();
    test2.forEach((data) {
      bool check = data.data['hadir'];
      setState(() {
        nis = data.data['nis'];
        checkType = (check) ? 2 : 1;
      });
    });
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("QR Code"),
            content: Container(
              width: 280,
              child: FutureBuilder(
                future: _loadOverlayImage(),
                builder: (ctx, snapshot) {
                  final size = 280.0;
                  if (!snapshot.hasData) {
                    return Container(width: size, height: size);
                  }
                  return CustomPaint(
                    size: Size.square(size),
                    painter: QrPainter(
                      data: nis,
                      version: QrVersions.auto,
                      color: Color(0xff1a5441),
                      emptyColor: Color(0xffeafcf6),
                      // size: 320.0,
                      embeddedImage: snapshot.data,
                      embeddedImageStyle: QrEmbeddedImageStyle(
                        size: Size.square(60),
                      ),
                    ),
                  );
                },
              ),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.blue,
                child: Text("Close"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[welcome(), logOut()]),
            ),
            (checkType == 1) ? type1(height, width) : type2(height, width)
          ],
        ),
      ),
    );
  }

  GestureDetector logOut() {
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
        resetPref();
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

  Widget type1(height, width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        banner(width, height),
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
                onPressed: () {
                  // _navigateAndDisplaySelection(context);
                  showQR(widget.id);
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
    );
  }

  StreamBuilder<DocumentSnapshot> type2(height, width) {
    int timeResult = 0;

    if (timeNow != null) {
      DateFormat dateFormat = new DateFormat.Hms();
      DateTime now = DateTime.now();
      DateTime open = dateFormat.parse(timeNow);
      open = new DateTime(now.year, now.month, now.day, open.hour, open.minute);
      DateTime close = dateFormat.parse("10:00:00");
      close =
          new DateTime(now.year, now.month, now.day, close.hour, close.minute);

      setState(() {
        timeResult = open.difference(close).inMinutes;
      });
    }
    return StreamBuilder(
      stream: databaseReference
          .collection('database')
          .document('tanggal')
          .collection(datePick)
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
                        ? scanSebelumPulang()
                        : sudahScan(height, width, 1)
              ],
            ),
          );
        }
      },
    );
  }

  Padding scanSebelumPulang() {
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
                    showQR(widget.id);
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
                  data['datang'],
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Align banner(width, height) {
    int timeResult = 0;
    if (timeNow != null) {
      DateFormat dateFormat = new DateFormat.Hms();
      DateTime now = DateTime.now();
      DateTime open = dateFormat.parse(timeNow);
      open = new DateTime(now.year, now.month, now.day, open.hour, open.minute);
      DateTime close = dateFormat.parse("07:00:00");
      close =
          new DateTime(now.year, now.month, now.day, close.hour, close.minute);
      setState(() {
        timeResult = open.difference(close).inMinutes;
      });
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
                timeNow ?? '',
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
