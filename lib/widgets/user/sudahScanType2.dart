import 'package:eparkir/utils/textStyle.dart';
import 'package:flutter/material.dart';

Widget sudahScanType2(height, width, int y) {
  TxtStyle style = TxtStyle();
  // 0 datang 1 pulang
  return Container(
    height: height / 5,
    width: width,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          (y == 0)
              ? "Sudah Scan\n Selamat Belajar !"
              : "Sudah Scan\n Sampai Jumpa !",
          textAlign: TextAlign.center,
          style: style.desc.copyWith(color: Colors.teal, fontSize: 20),
        ),
      ),
    ),
  );
}
