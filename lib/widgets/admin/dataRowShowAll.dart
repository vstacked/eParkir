import 'package:eparkir/utils/textStyle.dart';
import 'package:eparkir/view-models/showAllViewModel.dart';
import 'package:flutter/material.dart';

DataRow dataRow(
    int no, String nis, nama, kelas, context, dyn, ShowAllViewModel model) {
  TxtStyle style = TxtStyle();
  return DataRow(
    cells: <DataCell>[
      DataCell(
        Text(
          no.toString(),
          style: style.desc,
        ),
      ),
      DataCell(
        ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 60),
            child: Text(
              nis,
              overflow: TextOverflow.ellipsis,
              style: style.desc,
            )),
        onTap: () => model.tapped(nis, nama, kelas, context, dyn),
      ),
      DataCell(
        ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 150),
            child: Text(
              nama,
              overflow: TextOverflow.ellipsis,
              style: style.desc,
            )),
        onTap: () => model.tapped(nis, nama, kelas, context, dyn),
      ),
      DataCell(
        ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 60),
            child: Text(
              kelas,
              overflow: TextOverflow.ellipsis,
              style: style.desc,
            )),
        onTap: () => model.tapped(nis, nama, kelas, context, dyn),
      ),
    ],
  );
}
