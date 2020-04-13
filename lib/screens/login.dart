import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eparkir/screens/admin/homeAdmin.dart';
import 'package:eparkir/screens/user/homeUser.dart';
import 'package:eparkir/services/firestore/databaseReference.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  int _level;
  int _state = 0;

  void onSuccess(_level, id) {
    setState(() {
      _state = 2;
      if (_state == 2) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => MyApp(
                    level: _level,
                    id: id,
                  )),
          (Route<dynamic> route) => false,
        );
      }
    });
  }

  Widget setUpButtonChild() {
    if (_state == 0) {
      return new Text(
        "Login",
        style: const TextStyle(
          color: Colors.blue,
          fontSize: 16.0,
        ),
      );
    } else if (_state == 1) {
      return Container(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 3.0,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      );
    } else if (_state == 2) {
      return Icon(Icons.check, color: Colors.blue);
    } else if (_state == 3) {
      return Text(
        "Data Tidak Ada",
        style: const TextStyle(
          color: Colors.blue,
          fontSize: 16.0,
        ),
      );
    } else {
      return Container();
    }
  }

  void ifState() {
    if (_state == 2) {
      setState(() {
        controller.clear();
      });
    }
    if (_state == 3) {
      setState(() {
        _state = 0;
        controller.clear();
      });
    }
  }

  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    ifState();
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Login"),
              Container(
                width: width / 1.5,
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  maxLength: 8,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Masukkan NIS..'),
                ),
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: BorderSide(color: Colors.blue)),
                child: setUpButtonChild(),
                onPressed: () {
                  setState(() {
                    if (_state == 0) {
                      _state = 1;
                      checkUser(controller.text);
                    }
                  });
                },
                elevation: 4.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future checkUser(String nis) async {
    final QuerySnapshot snapshot = await databaseReference
        .collection("db")
        .where('nis', isEqualTo: nis)
        .getDocuments();
    final List<DocumentSnapshot> list = snapshot.documents;

    if (list.length == 0) {
      setState(() {
        _state = 3;
      });
    } else {
      sendData(nis);
    }
  }

  void sendData(nis) {
    setState(() {
      databaseReference
          .collection('db')
          .where('nis', isEqualTo: nis)
          .snapshots()
          .listen((data) => data.documents.forEach((doc) {
                String id = doc.documentID;
                String levelR = doc['level'];

                if (levelR == '0') {
                  _level = 0;
                } else {
                  _level = 1;
                }
                onSuccess(_level, id);
              }));
    });
  }
}

class MyApp extends StatefulWidget {
  final String id;
  final int level;
  MyApp({this.level, this.id});
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: (widget.level == 1)
          ? HomeAdmin(
              id: widget.id,
            )
          : HomeUser(
              id: widget.id,
            ),
    ));
  }
}
