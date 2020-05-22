import 'package:flutter/material.dart';

class PageTwo extends StatelessWidget {
  static const routeName = "page_2";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 80.0, left: 30),
          child: Text("PAGE 2",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        )
      ],
    )));
  }
}
