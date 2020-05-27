import 'package:eparkir/view-models/loginViewModel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final LoginViewModel loginViewModel = LoginViewModel();

  @override
  void dispose() {
    loginViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ViewModelBuilder<LoginViewModel>.reactive(
        viewModelBuilder: () => loginViewModel,
        onModelReady: (model) => model.initState(),
        disposeViewModel: false,
        builder: (context, model, child) {
          return Center(
            child: Form(
              key: model.key,
              child: buildLogin(width, model),
            ),
          );
        },
      ),
    );
  }

  Column buildLogin(double width, LoginViewModel model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Login"),
        Container(
          width: width / 1.5,
          child: TextFormField(
            controller: model.controller,
            keyboardType: TextInputType.number,
            maxLength: 8,
            focusNode: model.nisFocus,
            validator: (e) {
              return (e.isEmpty) ? "Please Insert NIS" : null;
            },
            enabled: model.isEnable,
            onFieldSubmitted: (value) {
              if (model.state == 0) {
                model.state = 1;
                model.checkUser(model.controllerText, model);
                model.nisUnfocus;
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
          child: model.setUpButtonChild(),
          onPressed: () {
            setState(() {
              if (model.validate) if (model.state == 0) {
                model.state = 1;
                model.checkUser(model.controllerText, context);
                model.nisUnfocus;
              }
            });
          },
          elevation: 4.0,
        ),
      ],
    );
  }
}
