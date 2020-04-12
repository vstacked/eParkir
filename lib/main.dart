import 'package:eparkir/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(Home());

// void main() {
//   SystemChrome.setPreferredOrientations(
//           [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp])
//       .then((_) => runApp(MaterialApp(
//             home: Login(),
//           )));
// }

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.blueAccent));
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return MaterialApp(
      home: Login(),
    );
  }
}
