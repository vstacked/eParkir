import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eparkir/services/firestore/databaseReference.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'dart:ui' as ui;

class HomeUserViewModel extends BaseViewModel {
  int _checkType;
  String timeNow;

  String datePick = DateFormat('dd-MM-yyyy').format(DateTime.now());

  get checkType => _checkType;

  void initState(String id) {
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());

    notifyListeners();
  }

  _getTime() {
    String _timeNow = DateFormat('Hms').format(DateTime.now());

    timeNow = _timeNow;
    notifyListeners();
  }

  Future<ui.Image> _loadOverlayImage() async {
    final completer = Completer<ui.Image>();
    final byteData = await rootBundle.load('assets/images/4.0x/logo_yakka.png');
    ui.decodeImageFromList(byteData.buffer.asUint8List(), completer.complete);
    return completer.future;
  }

  void showQR(idUser, BuildContext context) async {
    String nis;
    var test2 =
        databaseReference.collection('siswa').document(idUser).snapshots();
    test2.forEach((data) {
      bool check = data.data['hadir'];

      nis = data.data['nis'];
      _checkType = (check) ? 2 : 1;

      notifyListeners();
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
}
