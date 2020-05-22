import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../helperCode/platformspecific.dart';
import '../screens/account_creation_1.dart';
import '../providers/auth.dart';
import '../screens/page_2.dart';
import '../screens/signup.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../screens/dashboard.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  static const routeName = "homepage";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
  );
  GoogleSignInAccount _currentUser;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        // _handleGetContact();
        print(_currentUser);
        _googleSignInToOurDb(_currentUser);
      }
    });
    // _googleSignIn.signInSilently();
  }

  Future<void> _googleSignInToOurDb(GoogleSignInAccount currentUser) async {
    try {
      await Provider.of<Auth>(context).authWithGoogle(currentUser);
      bool regIsComplete =
          Provider.of<Auth>(context, listen: false).regComplete;
      print(regIsComplete);

      if (regIsComplete) {
        print("reg is complete");
        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: Dashboard(),
          ),
        );
      } else {
        print("reg is not complete");
        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: AccountCreationOne(),
          ),
        );
      }
    } on HttpException catch (error) {
      _showErrorDialog(error.toString());
    } catch (e) {
      print(e);

      _showErrorDialog(e.toString());
      // print("blah");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => PlatformSpecific(
              ios: CupertinoAlertDialog(
                title: Text('An Error Occurred!'),
                content: Text(message),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('Okay'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  )
                ],
              ),
              android: AlertDialog(
                title: Text('An Error Occurred!'),
                content: Text(message),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Okay'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  )
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _handleGoogleSignIn() async {
      await _googleSignIn.signIn();
    }

    Future<void> _facebookAuth() async {
      try {
        await Provider.of<Auth>(context).facebookAuth();
        bool regIsComplete =
            Provider.of<Auth>(context, listen: false).regComplete;
        print(regIsComplete);

        if (regIsComplete) {
          print("reg is complete");
          Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child: Dashboard(),
            ),
          );
        } else {
          print("reg is not complete");
          Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child: AccountCreationOne(),
            ),
          );
        }
      } on HttpException catch (error) {
        _showErrorDialog(error.toString());
      } catch (e) {
        print(e);

        _showErrorDialog(e.toString());
        // print("blah");
      }
    }

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(top: 50),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff6C63FF),
              Color(0xff273392),
              Color(0xff141b4d),
            ],
          ),
        ),
        width: double.infinity,
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // SizedBox(
              //   height: MediaQuery.of(context).size.height * .10,
              // ),
              Container(
                height: 120,
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  alignment: Alignment.topLeft,
                  image: AssetImage("assets/images/logo.png"),
                )),
                // color: Colors.green,
                // alignment: Alignment.centerLeft,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.only(left: 30),
                child: Text(
                  "Sign up",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              InkWell(
                onTap: _facebookAuth,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                  child: Container(
                    decoration: BoxDecoration(
                        // boxShadow: [
                        //   BoxShadow(
                        //     offset: Offset(0, 0.8),
                        //     // spreadRadius: 0.3,
                        //     color: Color(0xFF333333),
                        //   )
                        // ],
                        color: Color.fromRGBO(66, 103, 178, 1),
                        // color: Color(0xFF3B5998),
                        borderRadius: BorderRadius.circular(6)),
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(15),
                    width: double.infinity,
                    child: Text(
                      "CONTINUE WITH FACEBOOK",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: _handleGoogleSignIn,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                  child: Container(
                    decoration: BoxDecoration(
                        //   boxShadow: [
                        //   BoxShadow(
                        //     offset: Offset(0, 0.8),
                        //     // spreadRadius: 0.3,
                        //     color: Color(0xFF333333),
                        //   )
                        // ],
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6)),
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(15),
                    width: double.infinity,
                    child: Text(
                      "CONTINUE WITH GOOGLE",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  // print("I dey here");
                  // Navigator.push(
                  //   context,
                  //   PageTransition(
                  //     type: PageTransitionType.rightToLeftWithFade,
                  //     child: SignUp(),
                  //   ),
                  // );
                  // // reach facebook api
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUp(),
                        // PageTransition
                      ));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                  child: Container(
                    decoration: BoxDecoration(
                        // boxShadow: [
                        //   BoxShadow(
                        //     offset: Offset(0, 0.8),
                        //     // spreadRadius: 0.3,
                        //     color: Color(0xFF333333),
                        //   )
                        // ],
                        color: Colors.teal[500],
                        borderRadius: BorderRadius.circular(6)),
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(15),
                    width: double.infinity,
                    child: Text(
                      "SIGN UP WITH EMAIL",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
