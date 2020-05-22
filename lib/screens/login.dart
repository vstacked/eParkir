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
  int _state = 0;
  FocusNode nisFocus = FocusNode();
  final _key = new GlobalKey<FormState>();
  TextEditingController controller;
  bool isEnable = true;

  void onSuccess(level, id) {
    _state = 2;
    controller.clear();

    if (level == '1') {
      pushAndRemoveUntil(HomeAdmin(
        id: id,
      ));
    } else {
      pushAndRemoveUntil(HomeUser(
        id: id,
      ));
    }
  }

  Future pushAndRemoveUntil(Widget to) {
    return Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => to),
      (Route<dynamic> route) => false,
    );
  }

  Widget setUpButtonChild() {
    switch (_state) {
      case 0:
        return new Text(
          "Login",
          style: const TextStyle(
            color: Colors.blue,
            fontSize: 16.0,
          ),
        );
        break;
      case 1:
        isEnable = false;
        return Container(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 3.0,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        );
        break;
      case 2:
        afterClick();
        return Icon(Icons.check, color: Colors.blue);
        break;
      case 3:
        Timer(Duration(seconds: 2), () {
          afterClick();
        });
        return Text(
          "Data Tidak Ada",
          style: const TextStyle(
            color: Colors.blue,
            fontSize: 16.0,
          ),
        );
        break;
      default:
        return Container();
    }
  }

  afterClick() {
    setState(() {
      _state = 0;
      isEnable = true;
      controller.clear();
    });
  }

  @override
  void initState() {
    controller = TextEditingController();
    controller.clear();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Form(
          key: _key,
          child: buildLogin(width),
        ),
      ),
    );
  }

  Column buildLogin(double width) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Login"),
        Container(
          width: width / 1.5,
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            maxLength: 8,
            focusNode: nisFocus,
            validator: (e) {
              return (e.isEmpty) ? "Please Insert NIS" : null;
            },
            enabled: isEnable,
            onFieldSubmitted: (value) {
              if (_state == 0) {
                _state = 1;
                checkUser(controller.text);
                nisFocus.unfocus();
              }
            },
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
              if (_key.currentState.validate()) if (_state == 0) {
                _state = 1;
                checkUser(controller.text);
                nisFocus.unfocus();
              }
            });
          },
          elevation: 4.0,
        ),
      ],
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

                onSuccess(levelR, id);
              }));
    });
  }
}
