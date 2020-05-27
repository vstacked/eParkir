import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eparkir/screens/admin/page/scanner.dart';
import 'package:eparkir/services/firestore/databaseReference.dart';
import 'package:eparkir/view-models/homeAdminViewModel.dart';
import 'package:eparkir/widgets/admin/dataRowHome.dart';
import 'package:eparkir/widgets/admin/filter.dart';
import 'package:eparkir/widgets/admin/info.dart';
import 'package:eparkir/widgets/admin/info2.dart';
import 'package:eparkir/widgets/common/logOut.dart';
import 'package:eparkir/widgets/common/welcome.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class Home extends StatefulWidget {
  final String id;
  Home({this.id});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  HomeAdminViewModel homeAdminViewModel = HomeAdminViewModel();

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
      body: ViewModelBuilder<HomeAdminViewModel>.reactive(
        viewModelBuilder: () => homeAdminViewModel,
        onModelReady: (model) => model.initState(),
        builder: (context, model, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Welcome(id: widget.id),
                      LogOut(id: widget.id)
                    ]),
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
                          .collection(model.datePick)
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
                            DataColumn(label: Text("No.")),
                            DataColumn(label: Text("NIS")),
                            DataColumn(label: Text("Nama")),
                            DataColumn(label: Text("Kelas")),
                            DataColumn(label: Text("Datang")),
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
          );
        },
      ),
    );
  }
}
