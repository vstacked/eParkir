import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eparkir/services/firestore.dart';
import 'package:eparkir/utils/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:stacked/stacked.dart';
import 'dart:ui' as ui;

class HomeUserViewModel extends BaseViewModel {
  int _checkType;
  String timeNow;

  FirestoreServices services = FirestoreServices();
  TxtStyle style = TxtStyle();

  String datePick = DateFormat('dd-MM-yyyy').format(DateTime.now());

  get checkType => _checkType;

  void initState(String id, BuildContext context) {
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    checkDay();
    checkTransport(id, context);
    notifyListeners();
  }

  _getTime() {
    String _timeNow = DateFormat('Hms').format(DateTime.now());

    timeNow = _timeNow;
    notifyListeners();
  }

  checkTransport(String id, BuildContext context) {
    var test =
        services.databaseReference.collection('siswa').document(id).snapshots();
    test.forEach((data) {
      String transportasi = data.data['transportasi'];

      if (transportasi == '') showdlg(context, id);
    });
  }

  void showdlg(BuildContext context, String id) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text("Action", style: style.desc),
            content: Text('Kamu ke Sekolah naik apa ?', style: style.desc),
            actions: <Widget>[
              InkWell(
                onTap: () {
                  updateTransport(id, 'Sepeda', context);
                },
                child: Column(
                  children: <Widget>[
                    Icon(FontAwesome.bicycle, color: Colors.teal),
                    Text('Sepeda',
                        style: style.desc.copyWith(color: Colors.teal))
                  ],
                ),
              ),
              SizedBox(width: 13),
              InkWell(
                onTap: () {
                  updateTransport(id, 'Motor', context);
                },
                child: Column(
                  children: <Widget>[
                    Icon(FontAwesome.motorcycle, color: Colors.lightGreen),
                    Text('Motor',
                        style: style.desc.copyWith(color: Colors.lightGreen))
                  ],
                ),
              ),
            ],
          );
        });
  }

  void updateTransport(String id, String result, BuildContext context) async {
    Firestore.instance.collection('siswa').document(id).updateData(
        {'transportasi': result}).whenComplete(() => Navigator.pop(context));
  }

  void changeToFalse() async {
    var test2 = await services.databaseReference
        .collection('siswa')
        .where('hadir', isEqualTo: true)
        .getDocuments();
    test2.documents.forEach((f) {
      String id = f.documentID;
      Firestore.instance
          .collection('siswa')
          .document(id)
          .updateData({'hadir': false});
    });
    notifyListeners();
  }

  void checkDay() async {
    var test2 = await services.databaseReference
        .collection('database')
        .document('tanggal')
        .collection(datePick)
        .getDocuments();

    if (test2.documents.length == 0) {
      changeToFalse();
    }
    notifyListeners();
  }

  Future<ui.Image> _loadOverlayImage() async {
    final completer = Completer<ui.Image>();
    final byteData = await rootBundle.load('assets/images/logo2.png');
    ui.decodeImageFromList(byteData.buffer.asUint8List(), completer.complete);
    return completer.future;
  }

  void showQR(idUser, BuildContext context) async {
    String nis;
    var test2 = services.databaseReference
        .collection('siswa')
        .document(idUser)
        .snapshots();
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text("QR Code", style: style.desc),
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
                      emptyColor: Colors.teal[50],
                      // size: 320.0,
                      embeddedImage: snapshot.data,
                      embeddedImageStyle: QrEmbeddedImageStyle(
                        size: Size.square(50),
                      ),
                    ),
                  );
                },
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Close",
                    style: style.desc.copyWith(color: Colors.teal)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
