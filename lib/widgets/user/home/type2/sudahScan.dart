import 'package:flutter/material.dart';

Padding sudahScan(height, width, int y) {
  // 0 datang 1 pulang
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 40.0),
    child: Container(
      height: height / 5,
      width: width,
      decoration: BoxDecoration(border: Border.all(color: Colors.red)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            (y == 0) ? "Sudah Scan datang" : "Sudah Scan pulang",
            style: TextStyle(color: Colors.green),
          ),
        ),
      ),
    ),
  );
}
