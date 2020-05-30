import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eparkir/services/firestore.dart';
import 'package:eparkir/utils/textStyle.dart';
import 'package:eparkir/view-models/showAllViewModel.dart';
import 'package:eparkir/widgets/admin/dataRowShowAll.dart';
import 'package:flutter/material.dart';

class BuildTableShowAll extends StatefulWidget {
  BuildTableShowAll(
      {@required this.height, @required this.model, @required this.width});
  final double height;
  final double width;
  final ShowAllViewModel model;
  @override
  _BuildTableShowAllState createState() => _BuildTableShowAllState();
}

class _BuildTableShowAllState extends State<BuildTableShowAll> {
  FirestoreServices services = FirestoreServices();
  TxtStyle style = TxtStyle();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.2, 0.2),
              blurRadius: 0.5,
              spreadRadius: 0.5,
            )
          ]),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: StreamBuilder(
          stream: (widget.model.textSearch != '')
              ? services.whenSearch(
                  widget.model.datePick, widget.model.textSearch)
              : (widget.model.orderByValue != null)
                  ? services.whenOrder(widget.model.datePick,
                      widget.model.orderByValue, !widget.model.sortAsc)
                  : services.whenNoOrder(widget.model.datePick),
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
                  label: Text(
                    "No.",
                    style: style.desc,
                  ),
                ),
                DataColumn(
                  label: Text(
                    "NIS",
                    style: style.desc,
                  ),
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
                  label: Text(
                    "Nama",
                    style: style.desc,
                  ),
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
                  label: Text(
                    "Kelas",
                    style: style.desc,
                  ),
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
    );
  }
}
