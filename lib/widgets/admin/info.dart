import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eparkir/services/firestore/databaseReference.dart';
import 'package:flutter/material.dart';

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
                  children: <Widget>[Text("Belum Hadir"), Text("$belumHadir")],
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
