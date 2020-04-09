import 'package:eparkir/bloc/nis_bloc.dart';
import 'package:eparkir/ui/page/homepage.dart';
import 'package:eparkir/ui/page/secondpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  int _selectedPage = 0;
  final _pageOption = [HomePage(), SecondPage()];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider<NisBloc>(builder: (context) => NisBloc())],
      child: MaterialApp(
        home: Scaffold(
          body: _pageOption[_selectedPage],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedPage,
            onTap: (int index) {
              setState(() {
                _selectedPage = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), title: Text("Home")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.list), title: Text("Second Tab")),
            ],
          ),
        ),
      ),
    );
  }
}
