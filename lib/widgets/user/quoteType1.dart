import 'package:eparkir/api/api_repository.dart';
import 'package:eparkir/models/api_model.dart';
import 'package:eparkir/utils/textStyle.dart';
import 'package:eparkir/view-models/homeUserViewModel.dart';
import 'package:flutter/material.dart';

class QuoteType1 extends StatelessWidget {
  QuoteType1({this.height, this.width, this.apiRepository, this.model});
  final double height;
  final double width;
  final ApiRepository apiRepository;
  final HomeUserViewModel model;
  @override
  Widget build(BuildContext context) {
    TxtStyle style = TxtStyle();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(-3, 1),
            blurRadius: 5,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Quotes",
                style: style.desc.copyWith(
                  fontStyle: FontStyle.italic,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                width: width / 1.5,
                height: height / 5,
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          model.text ?? '',
                          overflow: TextOverflow.fade,
                          textAlign: TextAlign.center,
                          style: style.desc,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          model.author ?? '',
                          overflow: TextOverflow.fade,
                          style: style.desc,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Text(
                " \" ",
                style: style.title.copyWith(fontSize: 60),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class BuildQuote extends StatelessWidget {
  const BuildQuote({
    Key key,
    @required this.apiRepository,
    @required this.style,
    this.model,
  }) : super(key: key);

  final ApiRepository apiRepository;
  final TxtStyle style;
  final HomeUserViewModel model;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: apiRepository.getDataPostFromApi,
      builder: (BuildContext context, AsyncSnapshot<List<ApiModel>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(child: CircularProgressIndicator());
            break;
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
            break;
          case ConnectionState.active:
            return Center(child: CircularProgressIndicator());
            break;
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Center(child: Text('wrong'));
            } else {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      (snapshot.data != null)
                          ? snapshot.data[0].text
                          : 'No Internet Connection',
                      overflow: TextOverflow.fade,
                      textAlign: TextAlign.center,
                      style: style.desc,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      (snapshot.data != null)
                          ? (snapshot.data[0].author != null)
                              ? snapshot.data[0].author
                              : '-'
                          : '',
                      overflow: TextOverflow.fade,
                      style: style.desc,
                    ),
                  ],
                ),
              );
            }
            break;
        }
        return Container();
      },
    );
  }
}
