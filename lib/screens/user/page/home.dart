import 'package:eparkir/screens/login.dart';
import 'package:eparkir/screens/user/page/showQr.dart';
import 'package:eparkir/services/firestore/databaseReference.dart';
import 'package:eparkir/widgets/user/home/type1/banner.dart';
import 'package:eparkir/widgets/user/home/type1/quote.dart';
import 'package:eparkir/widgets/user/home/type2/sudahScan.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  final String id;
  Home({this.id});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String text = "Belum Pulang";
  String resul11t = "";
  void press() {
    setState(() {
      text = "15.40";
    });
  }

  void resetPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt("value", 2);
    preferences.setString("id", '');
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ShowQr()),
    );

    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text("$result")));

    setState(() {
      resul11t = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Text("log out"),
        onPressed: () {
          resetPref();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Login()),
            (Route<dynamic> route) => false,
          );
        },
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            welcome(),
            (resul11t == "") ? type1(height, width) : type2(height, width)
          ],
        ),
      ),
    );
  }

  Padding welcome() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: StreamBuilder(
        stream:
            databaseReference.collection('db').document(widget.id).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text(
              '',
            );
          } else {
            String nama = snapshot.data['nama'];
            return Text("Selamat Datang, $nama");
          }
        },
      ),
    );
  }

  Widget type1(height, width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        banner(width, height),
        quote(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Center(
              child: Text(
            "Kamu belum scan :(",
            style: TextStyle(color: Colors.red),
          )),
        ),
        Center(
          child: Column(
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  _navigateAndDisplaySelection(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Icon(
                    Icons.code,
                    color: Colors.white,
                    size: 50.0,
                  ),
                ),
                shape: new CircleBorder(),
                color: Colors.blue,
              ),
              Text(
                "Tap untuk scan",
                style: TextStyle(fontSize: 10),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget type2(height, width) {
    int _pulang = 1;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          datang(width, height),
          pulang(width, height, _pulang),
          (_pulang == 0)
              ? sudahScan(height, width, 0)
              : (text == "Belum Pulang")
                  ? scanSebelumPulang()
                  : sudahScan(height, width, 1)
        ],
      ),
    );
  }

  Padding scanSebelumPulang() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: Center(
                child: Text(
              "Scan sebelum pulang!",
              style: TextStyle(color: Colors.red),
            )),
          ),
          Center(
            child: Column(
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    press();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Icon(
                      Icons.code,
                      color: Colors.white,
                      size: 50.0,
                    ),
                  ),
                  shape: new CircleBorder(),
                  color: Colors.blue,
                ),
                Text(
                  "Tap untuk scan",
                  style: TextStyle(fontSize: 10),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Align pulang(width, height, int _pulang) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: width / 1.5,
        height: height / 7,
        color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text("Pulang :"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  (_pulang == 1) ? text : "Belum Pulang",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding datang(width, height) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: Container(
        width: width / 1.5,
        height: height / 7,
        color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text("Datang :"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "06.50",
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
