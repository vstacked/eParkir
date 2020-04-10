
import 'package:eparkir/before/template.dart';
import 'package:eparkir/services/bloc/nis_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Template(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          BlocBuilder<NisBloc, String>(
            builder: (context, text) => QrImage(
                version: 6,
                errorCorrectionLevel: QrErrorCorrectLevel.M,
                size: 300,
                data: (text == "") ? "" : text),
          )
        ],
      ),
    );
  }
}
