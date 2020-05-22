import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../helperCode/platformspecific.dart';
import '../screens/account_creation_1.dart';
import '../screens/dashboard.dart';
import '../screens/signup.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final Color _titleColor = Color(0xff444444);
  final GlobalKey<FormState> _formKey = GlobalKey();
  Color _emailFocusColor;
  Color _passwordFocusColor;
  // AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  bool _isLoading = false;
  final FocusNode _focusNode = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
// final FocusNode _weightFocus = FocusNode();
  final _passwordController = TextEditingController();
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

  Future<void> _signup() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }

    _formKey.currentState.save();
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Auth>(context, listen: false).login(
        _authData['email'],
        _authData['password'],
      );
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

      // Navigator.push(
      //   context,
      //   PageTransition(
      //     type: PageTransitionType.rotate,
      //     child: AccountCreationOne(),
      //   ),
      // );
    } on HttpException catch (error) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog(error.toString());
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog(e.toString());
      // print("blah");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        leading: BackButton(
          // color: Color(0xffec6b67),
          color: Colors.indigo,
        ),
        elevation: 0,
        backgroundColor: Colors.white.withAlpha(0),
        // backgroundColor: Platform.isIOS ? Color(0xffffffff) : Colors.white,
        // title: Text("Sign up with email", style: TextStyle()),
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).unfocus();
            setState(() {
              _passwordFocusColor = Color(0xffbbbbbb);
              _emailFocusColor = Color(0xffbbbbbb);
            });
          },
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // SizedBox(
                //   height: 40,
                // ),
                Container(
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.center,
                  child: Text(
                    "Welcome back",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: _titleColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 1,
                ),
                Text(
                  "Sign in",
                  style: TextStyle(
                    color: Color(0xffbbbbbb),
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    // color: Colors.black,
                    image: DecorationImage(
                      image: AssetImage("assets/images/signin.png"),
                    ),
                  ),
                ),
                // SizedBox(
                //   height: 10,
                // ),
                SingleChildScrollView(
                  child: Form(
                    // autovalidate: false,
                    key: _formKey,

                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Focus(
                            onFocusChange: (bool hasFocus) {
                              if (hasFocus) {
                                setState(() {
                                  _emailFocusColor = Colors.indigo;
                                });
                              } else {
                                setState(() {
                                  _emailFocusColor = Color(0xffbbbbbb);
                                });
                              }
                            },
                            child: TextFormField(
                              focusNode: _emailFocus,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (value) {
                                _emailFocus.unfocus();
                                FocusScope.of(context)
                                    .requestFocus(_passwordFocus);
                                setState(() {
                                  _emailFocusColor = Color(0xffbbbbbb);
                                });
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                  top: 20.0,
                                  left: 20,
                                  bottom: 10,
                                ),

                                prefixIcon: Icon(
                                  Icons.alternate_email,
                                  color: _emailFocusColor,
                                ),

                                labelText: 'E-Mail',
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    style: BorderStyle.none, width: 0,
                                    // color: _titleColor,
                                  ),
                                ),
                                // focusColor: Colors.indigo,
                                labelStyle: TextStyle(color: _emailFocusColor),
                                // focusedBorder: UnderlineInputBorder(
                                //   borderSide: BorderSide(
                                //     style: BorderStyle.solid,
                                //     color: Colors.indigo,
                                //   ),
                                // ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value.isEmpty || !value.contains('@')) {
                                  return 'Invalid email!';
                                }
                              },
                              onSaved: (value) {
                                _authData['email'] = value;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          // PASSWORD FOCUS

                          Focus(
                            onFocusChange: (bool hasfocus) {
                              setState(() {
                                _passwordFocusColor = hasfocus
                                    ? Colors.indigo
                                    : Color(0xffbbbbbb);
                              });
                            },
                            child: TextFormField(
                              focusNode: _passwordFocus,
                              onFieldSubmitted: (value) {
                                setState(() {
                                  _passwordFocusColor = Color(0xffbbbbbb);
                                });
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                  // top: 20.0,
                                  left: 20,
                                  bottom: 10,
                                ),
                                // isDense: true,
                                labelText: 'Password',
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color: _passwordFocusColor,
                                ),
                                focusColor: Colors.indigo,
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    style: BorderStyle.none, width: 0,
                                    // color: _titleColor,
                                  ),
                                ),
                                labelStyle:
                                    TextStyle(color: _passwordFocusColor),
                                // focusedBorder: UnderlineInputBorder(
                                //   borderSide: BorderSide(color: Colors.indigo),
                                // ),
                              ),
                              obscureText: true,
                              controller: _passwordController,
                              validator: (value) {
                                if (value.isEmpty || value.length < 5) {
                                  return 'Password is too short!';
                                }
                              },
                              onSaved: (value) {
                                _authData['password'] = value;
                              },
                            ),
                          ),
                          // BUTTON TO SUBMIT
                          SizedBox(
                            height: 50,
                          ),
                          if (_isLoading)
                            CircularProgressIndicator()
                          else
                            Container(
                              width: double.infinity,
                              child: FlatButton(
                                // color: Color(0xffec6b67),
                                color: Color(0xff6C63FF),
                                textColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                onPressed: _signup,
                                child: Text(
                                  'SIGN IN',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),
                            ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Don't have an account? ",
                                  style: TextStyle(color: Color(0xffbbbbbb))),
                              GestureDetector(
                                onTap: () {
                                  // Navigator.pushReplacement(
                                  //   context,
                                  //   PageTransition(
                                  //     type: PageTransitionType.fade,
                                  //     child: SignUp(),
                                  //   ),
                                  // );
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "Sign up",
                                  style: TextStyle(
                                    color: Color(0xffec6b67),
                                  ),
                                ),
                              )
                            ],
                          ),
                          // Container(
                          //   height: 320,
                          //   decoration: BoxDecoration(
                          //     image: DecorationImage(
                          //       image: AssetImage("assets/images/signup.png"),
                          //     ),
                          //   ),
                          // )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
