import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eparkir/services/firestore/databaseReference.dart';
import 'package:eparkir/view-models/showAllViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ShowAll extends StatefulWidget {
  @override
  _ShowAllState createState() => _ShowAllState();
}

class _ShowAllState extends State<ShowAll> {
  ShowAllViewModel showAllViewModel = ShowAllViewModel();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return ViewModelBuilder<ShowAllViewModel>.reactive(
      viewModelBuilder: () => showAllViewModel,
      onModelReady: (model) => model.initState(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: model.appBarTitle,
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  child: model.searchIcon,
                  onTap: () => model.searchPressed(),
                ),
              )
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
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
                  height: height,
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
      },
    );
  }

  DataRow dataRow(
      int no, String nis, nama, kelas, context, dyn, ShowAllViewModel model) {
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
}
