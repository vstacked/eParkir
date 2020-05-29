import 'package:eparkir/screens/login.dart';
import 'package:eparkir/view-models/logOutViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
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
          child: Icon(
            MaterialCommunityIcons.logout,
            color: Colors.redAccent,
            size: 25.0,
          ),
          onTap: () => shwDialog(context, model),
        );
      },
    );
  }

  void shwDialog(BuildContext context, LogOutViewModel model) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Action",
              style: TextStyle(fontFamily: 'Jura'),
            ),
            content: Text(
              'Ingin LogOut ?',
              style: TextStyle(fontFamily: 'Jura'),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.teal,
                child: Text(
                  "Batal",
                  style: TextStyle(fontFamily: 'Jura'),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                color: Colors.red,
                child: Text(
                  "LogOut",
                  style: TextStyle(fontFamily: 'Jura'),
                ),
                onPressed: () {
                  model.resetPref(id);
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Login()),
                    (Route<dynamic> route) => false,
                  );
                },
              )
            ],
          );
        });
  }
}
