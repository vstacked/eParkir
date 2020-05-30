import 'package:eparkir/utils/color.dart';
import 'package:eparkir/view-models/showAllViewModel.dart';
import 'package:eparkir/widgets/admin/buildTableShowAll.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:stacked/stacked.dart';

class ShowAll extends StatefulWidget {
  @override
  _ShowAllState createState() => _ShowAllState();
}

class _ShowAllState extends State<ShowAll> {
  ShowAllViewModel showAllViewModel = ShowAllViewModel();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<ShowAllViewModel>.reactive(
      viewModelBuilder: () => showAllViewModel,
      onModelReady: (model) => model.initState(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ColorApp().colorTeal100,
            elevation: 0,
            iconTheme: IconThemeData().copyWith(color: Colors.teal),
            title: model.appBarTitle,
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  child: model.searchIcon,
                  onTap: () => model.searchPressed(),
                ),
              ),
              IconButton(
                tooltip: 'Reset',
                icon: Icon(MaterialCommunityIcons.restart),
                onPressed: () {
                  setState(() {
                    model.orderByValue = null;
                    model.sortColumnIndex = null;
                  });
                },
              ),
            ],
          ),
          body: Stack(
            children: <Widget>[
              Container(
                width: width,
                height: height,
                color: ColorApp().colorTeal100,
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: BuildTableShowAll(
                  height: height,
                  width: width,
                  model: model,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
