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
    },
  );
}
}
