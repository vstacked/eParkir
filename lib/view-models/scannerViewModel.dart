import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eparkir/services/checkConnection.dart';
import 'package:eparkir/services/firestore/databaseReference.dart';
import 'package:eparkir/widgets/common/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:stacked/stacked.dart';

class ScannerViewModel extends BaseViewModel {
  var qrText = '';
  QRViewController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool flashStatus = false;
  bool cameraStatus = false;
  bool prStatus = false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String dateNow = DateFormat('dd-MM-yyyy').format(DateTime.now());
  String timeNow = DateFormat('Hm').format(DateTime.now());
  CheckConnection checkConnection;
  Snackbar _snackbar = Snackbar();

  get controller => _controller;
  get scaffoldKey => _scaffoldKey;

  void initState() {
    qrText = '';
    checkConnection = CheckConnection();
    notifyListeners();
  }

  void dis() {
    _controller.dispose();
  }

  final snackbar = SnackBar(
    content: Text("Sudah Absen dongg"),
    backgroundColor: Colors.red,
    action: SnackBarAction(
      label: "Undo",
      textColor: Colors.black,
      onPressed: () {
        print('Pressed');
      },
    ),
  );
  final snackbarSuccess = SnackBar(
    content: Text("Success"),
    backgroundColor: Colors.green,
    action: SnackBarAction(
      label: "Undo",
      textColor: Colors.black,
      onPressed: () {
        print('Pressed');
      },
    ),
  );

  final snackbarPulang = SnackBar(
    content: Text("dah pulangg"),
    backgroundColor: Colors.blue,
    action: SnackBarAction(
      label: "Undo",
      textColor: Colors.black,
      onPressed: () {
        print('Pressed');
      },
    ),
  );

  void onQRViewCreated(QRViewController _controller) {
    this._controller = _controller;
    _controller.scannedDataStream.listen((scanData) {
      _controller?.pauseCamera();
      qrText = scanData;
      checkUser(qrText);
      notifyListeners();
    });
  }

  Future checkUser(String result) async {
    checkConnection.checkConnection().then((_) async {
      if (checkConnection.hasConnection) {
        final QuerySnapshot snapshot = await databaseReference
            .collection("database")
            .document('tanggal')
            .collection(dateNow)
            .where('nis', isEqualTo: result)
            .getDocuments();
        final List<DocumentSnapshot> list = snapshot.documents;
        if (list.length == 0) {
          var test = await databaseReference
              .collection('siswa')
              .where('nis', isEqualTo: result)
              .getDocuments();

          test.documents.forEach((f) {
            print(f.data['nama']);
            String id = f.documentID;
            String nama = f.data['nama'];
            String kelas = f.data['kelas'];
            String nis = f.data['nis'];
            goAbsent(dateNow, id, nama, kelas, nis);
          });
        } else {
          var test2 = await databaseReference
              .collection('database')
              .document('tanggal')
              .collection(dateNow)
              .where('nis', isEqualTo: result)
              .getDocuments();
          test2.documents.forEach((f) {
            String id = f.documentID;
            String pulang = f.data['pulang'];
            goAbsent2(pulang, id);
          });
        }
      } else {
        _scaffoldKey.currentState.showSnackBar(_snackbar.snackbarNoInet);
        qrText = '';
        notifyListeners();
        controller?.resumeCamera();
      }
    });
  }

  void goAbsent2(pulangRes, idRes) {
    if (pulangRes == null) {
      Firestore.instance
          .collection('database')
          .document('tanggal')
          .collection(dateNow)
          .document(idRes)
          .updateData({'pulang': timeNow}).whenComplete(() {
        _scaffoldKey.currentState.showSnackBar(snackbarPulang);

        qrText = '';
        notifyListeners();
        controller?.resumeCamera();
      });
      // Firestore.instance
      //     .collection('siswa')
      //     .document(idRes)
      //     .updateData({'hadir': false}).whenComplete(() {

      // });
    } else {
      _scaffoldKey.currentState.showSnackBar(snackbar);

      qrText = '';
      notifyListeners();
      controller?.resumeCamera();
    }
  }

  Future goAbsent(String _dateNow, String idUser, nama, kelas, nis) async {
    var documentReference = databaseReference
        .collection('database')
        .document('tanggal')
        .collection(_dateNow)
        .document(idUser);

    databaseReference.runTransaction((transaction) async {
      await transaction.set(documentReference, {
        'nama': nama,
        'nis': nis,
        'kelas': kelas,
        'datang': timeNow,
        'pulang': null,
        'nisSearch': setSearchParam(nis),
      });
    });

    Firestore.instance
        .collection('siswa')
        .document(idUser)
        .updateData({'hadir': true}).whenComplete(() {
      _scaffoldKey.currentState.showSnackBar(snackbarSuccess);

      qrText = '';
      notifyListeners();
      controller?.resumeCamera();
    });
  }

  setSearchParam(String caseNumber) {
    List<String> caseSearchList = List();
    String temp = "";
    for (int i = 0; i < caseNumber.length; i++) {
      temp = temp + caseNumber[i];
      caseSearchList.add(temp);
    }
    return caseSearchList;
  }
}
