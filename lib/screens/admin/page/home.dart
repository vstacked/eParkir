import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eparkir/screens/admin/page/history.dart';
import 'package:eparkir/screens/admin/page/scanner.dart';
import 'package:eparkir/screens/admin/page/showAll.dart';
import 'package:eparkir/services/firestore/databaseReference.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final String id;
  Home({this.id});
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[welcome(), logOut()]),
          ),
          info(width, height),
          info2(context),
          filter(context),
          Divider(
            thickness: 0.5,
            color: Colors.black,
            indent: 20,
            endIndent: 20,
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              height: height,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: table(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DataTable table() {
    return DataTable(
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
        dataRow(1, 17006912, 'akasdsadasdsadsasdsadasdasdsadsadsadsau',
            'XII RPL A'),
        dataRow(2, 17006912, 'aku', 'XII RPL A'),
        dataRow(1, 17006912, 'aku', 'XII RPL A'),
        dataRow(1, 17006912, 'aku', 'XII RPL A'),
        dataRow(1, 17006912, 'aku', 'XII RPL A'),
        dataRow(1, 17006912, 'aku', 'XII RPL A'),
        dataRow(1, 17006912, 'aku', 'XII RPL A'),
        dataRow(1, 17006112, 'aku', 'XII RPL A'),
        dataRow(1, 17006912, 'aku', 'XII RPL A'),
        dataRow(1, 17006912, 'aku', 'XII TITL A'),
        dataRow(1, 17006912, 'aku', 'XII TITL A'),
        dataRow(1, 17006912, 'aku', 'XII TITL A'),
        dataRow(1, 17006912, 'aku', 'XII TITL A'),
        dataRow(1, 17006912, 'aku', 'XII TITL A'),
      ],
    );
  }

  Padding filter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("urutkan berdasarkan"),
          GestureDetector(
            child: Text(
              "show all",
              style: TextStyle(color: Colors.blue),
            ),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ShowAll()));
            },
          ),
        ],
      ),
    );
  }

  Padding info2(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("Daftar Hadir Hari ini :"),
          RaisedButton(
            color: Colors.white,
            child: Text(
              "History",
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => History()));
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Container info(double width, double height) {
    return Container(
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
    );
  }

  GestureDetector logOut() {
    return GestureDetector(
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
        print("GestureDetector Tapped");
      },
    );
  }

  StreamBuilder<DocumentSnapshot> welcome() {
    return StreamBuilder(
      stream:
          databaseReference.collection('db').document(widget.id).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text(
            '',
          );
        } else {
          String nama = snapshot.data['nama'];
          return Text("Selamat Datang, $nama");
        }
      },
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
