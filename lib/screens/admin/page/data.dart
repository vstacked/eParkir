import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eparkir/services/firestore/databaseReference.dart';
import 'package:eparkir/view-models/dataViewModel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class Data extends StatefulWidget {
  @override
  _DataState createState() => _DataState();
}

class _DataState extends State<Data> {
  DataViewModel dataViewModel = DataViewModel();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ViewModelBuilder<DataViewModel>.reactive(
        viewModelBuilder: () => dataViewModel,
        onModelReady: (model) => model.initState(),
        builder: (context, model, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    (model.showSearch == false)
                        ? Container(
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(30)),
                            child: IconButton(
                              icon: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              tooltip: 'Add Data',
                              onPressed: () => model.addData(height, context),
                            ),
                          )
                        : Container(),
                    (model.showSearch == false)
                        ? Text("Data Siswa")
                        : Container(),
                    Flexible(
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        width: (model.showSearch == false) ? width / 5 : width,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 1.5),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: <Widget>[
                            GestureDetector(
                              child: Container(
                                color: Colors.blue,
                                height: 50,
                                width: (model.showSearch == false) ? 30 : 50,
                                margin: EdgeInsets.only(right: 5),
                                child: (model.showSearch == false)
                                    ? Icon(
                                        Icons.arrow_left,
                                        color: Colors.white,
                                      )
                                    : Icon(
                                        Icons.arrow_right,
                                        color: Colors.white,
                                      ),
                              ),
                              onTap: () {
                                setState(() {
                                  model.showSearch = !model.showSearch;
                                  model.textSearch = "";
                                });
                                model.tecClear;
                              },
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            (model.showSearch == false)
                                ? Icon(Icons.search)
                                : Flexible(
                                    child: TextField(
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

                                                    Future.delayed(Duration(
                                                            milliseconds: 50))
                                                        .then((_) {
                                                      model.tecClear;
                                                      model.searchUnfocus;
                                                    });
                                                  },
                                                )
                                              : null),
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                              .collection('siswa')
                              .where('level', isEqualTo: 0)
                              .where('nisSearch',
                                  arrayContains: model.textSearch)
                              .snapshots()
                          : (model.orderByValue != null)
                              ? databaseReference
                                  .collection('siswa')
                                  .where('level', isEqualTo: 0)
                                  .orderBy(model.orderByValue,
                                      descending: !model.sortAsc)
                                  .snapshots()
                              : databaseReference
                                  .collection('siswa')
                                  .where('level', isEqualTo: 0)
                                  .orderBy('nis')
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
                                  context, d.documentID, model)
                          ],
                        );
                      },
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  DataRow dataRow(
      int no, String nis, nama, kelas, context, idUser, DataViewModel model) {
    return DataRow(
      cells: <DataCell>[
        DataCell(
          Text(
            no.toString(),
          ),
          onTap: () => model.tapped(nis, nama, kelas, context, idUser),
        ),
        DataCell(
          ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 60),
              child: Text(
                nis,
                overflow: TextOverflow.ellipsis,
              )),
          onTap: () => model.tapped(nis, nama, kelas, context, idUser),
        ),
        DataCell(
          ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 150),
              child: Text(
                nama,
                overflow: TextOverflow.ellipsis,
              )),
          onTap: () => model.tapped(nis, nama, kelas, context, idUser),
        ),
        DataCell(
          ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 60),
              child: Text(
                kelas,
                overflow: TextOverflow.ellipsis,
              )),
          onTap: () => model.tapped(nis, nama, kelas, context, idUser),
        ),
      ],
    );
  }
}
