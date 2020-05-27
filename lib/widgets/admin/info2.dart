import 'package:eparkir/screens/admin/page/history.dart';
import 'package:flutter/material.dart';

Padding info2(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text("Daftar Hadir Hari ini :"),
        RaisedButton(
          color: Colors.white,
          child: Text(
            "History",
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => History()));
          },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(color: Colors.red)),
        ),
      ],
    ),
  );
}
