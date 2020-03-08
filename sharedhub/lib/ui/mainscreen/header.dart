import 'package:flutter/material.dart';

Color headercolor = Colors.black;
Color iconcolor = Colors.green;

header() {
  return Container(
    height: 65,
    decoration: BoxDecoration(color: headercolor),
    padding: EdgeInsets.all(2),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Icon(
          Icons.supervised_user_circle,
          color: iconcolor,
          size: 40,
        ),
        SizedBox(
          width: 7,
        ),
        Text(
          "The Cat in the hat!",
          style: TextStyle(color: Colors.white, fontSize: 16),
        )
      ],
    ),
  );
}
