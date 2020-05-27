import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eparkir/services/firestore/databaseReference.dart';
import 'package:eparkir/view-models/showAllViewModel.dart';
import 'package:eparkir/widgets/admin/dataRowShowAll.dart';
import 'package:flutter/material.dart';

class BuildTableShowAll extends StatefulWidget {
  BuildTableShowAll({@required this.height, @required this.model});
  final double height;
  final ShowAllViewModel model;
  @override
  _BuildTableShowAllState createState() => _BuildTableShowAllState();
}

class _BuildTableShowAllState extends State<BuildTableShowAll> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        width: double.infinity,
        height: widget.height,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: StreamBuilder(
            stream: (widget.model.textSearch != '')
                ? databaseReference
                    .collection('database')
                    .document('tanggal')
                    .collection(widget.model.datePick)
                    .where('nisSearch', arrayContains: widget.model.textSearch)
                    .snapshots()
                : (widget.model.orderByValue != null)
                    ? databaseReference
                        .collection('database')
                        .document('tanggal')
                        .collection(widget.model.datePick)
                        .orderBy(widget.model.orderByValue,
                            descending: !widget.model.sortAsc)
                        .snapshots()
                    : databaseReference
                        .collection('database')
                        .document('tanggal')
                        .collection(widget.model.datePick)
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
                sortColumnIndex: widget.model.sortColumnIndex,
                sortAscending: widget.model.sortAsc,
                columns: <DataColumn>[
                  DataColumn(
                    label: Text("No."),
                  ),
                  DataColumn(
                    label: Text("NIS"),
                    onSort: (columnIndex, sortAscending) {
                      print(sortAscending);
                      widget.model.orderByValue = 'nis';
                      setState(() {
                        if (columnIndex == widget.model.sortColumnIndex) {
                          widget.model.sortAsc =
                              widget.model.sortNisAsc = sortAscending;
                        } else {
                          widget.model.sortColumnIndex = columnIndex;
                          widget.model.sortAsc = widget.model.sortNisAsc;
                        }
                      });
                    },
                  ),
                  DataColumn(
                    label: Text("Nama"),
                    onSort: (columnIndex, sortAscending) {
                      print(sortAscending);
                      widget.model.orderByValue = 'nama';
                      setState(() {
                        if (columnIndex == widget.model.sortColumnIndex) {
                          widget.model.sortAsc =
                              widget.model.sortNameAsc = sortAscending;
                        } else {
                          widget.model.sortColumnIndex = columnIndex;
                          widget.model.sortAsc = widget.model.sortNameAsc;
                        }
                      });
                    },
                  ),
                  DataColumn(
                    label: Text("Kelas"),
                    onSort: (columnIndex, sortAscending) {
                      print(sortAscending);
                      widget.model.orderByValue = 'kelas';
                      setState(() {
                        if (columnIndex == widget.model.sortColumnIndex) {
                          widget.model.sortAsc =
                              widget.model.sortKelasAsc = sortAscending;
                        } else {
                          widget.model.sortColumnIndex = columnIndex;
                          widget.model.sortAsc = widget.model.sortKelasAsc;
                        }
                      });
                    },
                  ),
                ],
                rows: [
                  for (var d in documentSnapshot)
                    dataRow(no++, d['nis'], d['nama'], d['kelas'], context, d,
                        widget.model)
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
