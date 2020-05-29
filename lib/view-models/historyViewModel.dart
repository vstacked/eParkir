import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class HistoryViewModel extends BaseViewModel {
  DateTime selectedDate;
  String datePick = DateFormat('dd-MM-yyyy').format(DateTime.now());

  bool sortNameAsc = true;
  bool sortNisAsc = true;
  bool sortKelasAsc = true;
  bool sortAsc = true;
  int sortColumnIndex;

  String orderByValue;

  String textSearch;
  final TextEditingController tecSearch = new TextEditingController();
  FocusNode searchNode = FocusNode();

  void initState() {
    tecSearch.clear();
    textSearch = "";
    notifyListeners();
  }

  void pickDateDialog(BuildContext context) {
    showDatePicker(
            context: context,
            initialDate: (selectedDate != null) ? selectedDate : DateTime.now(),
            //which date will display when user open the picker
            firstDate: DateTime(1950),
            //what will be the previous supported year in picker
            lastDate: DateTime
                .now()) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {
        //if user tap cancel then this function will stop
        return;
      }

      //for rebuilding the ui
      selectedDate = pickedDate;
      datePick = DateFormat('dd-MM-yyyy').format(selectedDate);
      notifyListeners();
    });
  }

  void tapped(nis, nama, kelas, context, dyn) {
    final height = MediaQuery.of(context).size.height;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Detail Data Siswa',
            style: TextStyle(fontFamily: 'Jura'),
          ),
          content: Container(
            height: height / 3,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'NIS',
                    style: TextStyle(fontFamily: 'Jura', fontSize: 12),
                  ),
                  Text(
                    nis.toString(),
                    style: TextStyle(
                        fontFamily: 'Jura',
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 7.5),
                  Text(
                    'Nama',
                    style: TextStyle(fontFamily: 'Jura', fontSize: 12),
                  ),
                  Text(
                    nama,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Jura',
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 7.5),
                  Text(
                    'Kelas',
                    style: TextStyle(fontFamily: 'Jura', fontSize: 12),
                  ),
                  Text(
                    kelas,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Jura',
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
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
                    style: TextStyle(fontFamily: 'Jura', fontSize: 12),
                  ),
                  Text(
                    dyn['datang'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Jura',
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Jam Pulang',
                    style: TextStyle(fontFamily: 'Jura', fontSize: 12),
                  ),
                  Text(
                    dyn['pulang'] ?? '-',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Jura',
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
                color: Colors.teal,
                child: Text(
                  "Close",
                  style: TextStyle(fontFamily: 'Jura'),
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
