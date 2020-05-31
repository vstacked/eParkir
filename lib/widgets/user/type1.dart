import 'package:eparkir/api/api_repository.dart';
import 'package:eparkir/utils/textStyle.dart';
import 'package:eparkir/view-models/homeUserViewModel.dart';
import 'package:eparkir/widgets/user/banner.dart';
import 'package:eparkir/widgets/user/quoteType1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

Widget type1(
    double height,
    double width,
    HomeUserViewModel model,
    String id,
    BuildContext context,
    ApiRepository apiRepository,
    DateTime open,
    String timeNow) {
  TxtStyle style = TxtStyle();
  return Column(
    children: <Widget>[
      BannerType1(
        width: width,
        height: height,
        model: model,
        open: open,
        timeNow: timeNow,
      ),
      SizedBox(
        height: 30,
      ),
      QuoteType1(
        height: height,
        width: width,
        apiRepository: apiRepository,
        model: model,
      ),
      SizedBox(
        height: 30,
      ),
      FlatButton(
        onPressed: () => model.showQR(id, context),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Icon(
                  AntDesign.qrcode,
                  size: 30,
                  color: Colors.white,
                ),
                Text(
                  "Show QR",
                  style: style.desc.copyWith(color: Colors.white),
                )
              ],
            )),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Colors.teal,
      )
    ],
  );
}
