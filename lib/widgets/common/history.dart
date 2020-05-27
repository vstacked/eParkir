import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eparkir/services/firestore/databaseReference.dart';
import 'package:eparkir/view-models/historyViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class HistoryBody extends StatefulWidget {
  final double width;
  final double height;
  HistoryBody({@required this.width, @required this.height});
  @override
  _HistoryBodyState createState() => _HistoryBodyState();
}

class _HistoryBodyState extends State<HistoryBody> {
  HistoryViewModel historyViewModel = HistoryViewModel();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HistoryViewModel>.reactive(
      viewModelBuilder: () => historyViewModel,
      onModelReady: (model) => model.initState(),
      builder: (context, model, child) {
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
                        (model.selectedDate != null)
                            ? DateFormat('EEEE, d MMM, yyyy')
                                .format(model.selectedDate)
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
                        model.pickDateDialog(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
            TextField(
              controller: model.tecSearch,
              focusNode: model.searchNode,
              onChanged: (val) {
                setState(() {
                  model.textSearch = val;
                });
              },
              decoration: new InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search...',
                  suffixIcon: (model.textSearch != '')
                      ? IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              model.textSearch = "";
                            });

                            Future.delayed(Duration(milliseconds: 50))
                                .then((_) {
                              model.tecSearch.clear();
                              model.searchNode.unfocus();
                            });
                          },
                        )
                      : null),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0, left: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Urutkan berdasarkan :"),
                  GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 1.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Reset")),
                    ),
                    onTap: () {
                      setState(() {
                        model.orderByValue = null;
                        model.sortColumnIndex = null;
                      });
                    },
                  ),
                ],
              ),
            ),
            Flexible(
              child: Container(
                width: double.infinity,
                height: widget.height,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: StreamBuilder(
                      stream: (model.textSearch != '')
                          ? databaseReference
                              .collection('database')
                              .document('tanggal')
                              .collection(model.datePick)
                              .where('nisSearch',
                                  arrayContains: model.textSearch)
                              .snapshots()
                          : (model.orderByValue != null)
                              ? databaseReference
                                  .collection('database')
                                  .document('tanggal')
                                  .collection(model.datePick)
                                  .orderBy(model.orderByValue,
                                      descending: !model.sortAsc)
                                  .snapshots()
                              : databaseReference
                                  .collection('database')
                                  .document('tanggal')
                                  .collection(model.datePick)
                                  .orderBy('datang')
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
                            sortColumnIndex: model.sortColumnIndex,
                            sortAscending: model.sortAsc,
                            columns: <DataColumn>[
                              DataColumn(
                                label: Text("No."),
                              ),
                              DataColumn(
                                label: Text("NIS"),
                                onSort: (columnIndex, sortAscending) {
                                  print(sortAscending);
                                  model.orderByValue = 'nis';
                                  setState(() {
                                    if (columnIndex == model.sortColumnIndex) {
                                      model.sortAsc =
                                          model.sortNisAsc = sortAscending;
                                    } else {
                                      model.sortColumnIndex = columnIndex;
                                      model.sortAsc = model.sortNisAsc;
                                    }
                                  });
                                },
                              ),
                              DataColumn(
                                label: Text("Nama"),
                                onSort: (columnIndex, sortAscending) {
                                  print(sortAscending);
                                  model.orderByValue = 'nama';
                                  setState(() {
                                    if (columnIndex == model.sortColumnIndex) {
                                      model.sortAsc =
                                          model.sortNameAsc = sortAscending;
                                    } else {
                                      model.sortColumnIndex = columnIndex;
                                      model.sortAsc = model.sortNameAsc;
                                    }
                                  });
                                },
                              ),
                              DataColumn(
                                label: Text("Kelas"),
                                onSort: (columnIndex, sortAscending) {
                                  print(sortAscending);
                                  model.orderByValue = 'kelas';
                                  setState(() {
                                    if (columnIndex == model.sortColumnIndex) {
                                      model.sortAsc =
                                          model.sortKelasAsc = sortAscending;
                                    } else {
                                      model.sortColumnIndex = columnIndex;
                                      model.sortAsc = model.sortKelasAsc;
                                    }
                                  });
                                },
                              ),
                            ],
                            rows: [
                              for (var d in documentSnapshot)
                                dataRow(no++, d['nis'], d['nama'], d['kelas'],
                                    context, d, model)
                            ]);
                      }),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}

DataRow dataRow(
    int no, String nis, nama, kelas, context, dyn, HistoryViewModel model) {
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
        onTap: () => model.tapped(nis, nama, kelas, context, dyn),
      ),
      DataCell(
        ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 150),
            child: Text(
              nama,
              overflow: TextOverflow.ellipsis,
            )),
        onTap: () => model.tapped(nis, nama, kelas, context, dyn),
      ),
      DataCell(
        ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 60),
            child: Text(
              kelas,
              overflow: TextOverflow.ellipsis,
            )),
        onTap: () => model.tapped(nis, nama, kelas, context, dyn),
      ),
    ],
  );
}
