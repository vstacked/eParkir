import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
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
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 30.0),
                child: Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.red)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ConstrainedBox(
                        constraints:
                            BoxConstraints(maxWidth: 250, maxHeight: 50),
                        child: Text(
                          "Quoutasdsadsadijsaodsjaosid usaidjasldjaslasdasdasdsadasadsadasdsaasdasdkdjsaldkjasldjaslkdaso idusao iduoa isjudae",
                          overflow: TextOverflow.fade,
                        )),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                  child: Text(
                "Kamu belum scan :(",
                style: TextStyle(color: Colors.red),
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Column(
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {},
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
