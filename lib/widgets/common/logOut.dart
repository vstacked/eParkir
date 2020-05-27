import 'package:eparkir/screens/login.dart';
import 'package:eparkir/view-models/homeAdminViewModel.dart';
import 'package:eparkir/view-models/logOutViewModel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class LogOut extends StatelessWidget {
  LogOut({@required this.id});
  final LogOutViewModel logOutViewModel = LogOutViewModel();
  final String id;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LogOutViewModel>.reactive(
      viewModelBuilder: () => logOutViewModel,
      builder: (context, model, child) {
        return GestureDetector(
          child: Column(
            children: <Widget>[
              Icon(
                Icons.highlight_off,
                color: Colors.red,
                size: 20,
              ),
              Text(
                "Log Out",
                style: TextStyle(color: Colors.red, fontSize: 10),
              )
            ],
          ),
          onTap: () {
            model.resetPref(id);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Login()),
              (Route<dynamic> route) => false,
            );
          },
        );
      },
    );
  }
}

GestureDetector logOut(
    HomeAdminViewModel model, String id, BuildContext context) {}
