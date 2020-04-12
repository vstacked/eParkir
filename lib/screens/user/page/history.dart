import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Container(
                  width: width / 1.6,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 1.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Senin, xx xx xxxx"),
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
                      chooseDate();
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

  void chooseDate() {
    final height = MediaQuery.of(context).size.height;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Detail Data Siswa'),
            content: Container(
              height: height / 5,
              child: CupertinoDatePicker(
                onDateTimeChanged: (_) {},
              ),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.blue,
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
