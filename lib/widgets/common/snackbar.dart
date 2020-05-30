import 'package:flutter/material.dart';

class Snackbar {
  final snackbarNoInet = SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text("No Internet Connection"),
    backgroundColor: Colors.red,
    action: SnackBarAction(
      label: "OK",
      textColor: Colors.white,
      onPressed: () {},
    ),
  );

  final snackbar = SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text("Sudah Absen"),
    backgroundColor: Colors.red,
    action: SnackBarAction(
      label: "OK",
      textColor: Colors.white,
      onPressed: () {},
    ),
  );

  final snackbarSuccess = SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text("Success"),
    backgroundColor: Colors.green,
    action: SnackBarAction(
      label: "OK",
      textColor: Colors.white,
      onPressed: () {},
    ),
  );

  final snackbarPulang = SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text("Success"),
    backgroundColor: Colors.lightBlue,
    action: SnackBarAction(
      label: "OK",
      textColor: Colors.white,
      onPressed: () {},
    ),
  );

  final snackbarNisExist = SnackBar(
    content: Text("NIS Sudah Ada"),
    backgroundColor: Colors.red,
    behavior: SnackBarBehavior.floating,
    action: SnackBarAction(
      label: "OK",
      textColor: Colors.white,
      onPressed: () {},
    ),
  );
}
