import 'package:eparkir/services/firestore.dart';
import 'package:eparkir/utils/textStyle.dart';
import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  Welcome({@required this.id});
  final String id;
  @override
  Widget build(BuildContext context) {
    TxtStyle style = TxtStyle();
    return StreamBuilder(
      stream: FirestoreServices().getSiswa(id),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          String nama =
              (snapshot.data.exists) ? snapshot.data.data['nama'] : '';
          return Expanded(
            child: Text(
              "Hai, $nama",
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: style.title.copyWith(
                fontSize: 15.0,
                color: Colors.white,
              ),
            ),
          );
        }
      },
    );
  }
}
