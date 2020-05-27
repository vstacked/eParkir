import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class ShowAllViewModel extends BaseViewModel {
  String datePick = DateFormat('dd-MM-yyyy').format(DateTime.now());

  bool sortNameAsc = true;
  bool sortNisAsc = true;
  bool sortKelasAsc = true;
  bool sortAsc = true;
  int sortColumnIndex;

  String orderByValue;

  Icon searchIcon = new Icon(Icons.search);
  Widget appBarTitle = new Text("Daftar Hadir Hari ini");

  String textSearch;
  final TextEditingController tecSearch = new TextEditingController();

  void initState() {
    tecSearch.clear();
    textSearch = "";
    notifyListeners();
  }

  void searchPressed() {
    if (this.searchIcon.icon == Icons.search) {
      this.searchIcon = new Icon(Icons.close);
      this.appBarTitle = new TextField(
        controller: tecSearch,
        onChanged: (val) {
          textSearch = val;
          notifyListeners();
        },
        decoration: new InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: 'Search...',
        ),
      );
    } else {
      this.searchIcon = new Icon(Icons.search);
      this.appBarTitle = new Text('Daftar Hadir Hari ini');
      tecSearch.clear();

      textSearch = "";
      notifyListeners();
    }
    notifyListeners();
  }

  void tapped(nis, nama, kelas, context, dyn) {
    final height = MediaQuery.of(context).size.height;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Detail Data Siswa'),
            content: Container(
              height: height / 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(nis.toString()),
                  Text(nama),
                  Text(kelas),
                  Text("datang ${dyn['datang']}"),
                  Text("pulang ${dyn['pulang']}"),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  color: Colors.blue,
                  child: Text("Close"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }
}
