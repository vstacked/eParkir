import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eparkir/screens/admin/homeAdmin.dart';
import 'package:eparkir/screens/user/homeUser.dart';
import 'package:eparkir/services/checkConnection.dart';
import 'package:eparkir/services/firestore.dart';
import 'package:eparkir/utils/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class LoginViewModel extends BaseViewModel {
  int state = 0;
  FocusNode _nisFocus;
  final _key = new GlobalKey<FormState>();
  TextEditingController _controller;
  bool _isEnable = true;
  CheckConnection checkConnection;
  FirestoreServices services = FirestoreServices();
  TxtStyle style = TxtStyle();

  get key => _key;
  get controller => _controller;
  get nisFocus => _nisFocus;
  get nisUnfocus => _nisFocus.unfocus();
  get isEnable => _isEnable;
  get controllerText => _controller.text;
  get validate => _key.currentState.validate();

  void initState() {
    _controller = TextEditingController();
    _controller.clear();
    _nisFocus = FocusNode();
    checkConnection = CheckConnection();
  }

  void dis() {
    _controller.dispose();
  }

  void onSuccess(level, id, context) async {
    state = 2;
    _controller.clear();

    Firestore.instance
        .collection('siswa')
        .document(id)
        .updateData({'login': true});

    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt("value", level);
    preferences.setString("id", id);

    if (level == 1) {
      pushAndRemoveUntil(
          HomeAdmin(
            id: id,
          ),
          context);
    } else {
      pushAndRemoveUntil(
          HomeUser(
            id: id,
          ),
          context);
    }
  }

  Future pushAndRemoveUntil(Widget to, context) {
    return Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => to),
      (Route<dynamic> route) => false,
    );
  }

  Widget setUpButtonChild() {
    switch (state) {
      case 0:
        return new Text(
          "Login",
          style: style.desc.copyWith(color: Colors.white, fontSize: 16.0),
        );

        break;
      case 1:
        _isEnable = false;

        return Container(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 3.0,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        );
        break;
      case 2:
        afterClick();
        return Icon(Icons.check, color: Colors.white);
        break;
      case 3:
        Timer(Duration(seconds: 2), () {
          afterClick();
        });
        return Text(
          "Data Tidak Ada",
          style: style.desc.copyWith(color: Colors.white, fontSize: 16.0),
        );
        break;
      case 4:
        Timer(Duration(seconds: 2), () {
          afterClick();
        });
        return Text(
          "No Internet Connection",
          style: style.desc.copyWith(color: Colors.white, fontSize: 16.0),
        );
        break;
      case 5:
        Timer(Duration(seconds: 2), () {
          afterClick();
        });
        return Text(
          "Sedang Login",
          style: style.desc.copyWith(color: Colors.amber, fontSize: 16.0),
        );
        break;
      default:
        return Container();
    }
  }

  afterClick() {
    state = 0;
    _isEnable = true;
    _controller.clear();
    notifyListeners();
  }

  Future checkUser(String nis, context) async {
    checkConnection.checkConnection().then((_) async {
      if (checkConnection.hasConnection) {
        final QuerySnapshot snapshot = await services.databaseReference
            .collection("siswa")
            .where('nis', isEqualTo: nis)
            .getDocuments();
        final List<DocumentSnapshot> list = snapshot.documents;

        if (list.length == 0) {
          state = 3;
          notifyListeners();
        } else {
          sendData(nis, context);
        }
      } else {
        state = 4;
        notifyListeners();
      }
    });
  }

  void sendData(nis, context) async {
    var test = await services.databaseReference
        .collection('siswa')
        .where('nis', isEqualTo: nis)
        .getDocuments();

    test.documents.forEach((f) {
      print(f.data['nama']);
      String id = f.documentID;
      int level = f.data['level'];
      bool login = f.data['login'];
      if (login == false) {
        onSuccess(level, id, context);
      } else {
        state = 5;
        notifyListeners();
      }
    });
  }
}
