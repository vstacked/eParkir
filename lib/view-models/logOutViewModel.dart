import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class LogOutViewModel extends BaseViewModel {
  void resetPref(String id) async {
    Firestore.instance
        .collection('siswa')
        .document(id)
        .updateData({'login': false});
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt("value", 2);
    preferences.setString("id", '');
    notifyListeners();
  }
}
