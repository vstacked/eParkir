import 'package:flutter/material.dart';

Container buildBackground(double width, double height) {
  return Container(
    width: width,
    height: height / 3,
    decoration: BoxDecoration(
      color: Colors.teal,
      borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(50),
        bottomLeft: Radius.circular(50),
      ),
    ),
  );
}
