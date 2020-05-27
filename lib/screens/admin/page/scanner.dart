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
                BuildSwitchScanner(model: model),
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
