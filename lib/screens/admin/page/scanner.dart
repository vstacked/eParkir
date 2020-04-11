import 'package:flutter/material.dart';

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

class Body extends StatelessWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final snackbar = SnackBar(
      content: Text("Test"),
      backgroundColor: Colors.blue,
      action: SnackBarAction(
        label: "Undo",
        textColor: Colors.black,
        onPressed: () {
          print('Pressed');
        },
      ),
    );
    return Center(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              child: Center(
                child: Text(
                  "Untuk Camera",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              width: width / 1.1,
              height: height / 2.2,
              color: Colors.black,
            ),
          ),
          Container(
            width: width / 1.5,
            height: height / 7.5,
            color: Colors.black,
            child: Center(
              child: Text(
                "Untuk Result",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          RaisedButton(
            child: Text("Show Snackbar"),
            onPressed: () {
              Scaffold.of(context).showSnackBar(snackbar);
            },
          ),
        ],
      ),
    );
  }
}
