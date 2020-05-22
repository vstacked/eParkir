import 'package:eparkir/screens/admin/page/data.dart';
import 'package:eparkir/screens/admin/page/home.dart';

import 'package:flutter/material.dart';

class HomeAdmin extends StatefulWidget {
  final String id;
  HomeAdmin({this.id});
  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  int _selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    final _pageOption = [Home(id: widget.id), Data()];
    return Scaffold(
      body: SafeArea(child: _pageOption[_selectedPage]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPage,
        onTap: (int index) {
          setState(() {
            _selectedPage = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
          BottomNavigationBarItem(icon: Icon(Icons.list), title: Text("Data")),
        ],
      ),
    );
  }
}
