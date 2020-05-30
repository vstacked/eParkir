import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eparkir/screens/admin/page/history.dart';
import 'package:eparkir/services/firestore.dart';
import 'package:eparkir/utils/textStyle.dart';
import 'package:flutter/material.dart';

Container info(double width, double height) {
  TextStyle titleStyle = TxtStyle().desc.copyWith(fontSize: 12.0);
  TextStyle numberStyle = TxtStyle().desc.copyWith(fontSize: 50.0);
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
          stream: FirestoreServices().getUser(),
          builder: (context, snapshot) {
            QuerySnapshot data = snapshot.data;
            int total = (data?.documents != null) ? data.documents.length : 0;
            int hadir = 0;
            int belumHadir = 0;
            List<DocumentSnapshot> documentSnapshot =
                (data?.documents != null) ? data.documents : [];
            int detailMotorHadir = 0;
            int detailSepedaHadir = 0;
            int detailMotorBelum = 0;
            int detailSepedaBelum = 0;
            int detailUnknown = 0;

            documentSnapshot.forEach((f) {
              bool a = f.data['hadir'];
              switch (a) {
                case true:
                  hadir++;
                  if (f.data['transportasi'] != '')
                    (f.data['transportasi'] == 'Motor')
                        ? detailMotorHadir++
                        : detailSepedaHadir++;
                  break;
                case false:
                  belumHadir++;
                  if (f.data['transportasi'] != '')
                    (f.data['transportasi'] == 'Motor')
                        ? detailMotorBelum++
                        : (f.data['transportasi'] == 'Sepeda')
                            ? detailSepedaBelum++
                            : detailUnknown++;
                  break;
                default:
              }
            });

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => showDialogDetail(context, detailMotorHadir,
                          detailSepedaHadir, hadir, null),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "$hadir",
                            style:
                                numberStyle.copyWith(color: Colors.lightGreen),
                          ),
                          Text(
                            "Hadir",
                            style:
                                titleStyle.copyWith(color: Colors.lightGreen),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => showDialogDetail(context, detailMotorBelum,
                          detailSepedaBelum, belumHadir, detailUnknown),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "$belumHadir",
                            style:
                                numberStyle.copyWith(color: Colors.redAccent),
                          ),
                          Text(
                            "Belum Hadir",
                            style: titleStyle.copyWith(color: Colors.redAccent),
                          ),
                        ],
                      ),
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
                          style: TxtStyle().desc.copyWith(
                                color: Colors.white,
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

void showDialogDetail(
    BuildContext context, int motor, int sepeda, int total, int unknown) {
  TxtStyle style = TxtStyle();
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            "Data",
            style: style.title,
          ),
          content: Container(
            height: 125,
            width: 125,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      total.toString(),
                      style:
                          style.desc.copyWith(fontSize: 50, color: Colors.teal),
                    ),
                    Text('Total',
                        style: style.desc.copyWith(color: Colors.teal))
                  ],
                ),
                SizedBox(width: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          motor.toString(),
                          style: style.desc.copyWith(color: Colors.lightGreen),
                        ),
                        SizedBox(width: 10),
                        Text('Naik Motor',
                            style:
                                style.desc.copyWith(color: Colors.lightGreen))
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        Text(
                          sepeda.toString(),
                          style: style.desc.copyWith(color: Colors.lightGreen),
                        ),
                        SizedBox(width: 10),
                        Text('Naik Sepeda',
                            style:
                                style.desc.copyWith(color: Colors.lightGreen))
                      ],
                    ),
                    (unknown != null) ? SizedBox(height: 20) : Container(),
                    (unknown != null)
                        ? Row(
                            children: <Widget>[
                              Text(
                                unknown.toString(),
                                style: style.desc.copyWith(color: Colors.red),
                              ),
                              SizedBox(width: 10),
                              Text('Unknown',
                                  style: style.desc.copyWith(color: Colors.red))
                            ],
                          )
                        : Container(),
                  ],
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Close',
                style: style.desc.copyWith(color: Colors.teal),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      });
}
