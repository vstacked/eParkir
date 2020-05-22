import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eparkir/services/firestore/databaseReference.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShowAll extends StatefulWidget {
  @override
  _ShowAllState createState() => _ShowAllState();
}

class _ShowAllState extends State<ShowAll> {
  String datePick = DateFormat('dd-MM-yyyy').format(DateTime.now());

  bool _sortNameAsc = true;
  bool _sortAsc = true;
  int _sortColumnIndex;

  String orderByValue;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Hadir Hari ini"),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              child: Icon(Icons.search),
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Urutkan berdasarkan :"),
          ),
          Flexible(
            child: Container(
              width: double.infinity,
              height: height,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: StreamBuilder(
                  stream: (orderByValue != null)
                      ? databaseReference
                          .collection('database')
                          .document('tanggal')
                          .collection(datePick)
                          .orderBy(orderByValue, descending: !_sortAsc)
                          .snapshots()
                      : databaseReference
                          .collection('database')
                          .document('tanggal')
                          .collection(datePick)
                          .snapshots(),
                  builder: (context, snapshot) {
                    int no = 1;
                    QuerySnapshot data = snapshot.data;
                    List<DocumentSnapshot> documentSnapshot =
                        (data?.documents != null) ? data.documents : [];

                    return DataTable(
                      horizontalMargin: 10,
                      headingRowHeight: 40,
                      columnSpacing: 10,
                      sortColumnIndex: _sortColumnIndex,
                      sortAscending: _sortAsc,
                      columns: <DataColumn>[
                        DataColumn(
                          label: Text("No."),
                        ),
                        DataColumn(
                          label: Text("NIS"),
                          onSort: (columnIndex, sortAscending) {
                            print(sortAscending);
                            orderByValue = 'nis';
                            setState(() {
                              if (columnIndex == _sortColumnIndex) {
                                _sortAsc = _sortNameAsc = sortAscending;
                              } else {
                                _sortColumnIndex = columnIndex;
                                _sortAsc = _sortNameAsc;
                              }
                            });
                          },
                        ),
                        DataColumn(
                          label: Text("Nama"),
                          onSort: (columnIndex, sortAscending) {
                            print(sortAscending);
                            orderByValue = 'nama';
                            setState(() {
                              if (columnIndex == _sortColumnIndex) {
                                _sortAsc = _sortNameAsc = sortAscending;
                              } else {
                                _sortColumnIndex = columnIndex;
                                _sortAsc = _sortNameAsc;
                              }
                            });
                          },
                        ),
                        DataColumn(
                          label: Text("Kelas"),
                          onSort: (columnIndex, sortAscending) {
                            print(sortAscending);
                            orderByValue = 'kelas';
                            setState(() {
                              if (columnIndex == _sortColumnIndex) {
                                _sortAsc = _sortNameAsc = sortAscending;
                              } else {
                                _sortColumnIndex = columnIndex;
                                _sortAsc = _sortNameAsc;
                              }
                            });
                          },
                        ),
                      ],
                      rows: [
                        for (var d in documentSnapshot)
                          dataRow(
                              no++, d['nis'], d['nama'], d['kelas'], context, d)
                      ],
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  DataRow dataRow(int no, String nis, nama, kelas, context, dyn) {
    return DataRow(
      cells: <DataCell>[
        DataCell(
          Text(
            no.toString(),
          ),
        ),
        DataCell(
          ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 60),
              child: Text(
                nis,
                overflow: TextOverflow.ellipsis,
              )),
          onTap: () => tapped(nis, nama, kelas, context, dyn),
        ),
        DataCell(
          ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 150),
              child: Text(
                nama,
                overflow: TextOverflow.ellipsis,
              )),
          onTap: () => tapped(nis, nama, kelas, context, dyn),
        ),
        DataCell(
          ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 60),
              child: Text(
                kelas,
                overflow: TextOverflow.ellipsis,
              )),
          onTap: () => tapped(nis, nama, kelas, context, dyn),
        ),
      ],
    );
  }

  void tapped(nis, nama, kelas, context, dyn) {
    final height = MediaQuery.of(context).size.height;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Detail Data Siswa'),
            content: Container(
              height: height / 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(nis.toString()),
                  Text(nama),
                  Text(kelas),
                  Text("datang ${dyn['datang']}"),
                  Text("pulang ${dyn['pulang']}"),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  color: Colors.blue,
                  child: Text("Close"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }
}
