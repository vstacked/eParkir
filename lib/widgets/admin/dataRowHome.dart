import 'package:eparkir/utils/textStyle.dart';
import 'package:flutter/material.dart';

DataRow dataRow(int no, String nis, nama, kelas, datang) {
  TxtStyle style = TxtStyle();
  return DataRow(
    cells: <DataCell>[
      DataCell(Text(
        no.toString(),
        style: style.desc,
      )),
      DataCell(ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 60),
          child: Text(
            nis.toString(),
            overflow: TextOverflow.ellipsis,
            style: style.desc,
          ))),
      DataCell(ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 80),
          child: Text(
            nama,
            overflow: TextOverflow.ellipsis,
            style: style.desc,
          ))),
      DataCell(ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 60),
          child: Text(
            kelas,
            overflow: TextOverflow.ellipsis,
            style: style.desc,
          ))),
      DataCell(ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 60),
          child: Text(
            datang,
            overflow: TextOverflow.ellipsis,
            style: style.desc,
          ))),
    ],
  );
}
