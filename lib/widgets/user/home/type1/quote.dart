import 'package:flutter/material.dart';

Padding quote() {
  return Padding(
    padding: const EdgeInsets.only(top: 20.0, bottom: 30.0),
    child: Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.red)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 250, maxHeight: 50),
            child: Text(
              "Quoutasdsadsadijsaodsjaosid usaidjasldjaslasdasdasdsadasadsadasdsaasdasdkdjsaldkjasldjaslkdaso idusao iduoa isjudae",
              overflow: TextOverflow.fade,
            )),
      ),
    ),
  );
}
