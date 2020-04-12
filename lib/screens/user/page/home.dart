import 'package:eparkir/screens/user/page/showQr.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text("Selamat Datang, User"),
            ),
            (resul11t == "") ? type1(height, width) : type2(height, width)
          ],
        ),
      ),
    );
  }

  Widget type1(height, width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: width / 1.5,
            height: height / 3,
            color: Colors.amber,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Sekarang Pukul :"),
                  Text(
                    "06.50",
                    style: TextStyle(fontSize: 40),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "10 menit lagi kamu akan terlambat!",
                    style: TextStyle(
                        color: Colors.red, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 30.0),
            child: Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.red)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 250, maxHeight: 50),
                    child: Text(
                      "Quoutasdsadsadijsaodsjaosid usaidjasldjaslasdasdasdsadasadsadasdsaasdasdkdjsaldkjasldjaslkdaso idusao iduoa isjudae",
                      overflow: TextOverflow.fade,
                    )),
              ),
            )),
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
          Padding(
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
          ),
          Align(
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
          ),
          (_pulang == 0)
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: Container(
                    height: height / 5,
                    width: width,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.red)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          "Sudah Scan datang",
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ),
                  ),
                )
              : (text == "Belum Pulang")
                  ? Padding(
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
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40.0),
                      child: Container(
                        height: height / 5,
                        width: width,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.red)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              "Sudah Scan pulang",
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        ),
                      ),
                    )
        ],
      ),
    );
  }
}
