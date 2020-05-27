import 'package:eparkir/screens/admin/page/showAll.dart';
import 'package:flutter/material.dart';

Padding filter(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 5.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text("urutkan berdasarkan"),
        GestureDetector(
          child: Text(
            "show all",
            style: TextStyle(color: Colors.blue),
          ),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ShowAll()));
          },
        ),
      ],
    ),
  );
}
