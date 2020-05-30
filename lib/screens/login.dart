import 'package:eparkir/utils/textStyle.dart';
import 'package:eparkir/view-models/loginViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
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
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: ViewModelBuilder<LoginViewModel>.reactive(
        viewModelBuilder: () => loginViewModel,
        onModelReady: (model) => model.initState(),
        disposeViewModel: false,
        builder: (context, model, child) {
          return Center(
            child: Stack(
              children: <Widget>[
                Positioned(
                  height: height,
                  width: width,
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          width: width / 2.5,
                          height: height / 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.elliptical(100, 100),
                              bottomRight: Radius.elliptical(50, 10),
                              topLeft: Radius.elliptical(10, 50),
                            ),
                            color: Colors.teal,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: width,
                          height: height / 8,
                          decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.elliptical(75, 25),
                              )),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(width: 75),
                            Container(
                              width: width / 3,
                              height: height / 6,
                              decoration: BoxDecoration(
                                color: Colors.teal,
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          width: width / 2,
                          height: height / 4,
                          decoration: BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.elliptical(100, 50),
                              topRight: Radius.elliptical(100, 100),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Form(
                  key: model.key,
                  child: buildLogin(width, model, height),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildLogin(double width, LoginViewModel model, double height) {
    TxtStyle style = TxtStyle();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        //
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: <Widget>[
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [Colors.teal[300], Colors.teal[700]])),
                  child: Icon(
                    MaterialCommunityIcons.qrcode_scan,
                    size: 35,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  "eParkir",
                  style: style.title.copyWith(
                    fontSize: 25.0,
                    color: Colors.teal,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
        Column(
          children: <Widget>[
            Container(
              height: 100,
              width: width / 1.5,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.teal,
                  style: BorderStyle.solid,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.teal,
                      offset: Offset(0.25, 0.25),
                      blurRadius: 3.0),
                ],
                borderRadius: BorderRadius.circular(7.5),
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
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
                    cursorColor: Colors.teal,
                    style: style.desc,
                    decoration: InputDecoration(
                      errorStyle: style.desc,
                      counterStyle: style.desc,
                      hintStyle: style.desc,
                      hintText: 'ex: 1700xxxx',
                      prefixIcon: Icon(
                        MaterialIcons.input,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: MaterialButton(
                color: Colors.teal,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.teal,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                minWidth: width / 3,
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
            ),
          ],
        ),
        SizedBox(
          height: 5,
        )
      ],
    );
  }
}
