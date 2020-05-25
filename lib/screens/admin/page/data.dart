import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eparkir/services/firestore/databaseReference.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Data extends StatefulWidget {
  @override
  _DataState createState() => _DataState();
}

class _DataState extends State<Data> {
  String datePick = DateFormat('dd-MM-yyyy').format(DateTime.now());

  bool _sortNameAsc = true;
  bool _sortNisAsc = true;
  bool _sortKelasAsc = true;
  bool _sortAsc = true;
  int _sortColumnIndex;

  String orderByValue;

  String textSearch;

  bool showSearch = false;
  final TextEditingController tecSearch = new TextEditingController();
  FocusNode searchNode = FocusNode();

  @override
  void initState() {
    super.initState();
    tecSearch.clear();
    setState(() {
      textSearch = "";
    });
  }

  Future addDataToFirestore(nis, nama, kelas) async {
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
        'nisSearch': setSearchParam(nis),
      });
      return documentReference;
    } else {
      Scaffold.of(context).showSnackBar(snackbar);
    }
  }

  void editDataToFirestore(nis, nama, kelas, id) async {
    return Firestore.instance.collection('siswa').document(id).updateData({
      'nama': nama,
      'nis': nis,
      'kelas': kelas,
      'nisSearch': setSearchParam(nis),
    });
  }

  void hapusDataToFirestore(id) async {
    return Firestore.instance.collection('siswa').document(id).delete();
  }

  final snackbar = SnackBar(
    content: Text("NIS Sudah Ada"),
    backgroundColor: Colors.red,
    action: SnackBarAction(
      label: "Undo",
      textColor: Colors.black,
      onPressed: () {
        print('Pressed');
      },
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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                (showSearch == false)
                    ? Container(
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(30)),
                        child: IconButton(
                          icon: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          tooltip: 'Add Data',
                          onPressed: () => addData(height),
                        ),
                      )
                    : Container(),
                (showSearch == false) ? Text("Data Siswa") : Container(),
                Flexible(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    width: (showSearch == false) ? width / 5 : width,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 1.5),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          child: Container(
                            color: Colors.blue,
                            height: 50,
                            width: (showSearch == false) ? 30 : 50,
                            margin: EdgeInsets.only(right: 5),
                            child: (showSearch == false)
                                ? Icon(
                                    Icons.arrow_left,
                                    color: Colors.white,
                                  )
                                : Icon(
                                    Icons.arrow_right,
                                    color: Colors.white,
                                  ),
                          ),
                          onTap: () {
                            setState(() {
                              showSearch = !showSearch;
                              textSearch = "";
                            });
                            tecSearch.clear();
                          },
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        (showSearch == false)
                            ? Icon(Icons.search)
                            : Flexible(
                                child: TextField(
                                  controller: tecSearch,
                                  focusNode: searchNode,
                                  onChanged: (val) {
                                    setState(() {
                                      textSearch = val;
                                    });
                                  },
                                  decoration: new InputDecoration(
                                      prefixIcon: Icon(Icons.search),
                                      hintText: 'Search...',
                                      suffixIcon: (textSearch != '')
                                          ? IconButton(
                                              icon: Icon(Icons.close),
                                              onPressed: () {
                                                setState(() {
                                                  textSearch = "";
                                                });

                                                Future.delayed(Duration(
                                                        milliseconds: 50))
                                                    .then((_) {
                                                  tecSearch.clear();
                                                  searchNode.unfocus();
                                                });
                                              },
                                            )
                                          : null),
                                ),
                              )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Urutkan berdasarkan :"),
                GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 1.5),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Reset")),
                  ),
                  onTap: () {
                    setState(() {
                      orderByValue = null;
                      _sortColumnIndex = null;
                    });
                  },
                ),
              ],
            ),
          ),
          Flexible(
            child: Container(
              width: double.infinity,
              height: height,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: StreamBuilder(
                  stream: (textSearch != '')
                      ? databaseReference
                          .collection('siswa')
                          .where('level', isEqualTo: 0)
                          .where('nisSearch', arrayContains: textSearch)
                          .snapshots()
                      : (orderByValue != null)
                          ? databaseReference
                              .collection('siswa')
                              .where('level', isEqualTo: 0)
                              .orderBy(orderByValue, descending: !_sortAsc)
                              .snapshots()
                          : databaseReference
                              .collection('siswa')
                              .where('level', isEqualTo: 0)
                              .orderBy('nis')
                              .snapshots(),
                  builder: (context, snapshot) {
                    int no = 1;
                    QuerySnapshot data = snapshot.data;
                    List<DocumentSnapshot> documentSnapshot =
                        (data?.documents != null) ? data.documents : [];
                    return DataTable(
                      horizontalMargin: 10,
                      headingRowHeight: 40,
                      columnSpacing: 10,
                      sortColumnIndex: _sortColumnIndex,
                      sortAscending: _sortAsc,
                      columns: <DataColumn>[
                        DataColumn(
                          label: Text("No."),
                        ),
                        DataColumn(
                          label: Text("NIS"),
                          onSort: (columnIndex, sortAscending) {
                            print(sortAscending);
                            orderByValue = 'nis';
                            setState(() {
                              if (columnIndex == _sortColumnIndex) {
                                _sortAsc = _sortNisAsc = sortAscending;
                              } else {
                                _sortColumnIndex = columnIndex;
                                _sortAsc = _sortNisAsc;
                              }
                            });
                          },
                        ),
                        DataColumn(
                          label: Text("Nama"),
                          onSort: (columnIndex, sortAscending) {
                            print(sortAscending);
                            orderByValue = 'nama';
                            setState(() {
                              if (columnIndex == _sortColumnIndex) {
                                _sortAsc = _sortNameAsc = sortAscending;
                              } else {
                                _sortColumnIndex = columnIndex;
                                _sortAsc = _sortNameAsc;
                              }
                            });
                          },
                        ),
                        DataColumn(
                          label: Text("Kelas"),
                          onSort: (columnIndex, sortAscending) {
                            print(sortAscending);
                            orderByValue = 'kelas';
                            setState(() {
                              if (columnIndex == _sortColumnIndex) {
                                _sortAsc = _sortKelasAsc = sortAscending;
                              } else {
                                _sortColumnIndex = columnIndex;
                                _sortAsc = _sortKelasAsc;
                              }
                            });
                          },
                        ),
                      ],
                      rows: [
                        for (var d in documentSnapshot)
                          dataRow(no++, d['nis'], d['nama'], d['kelas'],
                              context, d.documentID)
                      ],
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  DataRow dataRow(int no, String nis, nama, kelas, context, idUser) {
    return DataRow(
      cells: <DataCell>[
        DataCell(
          Text(
            no.toString(),
          ),
          onTap: () => tapped(nis, nama, kelas, context, idUser),
        ),
        DataCell(
          ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 60),
              child: Text(
                nis,
                overflow: TextOverflow.ellipsis,
              )),
          onTap: () => tapped(nis, nama, kelas, context, idUser),
        ),
        DataCell(
          ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 150),
              child: Text(
                nama,
                overflow: TextOverflow.ellipsis,
              )),
          onTap: () => tapped(nis, nama, kelas, context, idUser),
        ),
        DataCell(
          ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 60),
              child: Text(
                kelas,
                overflow: TextOverflow.ellipsis,
              )),
          onTap: () => tapped(nis, nama, kelas, context, idUser),
        ),
      ],
    );
  }

  void tapped(nis, nama, kelas, context, idUser) {
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
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                child: Text("Hapus"),
                onPressed: () => hapusData(idUser),
              ),
              FlatButton(
                color: Colors.blue,
                child: Text("Ubah"),
                onPressed: () {
                  editData(nis, nama, kelas, height, idUser);
                },
              ),
            ],
          );
        });
  }

  void hapusData(idUser) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Hapus Data"),
            content: Text('Apakah Anda Yakin ?'),
            actions: <Widget>[
              FlatButton(
                color: Colors.blue,
                child: Text("Batal"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                color: Colors.green,
                child: Text("Hapus"),
                onPressed: () {
                  hapusDataToFirestore(idUser);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  void editData(nis, nama, kelas, height, idUser) {
    TextEditingController controllerNis =
        TextEditingController(text: nis.toString());
    TextEditingController controllerNama = TextEditingController(text: nama);
    TextEditingController controllerKelas = TextEditingController(text: kelas);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Ubah Data"),
            content: Container(
              height: height / 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    maxLength: 8,
                    keyboardType: TextInputType.number,
                    controller: controllerNis,
                  ),
                  TextField(
                    controller: controllerNama,
                  ),
                  TextField(
                    controller: controllerKelas,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.green,
                child: Text("Simpan"),
                onPressed: () {
                  editDataToFirestore(controllerNis.text, controllerNama.text,
                      controllerKelas.text, idUser);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  void addData(height) {
    TextEditingController controllerNis = TextEditingController();
    TextEditingController controllerNama = TextEditingController();
    TextEditingController controllerKelas = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Tambah Data"),
            content: Container(
              height: height / 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    maxLength: 8,
                    keyboardType: TextInputType.number,
                    controller: controllerNis,
                  ),
                  TextField(
                    controller: controllerNama,
                  ),
                  TextField(
                    controller: controllerKelas,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.blue,
                child: Text("Tambah"),
                onPressed: () {
                  addDataToFirestore(controllerNis.text, controllerNama.text,
                      controllerKelas.text);
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
}
