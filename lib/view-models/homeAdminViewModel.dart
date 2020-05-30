import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eparkir/services/firestore.dart';
import 'package:eparkir/utils/textStyle.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class HomeAdminViewModel extends BaseViewModel {
  String _datePick = DateFormat('dd-MM-yyyy').format(DateTime.now());

  get datePick => _datePick;

  TxtStyle style = TxtStyle();
  FirestoreServices services = FirestoreServices();

  void initState() {
    checkDay();
    notifyListeners();
  }

  void changeToFalse() async {
    var test2 = await services.databaseReference
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
    var test2 = await services.databaseReference
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
