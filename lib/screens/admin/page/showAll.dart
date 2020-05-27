import 'package:eparkir/view-models/showAllViewModel.dart';
import 'package:eparkir/widgets/admin/buildTableShowAll.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    return ViewModelBuilder<ShowAllViewModel>.reactive(
      viewModelBuilder: () => showAllViewModel,
      onModelReady: (model) => model.initState(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: model.appBarTitle,
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  child: model.searchIcon,
                  onTap: () => model.searchPressed(),
                ),
              )
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
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
                          model.orderByValue = null;
                          model.sortColumnIndex = null;
                        });
                      },
                    ),
                  ],
                ),
              ),
              BuildTableShowAll(
                height: height,
                model: model,
              )
            ],
          ),
        );
      },
    );
  }
}
