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

  final snackbar = SnackBar(
    content: Text("Sudah Absen dongg"),
    backgroundColor: Colors.red,
    action: SnackBarAction(
      label: "Undo",
      textColor: Colors.black,
      onPressed: () {
        print('Pressed');
      },
    ),
  );

  final snackbarSuccess = SnackBar(
    content: Text("Success"),
    backgroundColor: Colors.green,
    action: SnackBarAction(
      label: "Undo",
      textColor: Colors.black,
      onPressed: () {
        print('Pressed');
      },
    ),
  );

  final snackbarPulang = SnackBar(
    content: Text("dah pulangg"),
    backgroundColor: Colors.blue,
    action: SnackBarAction(
      label: "Undo",
      textColor: Colors.black,
      onPressed: () {
        print('Pressed');
      },
    ),
  );
}
