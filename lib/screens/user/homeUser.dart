import 'package:eparkir/screens/user/page/history.dart';
import 'package:eparkir/screens/user/page/home.dart';
import 'package:eparkir/utils/navItems.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class HomeUser extends StatefulWidget {
  final String id;
  HomeUser({this.id});
  @override
  _HomeUserState createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> {
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
      History(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      navItems.navItems(AntDesign.home),
      navItems.navItems(Octicons.history),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
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
