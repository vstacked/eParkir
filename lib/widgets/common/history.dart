import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eparkir/services/firestore/databaseReference.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryBody extends StatefulWidget {
  final double width;
  final double height;
  HistoryBody({@required this.width, @required this.height});
  @override
  _HistoryBodyState createState() => _HistoryBodyState();
}

class _HistoryBodyState extends State<HistoryBody> {
  DateTime _selectedDate;
  String datePick = DateFormat('dd-MM-yyyy').format(DateTime.now());

  bool _sortNameAsc = true;
  bool _sortAsc = true;
  int _sortColumnIndex;

  String orderByValue;

  void _pickDateDialog() {
    showDatePicker(
            context: context,
            initialDate:
                (_selectedDate != null) ? _selectedDate : DateTime.now(),
            //which date will display when user open the picker
            firstDate: DateTime(1950),
            //what will be the previous supported year in picker
            lastDate: DateTime
                .now()) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {
        //if user tap cancel then this function will stop
        return;
      }
      setState(() {
        //for rebuilding the ui
        _selectedDate = pickedDate;
        datePick = DateFormat('dd-MM-yyyy').format(_selectedDate);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: widget.width / 1.6,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 1.5),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    (_selectedDate != null)
                        ? DateFormat('EEEE, d MMM, yyyy').format(_selectedDate)
                        : DateFormat('EEEE, d MMM, yyyy')
                            .format(DateTime.now()),
                  ),
                ),
              ),
              SizedBox(
                width: 15.0,
              ),
              Expanded(
                child: GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 1.5),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Choose Date")),
                  ),
                  onTap: () {
                    _pickDateDialog();
                  },
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0, left: 8.0),
          child: Text("Urutkan berdasarkan :"),
        ),
        Flexible(
          child: Container(
            width: double.infinity,
            height: widget.height,
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
                            dataRow(no++, d['nis'], d['nama'], d['kelas'],
                                context, d)
                        ]);
                  }),
            ),
          ),
        )
      ],
    );
  }
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
