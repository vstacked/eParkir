import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eparkir/view-models/dataViewModel.dart';
import 'package:eparkir/widgets/admin/dataRowData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
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
      backgroundColor: Colors.teal[100],
      key: dataViewModel.scaffoldKey,
      body: ViewModelBuilder<DataViewModel>.reactive(
        viewModelBuilder: () => dataViewModel,
        onModelReady: (model) => model.initState(),
        builder: (context, model, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildAppbar(model, height, context, width),
              buildTable(height, model),
            ],
          );
        },
      ),
    );
  }

  Widget buildTable(double height, DataViewModel model) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Container(
          width: double.infinity,
          height: height,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.1, 0.1),
                  blurRadius: 0.25,
                  spreadRadius: 0.25,
                )
              ]),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: StreamBuilder(
                    stream: (model.textSearch != '')
                        ? model.services.whenSearchSiswa(model.textSearch)
                        : (model.orderByValue != null)
                            ? model.services.whenOrderSiswa(
                                model.orderByValue, !model.sortAsc)
                            : model.services.whenNoOrderSiswa(),
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
                            label: Text("No.", style: model.style.desc),
                          ),
                          DataColumn(
                            label: Text("NIS", style: model.style.desc),
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
                            label: Text("Nama", style: model.style.desc),
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
                            label: Text("Kelas", style: model.style.desc),
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
                SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding buildAppbar(
      DataViewModel model, double height, BuildContext context, double width) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.circular(5),
            ),
            child: IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              tooltip: 'Add Data',
              onPressed: () =>
                  {model.addData(height, context), model.searchUnfocus},
            ),
          ),
          Flexible(
            child: Container(
              width: width,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.teal,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              child: TextField(
                controller: model.tecSearch,
                focusNode: model.searchNode,
                onChanged: (val) {
                  setState(() {
                    model.textSearch = val;
                  });
                },
                style: model.style.desc,
                keyboardType: TextInputType.number,
                decoration: new InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.teal,
                    ),
                    hintStyle: model.style.desc,
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
                                model.tecClear;
                                model.searchUnfocus;
                              });
                            },
                          )
                        : null),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.circular(5),
            ),
            child: IconButton(
              tooltip: 'Reset',
              icon: Icon(
                MaterialCommunityIcons.restart,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  model.orderByValue = null;
                  model.sortColumnIndex = null;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
