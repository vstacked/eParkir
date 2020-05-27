import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eparkir/services/firestore/databaseReference.dart';
import 'package:eparkir/view-models/homeUserViewModel.dart';
import 'package:eparkir/widgets/common/logOut.dart';
import 'package:eparkir/widgets/common/welcome.dart';
import 'package:eparkir/widgets/user/type1.dart';
import 'package:eparkir/widgets/user/type2.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class Home extends StatefulWidget {
  final String id;
  Home({this.id});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  HomeUserViewModel homeUserViewModel = HomeUserViewModel();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: ViewModelBuilder<HomeUserViewModel>.reactive(
        viewModelBuilder: () => homeUserViewModel,
        onModelReady: (model) => model.initState(widget.id),
        disposeViewModel: false,
        builder: (context, model, child) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: StreamBuilder(
              stream: databaseReference
                  .collection('siswa')
                  .document(widget.id)
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                bool hadir = (snapshot?.data != null)
                    ? snapshot.data.data['hadir']
                    : false;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Welcome(
                              id: widget.id,
                            ),
                            LogOut(
                              id: widget.id,
                            )
                          ]),
                    ),
                    (hadir)
                        ? type2(height, width, model, widget.id)
                        : type1(height, width, model, widget.id, context)
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
