import 'package:eparkir/utils/textStyle.dart';
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

  TxtStyle style = TxtStyle();

  Icon searchIcon = new Icon(Icons.search);
  Widget appBarTitle = new Text(
    "Daftar Hadir Hari ini",
    style: TxtStyle().title.copyWith(
          color: Colors.teal,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
  );

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
      this.appBarTitle = new Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.teal),
          borderRadius: BorderRadius.circular(5),
        ),
        child: TextField(
          style: style.desc,
          cursorColor: Colors.teal,
          controller: tecSearch,
          keyboardType: TextInputType.number,
          onChanged: (val) {
            textSearch = val;
            notifyListeners();
          },
          decoration: new InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(
              Icons.search,
              color: Colors.teal,
            ),
            hintText: 'Search NIS...',
            hintStyle: style.desc,
          ),
        ),
      );
    } else {
      this.searchIcon = new Icon(Icons.search);
      this.appBarTitle = new Text(
        'Daftar Hadir Hari ini',
        style: TxtStyle().title.copyWith(
              color: Colors.teal,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
      );
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Detail Data Siswa',
            style: style.desc,
          ),
          content: Container(
            height: height / 3,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'NIS',
                    style: style.desc.copyWith(fontSize: 12),
                  ),
                  Text(
                    nis.toString(),
                    style: style.desc
                        .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 7.5),
                  Text(
                    'Nama',
                    style: style.desc.copyWith(fontSize: 12),
                  ),
                  Text(
                    nama,
                    textAlign: TextAlign.center,
                    style: style.desc
                        .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 7.5),
                  Text(
                    'Kelas',
                    style: style.desc.copyWith(fontSize: 12),
                  ),
                  Text(
                    kelas,
                    textAlign: TextAlign.center,
                    style: style.desc
                        .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 5.0),
                    child: Divider(
                      thickness: 0.3,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Transportasi',
                    style: style.desc.copyWith(fontSize: 12),
                  ),
                  Text(
                    dyn['transportasi'] ?? '-',
                    textAlign: TextAlign.center,
                    style: style.desc
                        .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 5.0),
                    child: Divider(
                      thickness: 0.3,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Jam Datang',
                    style: style.desc.copyWith(fontSize: 12),
                  ),
                  Text(
                    dyn['datang'],
                    textAlign: TextAlign.center,
                    style: style.desc
                        .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Jam Pulang',
                    style: style.desc.copyWith(fontSize: 12),
                  ),
                  Text(
                    dyn['pulang'] ?? '-',
                    textAlign: TextAlign.center,
                    style: style.desc
                        .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
                child: Text(
                  "Close",
                  style: style.desc.copyWith(color: Colors.teal),
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
        );
      },
    );
  }
}
