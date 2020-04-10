import 'package:eparkir/before/template.dart';
import 'package:eparkir/services/bloc/nis_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  String nis = "";
  String nama = "";
  String kelas = "";

  void _addDataToFirestore() {
    Firestore.instance.runTransaction((Transaction transaction) async {
      await Firestore.instance
          .collection('siswa')
          .add({"nis": nis, "nama": nama, "kelas": kelas});
    });
  }

  @override
  Widget build(BuildContext context) {
    NisBloc nisBloc = BlocProvider.of<NisBloc>(context);
    return Template(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            onChanged: (String res) {
              setState(() {
                nis = res;
              });
            },
            decoration:
                InputDecoration(hintText: "Masukkan NIS", labelText: "NIS :"),
          ),
          TextField(
            onChanged: (String res) {
              setState(() {
                nama = res;
              });
            },
            decoration:
                InputDecoration(hintText: "Masukkan Nama", labelText: "Nama :"),
          ),
          TextField(
            onChanged: (String res) {
              setState(() {
                kelas = res;
              });
            },
            decoration: InputDecoration(
                hintText: "Masukkan Kelas", labelText: "Kelas :"),
          ),
          RaisedButton(
            onPressed: () {
              nisBloc.dispatch(nis);
              _addDataToFirestore();
            },
            child: Text("Input"),
          ),
          BlocBuilder<NisBloc, String>(builder: (context, text) => Text(text)),
        ],
      ),
    );
  }
}
