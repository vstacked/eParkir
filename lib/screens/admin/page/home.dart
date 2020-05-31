import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eparkir/screens/admin/page/showAll.dart';
import 'package:eparkir/view-models/homeAdminViewModel.dart';
import 'package:eparkir/widgets/admin/dataRowHome.dart';
import 'package:eparkir/widgets/admin/info.dart';
import 'package:eparkir/widgets/common/background.dart';
import 'package:eparkir/widgets/common/logOut.dart';
import 'package:eparkir/widgets/common/welcome.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
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
      body: ViewModelBuilder<HomeAdminViewModel>.reactive(
        viewModelBuilder: () => homeAdminViewModel,
        onModelReady: (model) => model.initState(),
        builder: (context, model, child) {
          return Stack(
            children: <Widget>[
              buildBackground(width, height),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 30.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Welcome(id: widget.id),
                          LogOut(id: widget.id)
                        ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: info(width, height),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 5.0),
                    child: Divider(
                      thickness: 0.3,
                      color: Colors.teal,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Container(
                        width: width,
                        height: height,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.1, 0.1),
                                blurRadius: 0.25,
                                spreadRadius: 0.25,
                              )
                            ]),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(5.0),
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: <Widget>[
                              StreamBuilder(
                                stream:
                                    model.services.sortLimit10(model.datePick),
                                builder: (context, snapshot) {
                                  int no = 1;
                                  QuerySnapshot data = snapshot.data;
                                  List<DocumentSnapshot> documentSnapshot =
                                      (data?.documents != null)
                                          ? data.documents
                                          : [];
                                  return Container(
                                    width: width,
                                    child: DataTable(
                                      horizontalMargin: 10,
                                      headingRowHeight: 40,
                                      columnSpacing: 10,
                                      columns: <DataColumn>[
                                        DataColumn(
                                            label: Text("No.",
                                                style: model.style.desc)),
                                        DataColumn(
                                            label: Text("NIS",
                                                style: model.style.desc)),
                                        DataColumn(
                                            label: Text("Nama",
                                                style: model.style.desc)),
                                        DataColumn(
                                            label: Text("Kelas",
                                                style: model.style.desc)),
                                        DataColumn(
                                            label: Text("Datang",
                                                style: model.style.desc)),
                                      ],
                                      rows: [
                                        for (var d in documentSnapshot)
                                          dataRow(no++, d['nis'], d['nama'],
                                              d['kelas'], d['datang'])
                                      ],
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: 90,
                                height: 25,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.lightGreen,
                                ),
                                child: Center(
                                  child: GestureDetector(
                                    child: Text(
                                      "More Detail",
                                      style: model.style.desc.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    onTap: () => Navigator.of(context,
                                            rootNavigator: true)
                                        .push(
                                      MaterialPageRoute(
                                        builder: (context) => ShowAll(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 35,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
