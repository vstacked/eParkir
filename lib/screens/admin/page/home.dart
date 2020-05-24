import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eparkir/screens/admin/page/history.dart';
import 'package:eparkir/screens/admin/page/scanner.dart';
import 'package:eparkir/screens/admin/page/showAll.dart';
import 'package:eparkir/screens/login.dart';
import 'package:eparkir/services/firestore/databaseReference.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  final String id;
  Home({this.id});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void resetPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt("value", 2);
    preferences.setString("id", '');
  }

  String datePick = DateFormat('dd-MM-yyyy').format(DateTime.now());

  void changeToFalse() async {
    var test2 = await databaseReference
        .collection('siswa')
        .where('hadir', isEqualTo: true)
        .getDocuments();
    test2.documents.forEach((f) {
      String id = f.documentID;
      Firestore.instance
          .collection('siswa')
          .document(id)
          .updateData({'hadir': false});
    });
  }

  void checkDay() async {
    var test2 = await databaseReference
        .collection('database')
        .document('tanggal')
        .collection(datePick)
        .getDocuments();

    if (test2.documents.length == 0) {
      changeToFalse();
    }
  }

  @override
  void initState() {
    super.initState();
    checkDay();
  }

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
                child: StreamBuilder(
                  stream: databaseReference
                      .collection('database')
                      .document('tanggal')
                      .collection(datePick)
                      .orderBy('datang')
                      .limit(10)
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
                      columns: <DataColumn>[
                        DataColumn(
                          label: Text("No."),
                        ),
                        DataColumn(
                          label: Text("NIS"),
                        ),
                        DataColumn(
                          label: Text("Nama"),
                        ),
                        DataColumn(
                          label: Text("Kelas"),
                        ),
                        DataColumn(
                          label: Text("Datang"),
                        ),
                      ],
                      rows: [
                        for (var d in documentSnapshot)
                          dataRow(no++, d['nis'], d['nama'], d['kelas'],
                              d['datang'])
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
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
        child: StreamBuilder(
            stream: databaseReference
                .collection('siswa')
                .where('level', isEqualTo: 0)
                .snapshots(),
            builder: (context, snapshot) {
              QuerySnapshot data = snapshot.data;
              int total = (data?.documents != null) ? data.documents.length : 0;
              int hadir = 0;
              int belumHadir = 0;

              List<DocumentSnapshot> documentSnapshot =
                  (data?.documents != null) ? data.documents : [];
              documentSnapshot.forEach((f) {
                bool a = f.data['hadir'];
                switch (a) {
                  case true:
                    hadir++;

                    break;
                  default:
                }
              });
              belumHadir = (hadir != 0) ? total - hadir : total;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Belum Hadir"),
                      Text("$belumHadir")
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[Text("Hadir"), Text("$hadir")],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[Text("Jumlah"), Text("$total")],
                  ),
                ],
              );
            }),
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
        resetPref();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Login()),
          (Route<dynamic> route) => false,
        );
      },
    );
  }

  StreamBuilder<DocumentSnapshot> welcome() {
    return StreamBuilder(
      stream:
          databaseReference.collection('siswa').document(widget.id).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          String nama =
              (snapshot.data.exists) ? snapshot.data.data['nama'] : '';
          return ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 250),
              child: Text(
                "Selamat Datang, $nama",
                overflow: TextOverflow.ellipsis,
              ));
        }
      },
    );
  }

  DataRow dataRow(int no, String nis, nama, kelas, datang) {
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
            constraints: BoxConstraints(maxWidth: 80),
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
        DataCell(ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 60),
            child: Text(
              datang,
              overflow: TextOverflow.ellipsis,
            ))),
      ],
    );
  }
}
