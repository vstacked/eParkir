import 'package:eparkir/services/firestore/databaseReference.dart';
import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  Welcome({@required this.id});
  final String id;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: databaseReference.collection('siswa').document(id).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          String nama =
              (snapshot.data.exists) ? snapshot.data.data['nama'] : '';
          return ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 250),
              child: Text(
                "Hai, $nama",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Lemonada',
                  fontSize: 15.0,
                ),
              ));
        }
      },
    );
  }
}
