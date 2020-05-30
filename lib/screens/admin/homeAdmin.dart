import 'package:eparkir/screens/admin/page/data.dart';
import 'package:eparkir/screens/admin/page/home.dart';
import 'package:eparkir/screens/admin/page/scanner.dart';
import 'package:eparkir/utils/navItems.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class HomeAdmin extends StatefulWidget {
  final String id;
  HomeAdmin({this.id});
  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  PersistentTabController _controller;
  NavItems navItems;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    navItems = NavItems();
  }

  List<Widget> _buildScreens() {
    return [
      Home(id: widget.id),
      Data(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      navItems.navItems(AntDesign.home),
      navItems.navItems(Ionicons.md_list),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: Icon(MaterialCommunityIcons.qrcode_scan),
        elevation: 3.5,
        tooltip: 'Scanner',
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scanner(),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: PersistentTabView(
          controller: _controller,
          screens: _buildScreens(),
          items: _navBarsItems(),
          showElevation: true,
          navBarCurve: NavBarCurve.upperCorners,
          navBarCurveRadius: 20.0,
          navBarStyle: NavBarStyle.style5,
        ),
      ),
    );
  }
}
