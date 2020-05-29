import 'package:flutter/material.dart';

DataRow dataRow(int no, String nis, nama, kelas, datang) {
  TextStyle style = TextStyle(fontFamily: 'Jura');
  return DataRow(
    cells: <DataCell>[
      DataCell(Text(
        no.toString(),
        style: style,
      )),
      DataCell(ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 60),
          child: Text(
            nis.toString(),
            overflow: TextOverflow.ellipsis,
            style: style,
          ))),
      DataCell(ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 80),
          child: Text(
            nama,
            overflow: TextOverflow.ellipsis,
            style: style,
          ))),
      DataCell(ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 60),
          child: Text(
            kelas,
            overflow: TextOverflow.ellipsis,
            style: style,
          ))),
      DataCell(ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 60),
          child: Text(
            datang,
            overflow: TextOverflow.ellipsis,
            style: style,
          ))),
    ],
  );
}
