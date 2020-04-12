import 'dart:async';
import 'package:eparkir/screens/admin/homeAdmin.dart';
import 'package:eparkir/screens/user/homeUser.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  int _level;
  int _state = 0;
  String admin = "1";
  String user = "2";
  void animateButton(input) {
    setState(() {
      _state = 1;
      Timer(Duration(seconds: 1), () {
        if (input == admin) {
          _level = 1;
          onSuccess(_level);
        } else if (input == user) {
          _level = 0;
          onSuccess(_level);
        } else {
          setState(() {
            _state = 3;
          });
        }
      });
    });
  }

  void onSuccess(_level) {
    setState(() {
      _state = 2;
      if (_state == 2) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyApp(
                      level: _level,
                    )));
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

  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    if (_state == 2) {
      setState(() {
        controller.clear();
      });
    }
    if (_state == 3) {
      Timer(Duration(milliseconds: 1500), () {
        setState(() {
          _state = 0;
          controller.clear();
        });
      });
    }

    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(controller.text),
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
                      animateButton(controller.text);
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
}

class MyApp extends StatefulWidget {
  final int level;
  MyApp({this.level});
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
      child: (widget.level == 1) ? HomeAdmin() : HomeUser(),
    ));
  }
}
