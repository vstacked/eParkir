import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eparkir/view-models/historyViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
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
          children: <Widget>[
            Container(
              width: widget.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 250),
                      child: Text(
                        (model.selectedDate != null)
                            ? DateFormat('EEEE, d MMM, yyyy')
                                .format(model.selectedDate)
                            : DateFormat('EEEE, d MMM, yyyy')
                                .format(DateTime.now()),
                        overflow: TextOverflow.ellipsis,
                        style: model.style.desc.copyWith(fontSize: 20.0),
                      ),
                    ),
                    GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "Choose Date",
                            style:
                                model.style.desc.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                      onTap: () {
                        model.pickDateDialog(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              child: Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.2, 0.2),
                        blurRadius: 0.5,
                        spreadRadius: 0.5,
                      )
                    ]),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              flex: 9,
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.teal),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: TextField(
                                  style: model.style.desc,
                                  cursorColor: Colors.teal,
                                  controller: model.tecSearch,
                                  focusNode: model.searchNode,
                                  keyboardType: TextInputType.number,
                                  onChanged: (val) {
                                    setState(() {
                                      model.textSearch = val;
                                    });
                                  },
                                  decoration: new InputDecoration(
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        Icons.search,
                                        color: Colors.teal,
                                      ),
                                      hintText: 'Search NIS...',
                                      hintStyle: model.style.desc,
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
                                                  model.tecSearch.clear();
                                                  model.searchNode.unfocus();
                                                });
                                              },
                                            )
                                          : null),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: IconButton(
                                tooltip: 'Reset',
                                icon: Icon(
                                  MaterialCommunityIcons.restart,
                                  color: Colors.teal,
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
                      ),
                      Container(
                        width: widget.width,
                        child: StreamBuilder(
                            stream: (model.textSearch != '')
                                ? model.services.whenSearch(
                                    model.datePick, model.textSearch)
                                : (model.orderByValue != null)
                                    ? model.services.whenOrder(model.datePick,
                                        model.orderByValue, !model.sortAsc)
                                    : model.services
                                        .whenNoOrder(model.datePick),
                            builder: (context, snapshot) {
                              int no = 1;
                              QuerySnapshot data = snapshot.data;
                              List<DocumentSnapshot> documentSnapshot =
                                  (data?.documents != null)
                                      ? data.documents
                                      : [];

                              return DataTable(
                                  horizontalMargin: 10,
                                  headingRowHeight: 40,
                                  columnSpacing: 10,
                                  sortColumnIndex: model.sortColumnIndex,
                                  sortAscending: model.sortAsc,
                                  columns: <DataColumn>[
                                    DataColumn(
                                      label: Text(
                                        "No.",
                                        style: model.style.desc,
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "NIS",
                                        style: model.style.desc,
                                      ),
                                      onSort: (columnIndex, sortAscending) {
                                        print(sortAscending);
                                        model.orderByValue = 'nis';
                                        setState(() {
                                          if (columnIndex ==
                                              model.sortColumnIndex) {
                                            model.sortAsc = model.sortNisAsc =
                                                sortAscending;
                                          } else {
                                            model.sortColumnIndex = columnIndex;
                                            model.sortAsc = model.sortNisAsc;
                                          }
                                        });
                                      },
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "Nama",
                                        style: model.style.desc,
                                      ),
                                      onSort: (columnIndex, sortAscending) {
                                        print(sortAscending);
                                        model.orderByValue = 'nama';
                                        setState(() {
                                          if (columnIndex ==
                                              model.sortColumnIndex) {
                                            model.sortAsc = model.sortNameAsc =
                                                sortAscending;
                                          } else {
                                            model.sortColumnIndex = columnIndex;
                                            model.sortAsc = model.sortNameAsc;
                                          }
                                        });
                                      },
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "Kelas",
                                        style: model.style.desc,
                                      ),
                                      onSort: (columnIndex, sortAscending) {
                                        print(sortAscending);
                                        model.orderByValue = 'kelas';
                                        setState(() {
                                          if (columnIndex ==
                                              model.sortColumnIndex) {
                                            model.sortAsc = model.sortKelasAsc =
                                                sortAscending;
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
                                      dataRow(no++, d['nis'], d['nama'],
                                          d['kelas'], context, d, model)
                                  ]);
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
          style: model.style.desc,
        ),
      ),
      DataCell(
        ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 60),
            child: Text(
              nis,
              overflow: TextOverflow.ellipsis,
              style: model.style.desc,
            )),
        onTap: () => model.tapped(nis, nama, kelas, context, dyn),
      ),
      DataCell(
        ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 150),
            child: Text(
              nama,
              overflow: TextOverflow.ellipsis,
              style: model.style.desc,
            )),
        onTap: () => model.tapped(nis, nama, kelas, context, dyn),
      ),
      DataCell(
        ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 60),
            child: Text(
              kelas,
              overflow: TextOverflow.ellipsis,
              style: model.style.desc,
            )),
        onTap: () => model.tapped(nis, nama, kelas, context, dyn),
      ),
    ],
  );
}
