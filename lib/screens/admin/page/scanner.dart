import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eparkir/services/firestore/databaseReference.dart';
import 'package:eparkir/view-models/scannerViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:stacked/stacked.dart';

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
  ScannerViewModel scannerViewModel = ScannerViewModel();

  @override
  void dispose() {
    scannerViewModel.dis();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: scannerViewModel.scaffoldKey,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ViewModelBuilder<ScannerViewModel>.reactive(
          viewModelBuilder: () => scannerViewModel,
          onModelReady: (model) => model.initState(),
          builder: (context, model, child) {
            return Column(
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
                    key: model.qrKey,
                    onQRViewCreated: model.onQRViewCreated,
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
                          value: model.flashStatus,
                          onToggle: (val) {
                            if (model.controller != null) {
                              model.controller.toggleFlash();
                              if (val == true) {
                                setState(() {
                                  model.flashStatus = val;
                                });
                              } else {
                                setState(() {
                                  model.flashStatus = val;
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
                          value: model.cameraStatus,
                          onToggle: (val) {
                            if (model.controller != null) {
                              model.controller.flipCamera();
                              if (val == true) {
                                setState(() {
                                  model.cameraStatus = val;
                                });
                              } else {
                                setState(() {
                                  model.cameraStatus = val;
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
                          value: model.prStatus,
                          onToggle: (val) {
                            if (val == true) {
                              setState(() {
                                model.prStatus = val;
                              });
                              model.controller?.pauseCamera();
                            } else {
                              setState(() {
                                model.prStatus = val;
                              });
                              model.controller?.resumeCamera();
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
                    child: Text("Scan Result : ${model.qrText}"),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
