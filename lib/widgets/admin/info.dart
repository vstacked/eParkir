import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eparkir/screens/admin/page/history.dart';
import 'package:eparkir/services/firestore/databaseReference.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.widget.dart';

Container info(double width, double height) {
  TextStyle titleStyle = TextStyle(fontSize: 12.0, fontFamily: 'Jura');
  TextStyle numberStyle = TextStyle(fontSize: 50.0, fontFamily: 'Jura');
  return Container(
    width: width,
    height: height / 4.5,
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "$hadir",
                          style: numberStyle.copyWith(color: Colors.lightGreen),
                        ),
                        Text(
                          "Hadir",
                          style: titleStyle.copyWith(color: Colors.lightGreen),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "$belumHadir",
                          style: numberStyle.copyWith(color: Colors.redAccent),
                        ),
                        Text(
                          "Belum Hadir",
                          style: titleStyle.copyWith(color: Colors.redAccent),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "$total",
                          style: numberStyle.copyWith(color: Colors.teal),
                        ),
                        Text(
                          "Jumlah",
                          style: titleStyle.copyWith(color: Colors.teal),
                        ),
                      ],
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 60,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.teal,
                    ),
                    child: Center(
                      child: GestureDetector(
                        child: Text(
                          "History",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Jura',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        onTap: () =>
                            Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (context) => History(),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
          }),
    ),
  );
}
