import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowAll extends StatefulWidget {
  @override
  _ShowAllState createState() => _ShowAllState();
}

class _ShowAllState extends State<ShowAll> {
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
                child: DataTable(
                  sortColumnIndex: 0,
                  horizontalMargin: 10,
                  headingRowHeight: 40,
                  columnSpacing: 10,
                  sortAscending: true,
                  columns: <DataColumn>[
                    DataColumn(
                      label: Text("No."),
                    ),
                    DataColumn(label: Text("NIS")),
                    DataColumn(label: Text("Nama")),
                    DataColumn(label: Text("Kelas")),
                  ],
                  rows: <DataRow>[
                    dataRow(1, 17006912,
                        'akasdsadasdsadsasdsadasdasdsadsadsadsau', 'XII RPL A'),
                    dataRow(2, 17006912, 'aku', 'XII RPL A'),
                    dataRow(1, 17006912, 'aku', 'XII RPL A'),
                    dataRow(1, 17006912, 'aku', 'XII RPL A'),
                    dataRow(1, 17006912, 'aku', 'XII RPL A'),
                    dataRow(1, 17006912, 'aku', 'XII RPL A'),
                    dataRow(1, 17006912, 'aku', 'XII RPL A'),
                    dataRow(1, 17006112, 'aku', 'XII RPL A'),
                    dataRow(1, 17006912, 'aku', 'XII RPL A'),
                    dataRow(1, 17006912, 'aku', 'XII RPL A'),
                    dataRow(1, 17006912, 'aku', 'XII RPL A'),
                    dataRow(1, 17006912, 'aku', 'XII RPL A'),
                    dataRow(1, 17006912, 'aku', 'XII TITL A'),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  DataRow dataRow(int no, int nis, nama, kelas) {
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
                nis.toString(),
                overflow: TextOverflow.ellipsis,
              )),
        ),
        DataCell(
          ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 150),
              child: Text(
                nama,
                overflow: TextOverflow.ellipsis,
              )),
        ),
        DataCell(
          ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 60),
              child: Text(
                kelas,
                overflow: TextOverflow.ellipsis,
              )),
        ),
      ],
    );
  }
}
