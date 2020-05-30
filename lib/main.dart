import 'package:eparkir/screens/admin/homeAdmin.dart';
import 'package:eparkir/screens/firstSlider.dart';
import 'package:eparkir/screens/login.dart';
import 'package:eparkir/screens/user/homeUser.dart';
import 'package:eparkir/utils/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MaterialApp(
      home: Splashscreen(),
      theme: ThemeData()
          .copyWith(primaryColor: Colors.teal, accentColor: Colors.teal),
    ));
  });
}

class Splashscreen extends StatefulWidget {
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  bool isLoad = false;
  bool title = false;
  Color color = Colors.teal[600];
  SharedPreferences _sharedPreferences;
  TxtStyle style;

  @override
  void initState() {
    style = TxtStyle();
    isLoad = false;
    title = false;
    SharedPreferences.getInstance().then((prefs) {
      setState(() => _sharedPreferences = prefs);
    });
    super.initState();
    Future.delayed(Duration(seconds: 1)).then((_) {
      setState(() {
        isLoad = true;
        color = Colors.white;
      });
    }).then((_) {
      Future.delayed(Duration(seconds: 4)).then((_) {
        setState(() {
          title = true;
        });
      });
    });
  }

  Future<bool> getSlider() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool('slider');
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: color));
    if (title)
      Future.delayed(Duration(seconds: 1)).then((_) {
        setState(() {
          title = false;
          isLoad = false;
        });
        if (_sharedPreferences.getBool('slider') == true)
          Navigator.pushAndRemoveUntil(
            context,
            _createRoute(),
            (Route<dynamic> route) => false,
          );
        else
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => FirstSlider()),
            (Route<dynamic> route) => false,
          );
      }).then((_) {
        setState(() {
          color = Colors.teal[600];
        });
      });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Center(
            child: AnimatedContainer(
              duration: Duration(seconds: 1),
              width: 110,
              height: (title) ? 200 : 10,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  'eParkir',
                  style: style.title.copyWith(
                    color: Colors.teal[400],
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: AnimatedContainer(
              duration: Duration(seconds: 3),
              height: (isLoad) ? 110 : 0,
              width: 110,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Colors.teal[300], Colors.teal[700]])),
              child: Icon(
                MaterialCommunityIcons.qrcode_scan,
                size: 75.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Home(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.easeOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
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
    // 2 login, 1 admin, 0 user
    return SafeArea(
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
    );
  }
}
