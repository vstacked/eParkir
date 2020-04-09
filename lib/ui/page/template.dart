import 'package:flutter/material.dart';

class Template extends StatelessWidget {
  final Widget child;

  Template({this.child});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: child,
    );
  }
}
