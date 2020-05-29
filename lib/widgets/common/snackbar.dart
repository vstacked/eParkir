import 'package:flutter/material.dart';

class Snackbar {
  final snackbarNoInet = SnackBar(
    content: Text("No Internet Connection"),
    backgroundColor: Colors.red,
    action: SnackBarAction(
      label: "OK",
      textColor: Colors.white,
      onPressed: () {},
    ),
  );

  final snackbar = SnackBar(
    content: Text("Sudah Absen"),
    backgroundColor: Colors.red,
    action: SnackBarAction(
      label: "OK",
      textColor: Colors.white,
      onPressed: () {},
    ),
  );

  final snackbarSuccess = SnackBar(
    content: Text("Success"),
    backgroundColor: Colors.green,
    action: SnackBarAction(
      label: "OK",
      textColor: Colors.white,
      onPressed: () {},
    ),
  );

  final snackbarPulang = SnackBar(
    content: Text("Success"),
    backgroundColor: Colors.lightBlue,
    action: SnackBarAction(
      label: "OK",
      textColor: Colors.white,
      onPressed: () {},
    ),
  );
}
