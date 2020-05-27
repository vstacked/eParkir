import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eparkir/services/firestore/databaseReference.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class HomeAdminViewModel extends BaseViewModel {
  String _datePick = DateFormat('dd-MM-yyyy').format(DateTime.now());

  get datePick => _datePick;

  void initState() {
    checkDay();
    notifyListeners();
  }

  void resetPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt("value", 2);
    preferences.setString("id", '');
    notifyListeners();
  }

  void changeToFalse() async {
    var test2 = await databaseReference
        .collection('siswa')
        .where('hadir', isEqualTo: true)
        .getDocuments();
    test2.documents.forEach((f) {
      String id = f.documentID;
      Firestore.instance
          .collection('siswa')
          .document(id)
          .updateData({'hadir': false});
    });
    notifyListeners();
  }

  void checkDay() async {
    var test2 = await databaseReference
        .collection('database')
        .document('tanggal')
        .collection(datePick)
        .getDocuments();

    if (test2.documents.length == 0) {
      changeToFalse();
    }
    notifyListeners();
  }
}
