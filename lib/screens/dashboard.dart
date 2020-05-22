import 'package:flutter/material.dart';
import 'package:learn_animations/providers/auth.dart';
import 'package:learn_animations/screens/home_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: null,
          elevation: 0,
          backgroundColor: Color(0xffffffff),
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Image.asset(
              "assets/images/syself_logo.png",
              height: 50,
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text(
                  "DASHBOARD",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w200),
                ),
              ),
              RaisedButton(
                onPressed: () {
                  Provider.of<Auth>(context, listen: false).logout();
                  Navigator.pushReplacement(
                    context,
                    PageTransition(
                      type: PageTransitionType.fade,
                      child: HomePage(),
                    ),
                  );
                },
                child: Text("Signout"),
              )
            ],
          ),
        ));
  }
}
