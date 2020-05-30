import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eparkir/services/checkConnection.dart';
import 'package:eparkir/services/firestore.dart';
import 'package:eparkir/utils/textStyle.dart';
import 'package:eparkir/widgets/common/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class DataViewModel extends BaseViewModel {
  bool sortNameAsc = true;
  bool sortNisAsc = true;
  bool sortKelasAsc = true;
  bool sortAsc = true;
  int sortColumnIndex;

  String orderByValue;

  String textSearch;

  bool showSearch = false;
  TextEditingController _tecSearch;
  FocusNode _searchNode;
  CheckConnection checkConnection;
  Snackbar _snackbar = Snackbar();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  FirestoreServices services = FirestoreServices();
  TxtStyle style = TxtStyle();

  FocusNode _nisFocus;
  FocusNode _namaFocus;
  FocusNode _kelasFocus;
  final _key = new GlobalKey<FormState>();
  TextEditingController _controllerNis;
  TextEditingController _controllerNama;
  TextEditingController _controllerKelas;

  get tecClear => _tecSearch.clear();
  get tecSearch => _tecSearch;
  get searchNode => _searchNode;
  get searchUnfocus => _searchNode.unfocus();
  get scaffoldKey => _scaffoldKey;

  void initState() {
    _tecSearch = new TextEditingController();
    _controllerNis = TextEditingController();
    _controllerNama = TextEditingController();
    _controllerKelas = TextEditingController();
    _searchNode = FocusNode();
    _nisFocus = FocusNode();
    _namaFocus = FocusNode();
    _kelasFocus = FocusNode();
    _tecSearch.clear();
    textSearch = "";
    checkConnection = CheckConnection();
    notifyListeners();
  }

  void addDataToFirestore(nis, nama, kelas, context) async {
    checkConnection.checkConnection().then((_) async {
      if (checkConnection.hasConnection) {
        var test2 = await services.databaseReference
            .collection('siswa')
            .where('nis', isEqualTo: nis)
            .getDocuments();

        if (test2.documents.length == 0) {
          DocumentReference documentReference =
              await services.databaseReference.collection('siswa').add({
            'nama': nama,
            'nis': nis,
            'kelas': kelas,
            'level': 0,
            'hadir': false,
            'login': false,
            'transportasi': '',
            'nisSearch': setSearchParam(nis),
          });
          return documentReference;
        } else {
          return _scaffoldKey.currentState
              .showSnackBar(_snackbar.snackbarNisExist);
        }
      } else {
        return _scaffoldKey.currentState.showSnackBar(_snackbar.snackbarNoInet);
      }
    }).then((_) {
      Navigator.pop(context);
      _controllerNis.clear();
      _controllerNama.clear();
      _controllerKelas.clear();
    });
  }

  void editDataToFirestore(nis, nama, kelas, id, context) async {
    checkConnection.checkConnection().then((_) {
      if (checkConnection.hasConnection) {
        return services.databaseReference
            .collection('siswa')
            .document(id)
            .updateData({
          'nama': nama,
          'nis': nis,
          'kelas': kelas,
          'nisSearch': setSearchParam(nis),
        });
      } else {
        return _scaffoldKey.currentState.showSnackBar(_snackbar.snackbarNoInet);
      }
    }).then((_) {
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  void hapusDataToFirestore(id, context) async {
    checkConnection.checkConnection().then((_) {
      if (checkConnection.hasConnection) {
        return services.databaseReference
            .collection('siswa')
            .document(id)
            .delete();
      } else {
        return _scaffoldKey.currentState.showSnackBar(_snackbar.snackbarNoInet);
      }
    }).then((_) {
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  setSearchParam(String caseNumber) {
    List<String> caseSearchList = List();
    String temp = "";
    for (int i = 0; i < caseNumber.length; i++) {
      temp = temp + caseNumber[i];
      caseSearchList.add(temp);
    }
    return caseSearchList;
  }

  void tapped(nis, nama, kelas, context, idUser) {
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
              height: height / 5,
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
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Hapus",
                  style: style.desc.copyWith(color: Colors.red),
                ),
                onPressed: () => hapusData(idUser, context),
              ),
              FlatButton(
                child: Text(
                  "Ubah",
                  style: style.desc.copyWith(color: Colors.teal),
                ),
                onPressed: () {
                  editData(nis, nama, kelas, height, idUser, context);
                },
              ),
            ],
          );
        });
  }

  void hapusData(idUser, context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(
              "Hapus Data",
              style: style.desc,
            ),
            content: Text(
              'Apakah Anda Yakin ?',
              style: style.desc,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Batal",
                    style: style.desc.copyWith(color: Colors.lightGreen)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text(
                  "Hapus",
                  style: style.desc.copyWith(color: Colors.red),
                ),
                onPressed: () {
                  hapusDataToFirestore(idUser, context);
                },
              )
            ],
          );
        });
  }

  void editData(nis, nama, kelas, height, idUser, context) {
    _controllerNis = TextEditingController(text: nis);
    _controllerNama = TextEditingController(text: nama);
    _controllerKelas = TextEditingController(text: kelas);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(
              "Ubah Data",
              style: style.desc,
            ),
            content: Container(
              height: height / 3,
              child: Form(
                key: _key,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        maxLength: 8,
                        keyboardType: TextInputType.number,
                        controller: _controllerNis,
                        focusNode: _nisFocus,
                        validator: (e) {
                          return (e.isEmpty) ? "Please Insert NIS" : null;
                        },
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {
                          _nisFocus.unfocus();
                          FocusScope.of(context).requestFocus(_namaFocus);
                        },
                        cursorColor: Colors.teal,
                        style: style.desc,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'NIS, ex: 1700xxx',
                          hintStyle: style.desc,
                          errorStyle: style.desc,
                        ),
                      ),
                      SizedBox(height: 7.5),
                      TextFormField(
                        controller: _controllerNama,
                        focusNode: _namaFocus,
                        validator: (e) {
                          return (e.isEmpty) ? "Please Insert Nama" : null;
                        },
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {
                          _namaFocus.unfocus();
                          FocusScope.of(context).requestFocus(_kelasFocus);
                        },
                        cursorColor: Colors.teal,
                        style: style.desc,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Nama',
                          hintStyle: style.desc,
                          errorStyle: style.desc,
                        ),
                      ),
                      SizedBox(height: 7.5),
                      TextFormField(
                        controller: _controllerKelas,
                        focusNode: _kelasFocus,
                        validator: (e) {
                          return (e.isEmpty) ? "Please Insert Kelas" : null;
                        },
                        onFieldSubmitted: (value) {
                          _kelasFocus.unfocus();
                          if (_key.currentState.validate())
                            editDataToFirestore(
                                _controllerNis.text,
                                _controllerNama.text,
                                _controllerKelas.text,
                                idUser,
                                context);
                        },
                        cursorColor: Colors.teal,
                        style: style.desc,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Kelas',
                          hintStyle: style.desc,
                          errorStyle: style.desc,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Simpan",
                    style: style.desc.copyWith(color: Colors.lightGreen)),
                onPressed: () {
                  if (_key.currentState.validate()) {
                    _kelasFocus.unfocus();
                    editDataToFirestore(
                        _controllerNis.text,
                        _controllerNama.text,
                        _controllerKelas.text,
                        idUser,
                        context);
                  }
                },
              )
            ],
          );
        });
  }

  void addData(height, context) {
    _controllerNis.clear();
    _controllerNama.clear();
    _controllerKelas.clear();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(
              "Tambah Data",
              style: style.desc,
            ),
            content: Container(
              height: height / 3,
              child: Form(
                key: _key,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        maxLength: 8,
                        keyboardType: TextInputType.number,
                        controller: _controllerNis,
                        focusNode: _nisFocus,
                        validator: (e) {
                          return (e.isEmpty) ? "Please Insert NIS" : null;
                        },
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {
                          _nisFocus.unfocus();
                          FocusScope.of(context).requestFocus(_namaFocus);
                        },
                        cursorColor: Colors.teal,
                        style: style.desc,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'NIS, ex: 1700xxx',
                          hintStyle: style.desc,
                          errorStyle: style.desc,
                        ),
                      ),
                      SizedBox(height: 7.5),
                      TextFormField(
                        controller: _controllerNama,
                        focusNode: _namaFocus,
                        validator: (e) {
                          return (e.isEmpty) ? "Please Insert Nama" : null;
                        },
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {
                          _namaFocus.unfocus();
                          FocusScope.of(context).requestFocus(_kelasFocus);
                        },
                        cursorColor: Colors.teal,
                        style: style.desc,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Nama',
                          hintStyle: style.desc,
                          errorStyle: style.desc,
                        ),
                      ),
                      SizedBox(height: 7.5),
                      TextFormField(
                        controller: _controllerKelas,
                        focusNode: _kelasFocus,
                        validator: (e) {
                          return (e.isEmpty) ? "Please Insert Kelas" : null;
                        },
                        onFieldSubmitted: (value) {
                          _kelasFocus.unfocus();
                          if (_key.currentState.validate())
                            addDataToFirestore(
                                _controllerNis.text,
                                _controllerNama.text,
                                _controllerKelas.text,
                                context);
                        },
                        cursorColor: Colors.teal,
                        style: style.desc,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Kelas',
                          hintStyle: style.desc,
                          errorStyle: style.desc,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Batal",
                  style: style.desc.copyWith(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _controllerNis.clear();
                  _controllerNama.clear();
                  _controllerKelas.clear();
                },
              ),
              FlatButton(
                child: Text(
                  "Tambah",
                  style: style.desc.copyWith(color: Colors.teal),
                ),
                onPressed: () {
                  if (_key.currentState.validate()) {
                    _kelasFocus.unfocus();
                    addDataToFirestore(_controllerNis.text,
                        _controllerNama.text, _controllerKelas.text, context);
                  }
                },
              ),
            ],
          );
        });
  }
}
