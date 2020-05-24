import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eparkir/services/firestore/databaseReference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class Scanner extends StatefulWidget {
  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scanner"),
      ),
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  var qrText = '';
  QRViewController controller;
  bool flashStatus = false;
  bool cameraStatus = false;
  bool prStatus = false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String dateNow = DateFormat('dd-MM-yyyy').format(DateTime.now());
  String timeNow = DateFormat('Hm').format(DateTime.now());

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

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      controller?.pauseCamera();
      setState(() {
        qrText = scanData;
      });
      checkUser(qrText);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    qrText = '';
  }

  Future checkUser(String result) async {
    final QuerySnapshot snapshot = await databaseReference
        .collection("database")
        .document('tanggal')
        .collection(dateNow)
        .where('nis', isEqualTo: result)
        .getDocuments();
    final List<DocumentSnapshot> list = snapshot.documents;

    // databaseReference
    //     .collection('siswa')
    //     .where('nis', isEqualTo: result)
    //     .snapshots()
    //     .listen((data) => data.documents.forEach((doc) {
    //           String id = doc.documentID;
    //           String nama = doc['nama'];
    //           String kelas = doc['kelas'];
    //           String nis = doc['nis'];

    //           goAbsent(dateNow, id, nama, kelas, nis);
    //         }));
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
      // databaseReference
      //     .collection('database')
      //     .document('tanggal')
      //     .collection(dateNow)
      //     .where('nis', isEqualTo: result)
      //     .snapshots()
      //     .listen((data) => data.documents.forEach((doc) {
      //           String id = doc.documentID;
      //           String pulang = doc['pulang'];

      //           goAbsent2(pulang, id);
      //         }));
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
  }

  void goAbsent2(pulangRes, idRes) {
    if (pulangRes == null) {
      Firestore.instance
          .collection('database')
          .document('tanggal')
          .collection(dateNow)
          .document(idRes)
          .updateData({'pulang': timeNow}).whenComplete(() {
        Scaffold.of(context).showSnackBar(snackbarPulang);
        setState(() {
          qrText = '';
        });
        controller?.resumeCamera();
      });
      // Firestore.instance
      //     .collection('siswa')
      //     .document(idRes)
      //     .updateData({'hadir': false}).whenComplete(() {

      // });
    } else {
      Scaffold.of(context).showSnackBar(snackbar);
      setState(() {
        qrText = '';
      });
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
      Scaffold.of(context).showSnackBar(snackbarSuccess);
      setState(() {
        qrText = '';
      });
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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    // return Center(
    //   child: Column(
    //     children: <Widget>[
    //       Padding(
    //         padding: const EdgeInsets.all(10.0),
    //         child: Container(
    //           child: Center(
    //             child: Text(
    //               "Untuk Camera",
    //               style: TextStyle(color: Colors.white),
    //             ),
    //           ),
    //           width: width / 1.1,
    //           height: height / 2.2,
    //           color: Colors.black,
    //         ),
    //       ),
    //       Container(
    //         width: width / 1.5,
    //         height: height / 7.5,
    //         color: Colors.black,
    //         child: Center(
    //           child: Text(
    //             "Untuk Result",
    //             style: TextStyle(color: Colors.white),
    //           ),
    //         ),
    //       ),
    //       SizedBox(
    //         height: 30,
    //       ),
    //       RaisedButton(
    //         child: Text("Show Snackbar"),
    //         onPressed: () {
    //           Scaffold.of(context).showSnackBar(snackbar);
    //         },
    //       ),
    //     ],
    //   ),
    // );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Container(
              width: width / 1.1,
              height: height / 2.2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(
                    color: Colors.red,
                    width: 3.0,
                  )),
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: Colors.red,
                  borderRadius: 5,
                  borderLength: 20,
                  borderWidth: 10,
                  cutOutSize: 250,
                ),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      "Flash",
                      style: TextStyle(fontSize: 12.0),
                    ),
                    SizedBox(
                      height: 3.0,
                    ),
                    FlutterSwitch(
                      height: 23.0,
                      valueFontSize: 12.0,
                      width: 60,
                      showOnOff: true,
                      activeTextColor: Colors.black,
                      inactiveTextColor: Colors.blue[50],
                      value: flashStatus,
                      onToggle: (val) {
                        if (controller != null) {
                          controller.toggleFlash();
                          if (val == true) {
                            setState(() {
                              flashStatus = val;
                            });
                          } else {
                            setState(() {
                              flashStatus = val;
                            });
                          }
                        }
                      },
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      "Rotate Camera",
                      style: TextStyle(fontSize: 12.0),
                    ),
                    SizedBox(
                      height: 3.0,
                    ),
                    FlutterSwitch(
                      height: 23.0,
                      valueFontSize: 12.0,
                      width: 60,
                      showOnOff: true,
                      activeTextColor: Colors.black,
                      inactiveTextColor: Colors.blue[50],
                      value: cameraStatus,
                      onToggle: (val) {
                        if (controller != null) {
                          controller.flipCamera();
                          if (val == true) {
                            setState(() {
                              cameraStatus = val;
                            });
                          } else {
                            setState(() {
                              cameraStatus = val;
                            });
                          }
                        }
                      },
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      "Pause / Resume",
                      style: TextStyle(fontSize: 12.0),
                    ),
                    SizedBox(
                      height: 3.0,
                    ),
                    FlutterSwitch(
                      height: 23.0,
                      valueFontSize: 12.0,
                      width: 60,
                      showOnOff: true,
                      activeTextColor: Colors.black,
                      inactiveTextColor: Colors.blue[50],
                      value: prStatus,
                      onToggle: (val) {
                        if (val == true) {
                          setState(() {
                            prStatus = val;
                          });
                          controller?.pauseCamera();
                        } else {
                          setState(() {
                            prStatus = val;
                          });
                          controller?.resumeCamera();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            Container(
              width: width,
              height: height / 3.5,
              child: Center(
                child: Text("Scan Result : $qrText"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
