import 'package:eparkir/screens/admin/page/scanner.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => Scanner())),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Selamat Datang, Admin"),
                    GestureDetector(
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.highlight_off,
                            color: Colors.red,
                            size: 20,
                          ),
                          Text(
                            "Log Out",
                            style: TextStyle(color: Colors.red, fontSize: 10),
                          )
                        ],
                      ),
                      onTap: () {
                        print("avengers");
                      },
                    )
                  ]),
            ),
            Container(
              width: width,
              height: height / 4.5,
              color: Colors.amber,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[Text("Belum Hadir"), Text("10")],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[Text("Hadir"), Text("26")],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[Text("Jumlah"), Text("36")],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.search,
                          color: Colors.red,
                        ),
                        Text(
                          "Search",
                          style: TextStyle(color: Colors.red),
                        )
                      ],
                    ),
                    onTap: () {
                      print("avengers");
                    },
                  ),
                  RaisedButton(
                    color: Colors.white,
                    child: Text(
                      "History",
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {},
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(color: Colors.red)),
                  ),
                ],
              ),
            ),
            Text("urutkan berdasarkan"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
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
                  dataRow(1, 17006912, 'aku', 'XII TITL A'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow dataRow(int no, int nis, nama, kelas) {
    return DataRow(
      cells: <DataCell>[
        DataCell(Text(no.toString())),
        DataCell(ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 60),
            child: Text(
              nis.toString(),
              overflow: TextOverflow.ellipsis,
            ))),
        DataCell(ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 150),
            child: Text(
              nama,
              overflow: TextOverflow.ellipsis,
            ))),
        DataCell(ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 60),
            child: Text(
              kelas,
              overflow: TextOverflow.ellipsis,
            ))),
      ],
    );
  }
}
