import 'package:eparkir/screens/admin/homeAdmin.dart';
import 'package:eparkir/screens/login.dart';
import 'package:eparkir/screens/user/homeUser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(Home());

// class Home extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setSystemUIOverlayStyle(
//         SystemUiOverlayStyle(statusBarColor: Colors.blueAccent));
//     SystemChrome.setPreferredOrientations(
//         [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
//     return MaterialApp(
//       home: Login(),
//     );
//   }
// }

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<int> getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getInt("value");
  }

  Future<String> getId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("id");
  }

  @override
  void initState() {
    super.initState();
    getPref();
    getId();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.blueAccent));
    // SystemChrome.setPreferredOrientations(
    //     [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    // 2 login, 1 admin, 0 user
    return MaterialApp(
      home: SafeArea(
        child: FutureBuilder<int>(
          future: getPref(),
          builder: (context, snapshot) {
            if (snapshot.data == 1) {
              return FutureBuilder(
                future: getId(),
                builder: (context, snap) => HomeAdmin(
                  id: snap?.data,
                ),
              );
            } else if (snapshot.data == 0) {
              return FutureBuilder(
                future: getId(),
                builder: (context, snap) => HomeUser(
                  id: snap?.data,
                ),
              );
            } else {
              return Login();
            }
          },
        ),
      ),
    );
  }
}
