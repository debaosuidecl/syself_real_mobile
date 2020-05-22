import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_animations/helperCode/platformspecific.dart';
import 'package:learn_animations/screens/account_creation_1.dart';
import 'package:learn_animations/screens/sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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
    _formKey.currentState.save();
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Auth>(context, listen: false).signup(
        _authData['email'],
        _authData['password'],
      );
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.rotate,
          child: AccountCreationOne(),
        ),
      );
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
      // appBar: AppBar(
      //   leading: BackButton(
      //     // color: Color(0xffec6b67),
      //     color: Colors.indigo,
      //   ),
      //   elevation: 0,
      //   backgroundColor: Colors.white.withAlpha(0),
      //   // backgroundColor: Platform.isIOS ? Color(0xffffffff) : Colors.white,
      //   // title: Text("Sign up with email", style: TextStyle()),
      // ),
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
                SizedBox(
                  height: 40,
                ),
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: BackButton(
                        // color: Color(0xffec6b67),
                        color: Colors.indigo,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.center,
                  child: Text(
                    "Sign up with E-Mail",
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
                  "Create your account",
                  style: TextStyle(
                    color: Color(0xffbbbbbb),
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                SingleChildScrollView(
                  child: Form(
                    // autovalidate: false,
                    key: _formKey,
                    child: Container(
                      padding: EdgeInsets.all(20),
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
                              onFieldSubmitted: (value) {
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
                                  'CREATE ACCOUNT',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Already have an account? ",
                                  style: TextStyle(color: Color(0xffbbbbbb))),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType
                                          .rightToLeftWithFade,
                                      child: SignIn(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Color(0xffec6b67),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Container(
                            height: 220,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/signup.png"),
                              ),
                            ),
                          )
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
