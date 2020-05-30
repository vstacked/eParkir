import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  final databaseReference = Firestore.instance;

  getSiswa(String id) {
    return databaseReference.collection('siswa').document(id).snapshots();
  }

  getUser() {
    return databaseReference
        .collection('siswa')
        .where('level', isEqualTo: 0)
        .snapshots();
  }

  whenSearch(String datePick, array) {
    return databaseReference
        .collection('database')
        .document('tanggal')
        .collection(datePick)
        .where('nisSearch', arrayContains: array)
        .snapshots();
  }

  whenOrder(String datePick, field, bool sort) {
    return databaseReference
        .collection('database')
        .document('tanggal')
        .collection(datePick)
        .orderBy(field, descending: sort)
        .snapshots();
  }

  whenNoOrder(String datePick) {
    return databaseReference
        .collection('database')
        .document('tanggal')
        .collection(datePick)
        .orderBy('datang')
        .snapshots();
  }

  whenSearchSiswa(array) {
    return databaseReference
        .collection('siswa')
        .where('level', isEqualTo: 0)
        .where('nisSearch', arrayContains: array)
        .snapshots();
  }

  whenOrderSiswa(field, bool sort) {
    return databaseReference
        .collection('siswa')
        .where('level', isEqualTo: 0)
        .orderBy(field, descending: sort)
        .snapshots();
  }

  whenNoOrderSiswa() {
    return databaseReference
        .collection('siswa')
        .where('level', isEqualTo: 0)
        .orderBy('nis')
        .snapshots();
  }

  sortLimit10(String datePick) {
    return databaseReference
        .collection('database')
        .document('tanggal')
        .collection(datePick)
        .orderBy('datang')
        .limit(10)
        .snapshots();
  }

  getUserTime(String datePick, String id) {
    return databaseReference
        .collection('database')
        .document('tanggal')
        .collection(datePick)
        .document(id)
        .snapshots();
  }
}
