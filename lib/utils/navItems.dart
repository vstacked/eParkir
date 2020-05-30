import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class NavItems {
  navItems(IconData icon) {
    return PersistentBottomNavBarItem(
      icon: Icon(
        icon,
        size: 21.0,
      ),
      activeColor: Colors.teal,
      inactiveColor: Colors.grey,
      title: '',
    );
  }
}
