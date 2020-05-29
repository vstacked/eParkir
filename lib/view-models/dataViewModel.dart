import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eparkir/services/checkConnection.dart';
import 'package:eparkir/services/firestore/databaseReference.dart';
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
        var test2 = await databaseReference
            .collection('siswa')
            .where('nis', isEqualTo: nis)
            .getDocuments();

        if (test2.documents.length == 0) {
          DocumentReference documentReference =
              await databaseReference.collection('siswa').add({
            'nama': nama,
            'nis': nis,
            'kelas': kelas,
            'level': 0,
            'hadir': false,
            'login': false,
            'nisSearch': setSearchParam(nis),
          });
          return documentReference;
        } else {
          return _scaffoldKey.currentState.showSnackBar(snackbar);
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
        return databaseReference.collection('siswa').document(id).updateData({
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
        return databaseReference.collection('siswa').document(id).delete();
      } else {
        return _scaffoldKey.currentState.showSnackBar(_snackbar.snackbarNoInet);
      }
    }).then((_) {
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  final snackbar = SnackBar(
    content: Text("NIS Sudah Ada"),
    backgroundColor: Colors.red,
    behavior: SnackBarBehavior.floating,
    action: SnackBarAction(
      label: "OK",
      textColor: Colors.white,
      onPressed: () {},
    ),
  );

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
            title: Text(
              'Detail Data Siswa',
              style: TextStyle(fontFamily: 'Jura'),
            ),
            content: Container(
              height: height / 5,
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
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                child: Text(
                  "Hapus",
                  style: TextStyle(fontFamily: 'Jura'),
                ),
                onPressed: () => hapusData(idUser, context),
              ),
              FlatButton(
                color: Colors.teal,
                child: Text(
                  "Ubah",
                  style: TextStyle(fontFamily: 'Jura'),
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
            title: Text(
              "Hapus Data",
              style: TextStyle(fontFamily: 'Jura'),
            ),
            content: Text(
              'Apakah Anda Yakin ?',
              style: TextStyle(fontFamily: 'Jura'),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.blue,
                child: Text(
                  "Batal",
                  style: TextStyle(fontFamily: 'Jura'),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                color: Colors.red,
                child: Text(
                  "Hapus",
                  style: TextStyle(fontFamily: 'Jura'),
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
            title: Text(
              "Ubah Data",
              style: TextStyle(fontFamily: 'Jura'),
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
                        style: TextStyle(fontFamily: 'Jura'),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'NIS, ex: 1700xxx',
                          hintStyle: TextStyle(fontFamily: 'Jura'),
                          errorStyle: TextStyle(fontFamily: 'Jura'),
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
                        style: TextStyle(fontFamily: 'Jura'),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Nama',
                          hintStyle: TextStyle(fontFamily: 'Jura'),
                          errorStyle: TextStyle(fontFamily: 'Jura'),
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
                        style: TextStyle(fontFamily: 'Jura'),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Kelas',
                          hintStyle: TextStyle(fontFamily: 'Jura'),
                          errorStyle: TextStyle(fontFamily: 'Jura'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.green,
                child: Text(
                  "Simpan",
                  style: TextStyle(fontFamily: 'Jura'),
                ),
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
            title: Text(
              "Tambah Data",
              style: TextStyle(fontFamily: 'Jura'),
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
                        style: TextStyle(fontFamily: 'Jura'),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'NIS, ex: 1700xxx',
                          hintStyle: TextStyle(fontFamily: 'Jura'),
                          errorStyle: TextStyle(fontFamily: 'Jura'),
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
                        style: TextStyle(fontFamily: 'Jura'),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Nama',
                          hintStyle: TextStyle(fontFamily: 'Jura'),
                          errorStyle: TextStyle(fontFamily: 'Jura'),
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
                        style: TextStyle(fontFamily: 'Jura'),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Kelas',
                          hintStyle: TextStyle(fontFamily: 'Jura'),
                          errorStyle: TextStyle(fontFamily: 'Jura'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                child: Text(
                  "Batal",
                  style: TextStyle(fontFamily: 'Jura'),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _controllerNis.clear();
                  _controllerNama.clear();
                  _controllerKelas.clear();
                },
              ),
              FlatButton(
                color: Colors.teal,
                child: Text(
                  "Tambah",
                  style: TextStyle(fontFamily: 'Jura'),
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
