import 'package:eparkir/bloc/nis_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocBuilderButton extends StatelessWidget {
  const BlocBuilderButton({
    Key key,
    @required this.nisBloc,
    @required this.controller,
  }) : super(key: key);

  final NisBloc nisBloc;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NisBloc, String>(
      builder: (context, text) => RaisedButton(
        onPressed: () {
          nisBloc.dispatch(controller.text);
        },
        child: Text("Input"),
      ),
    );
  }
}
