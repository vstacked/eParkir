import 'package:eparkir/view-models/scannerViewModel.dart';
import 'package:eparkir/widgets/admin/buildSwitchScanner.dart';
import 'package:flutter/material.dart';
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
        backgroundColor: Colors.teal[100],
        iconTheme: IconThemeData().copyWith(color: Colors.teal),
        title: Text(
          "Scanner",
          style: TextStyle(
            fontFamily: 'Lemonada',
            color: Colors.teal,
          ),
        ),
        elevation: 0,
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
    TextStyle style = TextStyle(fontFamily: 'Jura');

    return Scaffold(
      key: scannerViewModel.scaffoldKey,
      backgroundColor: Colors.teal[100],
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
                        color: Colors.teal,
                        width: 3.0,
                      )),
                  child: QRView(
                    key: model.qrKey,
                    onQRViewCreated: model.onQRViewCreated,
                    overlay: QrScannerOverlayShape(
                      borderColor: Colors.teal,
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
                BuildSwitchScanner(model: model),
                Container(
                  width: width,
                  height: height / 3.5,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Scan Result : ",
                          style: style.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 15.0),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          model.qrText,
                          style: style,
                        ),
                      ],
                    ),
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
