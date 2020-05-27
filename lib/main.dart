import 'package:eparkir/screens/admin/homeAdmin.dart';
import 'package:eparkir/screens/login.dart';
import 'package:eparkir/screens/user/homeUser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(new Home());
  });
}

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

    // 2 login, 1 admin, 0 user
    return MaterialApp(
      home: SafeArea(
        child: FutureBuilder<int>(
            future: getPref(),
            builder: (context, snapshot) {
              return FutureBuilder<String>(
                future: getId(),
                builder: (context, snap) {
                  if (snapshot.data == 1) {
                    return HomeAdmin(
                      id: snap?.data,
                    );
                  } else if (snapshot.data == 0) {
                    return HomeUser(
                      id: snap?.data,
                    );
                  } else {
                    return Login();
                  }
                },
              );
            }),
      ),
    );
  }
}
