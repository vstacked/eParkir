import 'package:eparkir/utils/textStyle.dart';
import 'package:flutter/material.dart';

Widget quoteType1(double height, double width) {
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Text(
                    "Quoutasdsadsadijsaodsjaosid usaidjasldjaslasdasdasdsadasadsadasdsaasdasdkdjsaldkjasldjaslkdaso idusao iduoa isjudaQuoutasdsadsadijsaodsjaosid usaidjasldjaslasdasdasdsadasadsadasdsaasdasdkdjsaldkjasldjaslkdaso idusao iduoa isjudaeQuoutasdsadsadijsaodsjaosid usaidjasldjaslasdasdasdsadasadsadasdsaasdasdkdjsaldkjasldjaslkdaso idusao iduoa isjudaeQuoutasdsadsadijsaodsjaosid usaidjasldjaslasdasdasdsadasadsadasdsaasdasdkdjsaldkjasldjaslkdaso idusao iduoa isjudaeQuoutasdsadsadijsaodsjaosid usaidjasldjaslasdasdasdsadasadsadasdsaasdasdkdjsaldkjasldjaslkdaso idusao iduoa isjudaeQuoutasdsadsadijsaodsjaosid usaidjasldjaslasdasdasdsadasadsadasdsaasdasdkdjsaldkjasldjaslkdaso idusao iduoa isjudaeQuoutasdsadsadijsaodsjaosid usaidjasldjaslasdasdasdsadasadsadasdsaasdasdkdjsaldkjasldjaslkdaso idusao iduoa isjudaeQuoutasdsadsadijsaodsjaosid usaidjasldjaslasdasdasdsadasadsadasdsaasdasdkdjsaldkjasldjaslkdaso idusao iduoa isjudaeQuoutasdsadsadijsaodsjaosid usaidjasldjaslasdasdasdsadasadsadasdsaasdasdkdjsaldkjasldjaslkdaso idusao iduoa isjudaee",
                    overflow: TextOverflow.fade,
                    style: style.desc,
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
