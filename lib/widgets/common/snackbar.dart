import 'package:flutter/material.dart';

class Snackbar {
  final snackbarNoInet = SnackBar(
    content: Text("No Internet Connection"),
    backgroundColor: Colors.red,
    action: SnackBarAction(
      label: "OK",
      textColor: Colors.black,
      onPressed: () {
        print('Pressed');
      },
    ),
  );
}
