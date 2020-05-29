import 'package:eparkir/view-models/dataViewModel.dart';
import 'package:flutter/material.dart';

DataRow dataRow(
    int no, String nis, nama, kelas, context, idUser, DataViewModel model) {
  return DataRow(
    cells: <DataCell>[
      DataCell(
        Text(
          no.toString(),
          style: TextStyle(fontFamily: 'Jura'),
        ),
        onTap: () => model.tapped(nis, nama, kelas, context, idUser),
      ),
      DataCell(
        ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 60),
            child: Text(
              nis,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontFamily: 'Jura'),
            )),
        onTap: () => model.tapped(nis, nama, kelas, context, idUser),
      ),
      DataCell(
        ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 150),
            child: Text(
              nama,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontFamily: 'Jura'),
            )),
        onTap: () => model.tapped(nis, nama, kelas, context, idUser),
      ),
      DataCell(
        ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 60),
            child: Text(
              kelas,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontFamily: 'Jura'),
            )),
        onTap: () => model.tapped(nis, nama, kelas, context, idUser),
      ),
    ],
  );
}
