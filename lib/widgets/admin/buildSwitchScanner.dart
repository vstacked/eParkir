import 'package:eparkir/view-models/scannerViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class BuildSwitchScanner extends StatefulWidget {
  BuildSwitchScanner({@required this.model});
  final ScannerViewModel model;
  @override
  _BuildSwitchScannerState createState() => _BuildSwitchScannerState();
}

class _BuildSwitchScannerState extends State<BuildSwitchScanner> {
  @override
  Widget build(BuildContext context) {
    return Row(
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
              value: widget.model.flashStatus,
              onToggle: (val) {
                if (widget.model.controller != null) {
                  widget.model.controller.toggleFlash();
                  if (val == true) {
                    setState(() {
                      widget.model.flashStatus = val;
                    });
                  } else {
                    setState(() {
                      widget.model.flashStatus = val;
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
              value: widget.model.cameraStatus,
              onToggle: (val) {
                if (widget.model.controller != null) {
                  widget.model.controller.flipCamera();
                  if (val == true) {
                    setState(() {
                      widget.model.cameraStatus = val;
                    });
                  } else {
                    setState(() {
                      widget.model.cameraStatus = val;
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
              value: widget.model.prStatus,
              onToggle: (val) {
                if (val == true) {
                  setState(() {
                    widget.model.prStatus = val;
                  });
                  widget.model.controller?.pauseCamera();
                } else {
                  setState(() {
                    widget.model.prStatus = val;
                  });
                  widget.model.controller?.resumeCamera();
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
