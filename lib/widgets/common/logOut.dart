import 'package:eparkir/screens/login.dart';
import 'package:eparkir/utils/textStyle.dart';
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
            color: Colors.white,
            size: 25.0,
          ),
          onTap: () => shwDialog(context, model),
        );
      },
    );
  }

  void shwDialog(BuildContext context, LogOutViewModel model) {
    TxtStyle style = TxtStyle();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text("Action", style: style.desc),
            content: Text('Ingin LogOut ?', style: style.desc),
            actions: <Widget>[
              FlatButton(
                child: Text("Batal",
                    style: style.desc.copyWith(color: Colors.teal)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child:
                    Text("Ya", style: style.desc.copyWith(color: Colors.red)),
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
