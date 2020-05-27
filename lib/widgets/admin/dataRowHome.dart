import 'package:flutter/material.dart';

DataRow dataRow(int no, String nis, nama, kelas, datang) {
  return DataRow(
    cells: <DataCell>[
      DataCell(Text(no.toString())),
      DataCell(ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 60),
          child: Text(
            nis.toString(),
            overflow: TextOverflow.ellipsis,
          ))),
      DataCell(ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 80),
          child: Text(
            nama,
            overflow: TextOverflow.ellipsis,
          ))),
      DataCell(ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 60),
          child: Text(
            kelas,
            overflow: TextOverflow.ellipsis,
          ))),
      DataCell(ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 60),
          child: Text(
            datang,
            overflow: TextOverflow.ellipsis,
          ))),
    ],
  );
}
