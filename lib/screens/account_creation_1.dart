import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_animations/helperCode/platformspecific.dart';
import 'package:learn_animations/screens/home_page.dart';
import 'package:learn_animations/screens/select_user_type.dart';
import 'package:learn_animations/widgets/syself_form.dart';
import 'dart:io';
import '../providers/auth.dart';

import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class AccountCreationOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffffffff),
        // appBar: AppBar(
        //   leading: BackButton(
        //     // color: Color(0xffec6b67),
        //     color: Colors.indigo,
        //   ),
        //   elevation: 0,
        //   backgroundColor: Colors.white.withAlpha(0),
        // ),
        body: FutureBuilder(
          future: Provider.of<Auth>(context, listen: false).getIP(),
          builder: (ctx, dataSnapshot) {
            print(dataSnapshot);
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapshot.error != null) {
                // ...
                // Do error handling stuff
                return Center(
                  child: Text('An error occurred!'),
                );
              } else {
                return AccountCreationForm();
              }
            }
          },
        ));
  }
}

class AccountCreationForm extends StatefulWidget {
  @override
  _AccountCreationFormState createState() => _AccountCreationFormState();

  final String dialingCode;

  const AccountCreationForm({Key key, this.dialingCode}) : super(key: key);
}

class _AccountCreationFormState extends State<AccountCreationForm> {
  final Color _titlecolor = Color(0xff6C63FF);
  TextEditingController _firstNameController;
  final GlobalKey<FormState> _formKey = GlobalKey();

  bool _isLoading = false;
  final _firstnamefocus = FocusNode();
  final _lastnamefocus = FocusNode();
  final _usernamefocus = FocusNode();
  final _dailingcodefocus = FocusNode();
  final _phonefocus = FocusNode();
  final TextEditingController _lastNameController = new TextEditingController();
  final TextEditingController _userNameController = new TextEditingController();
  TextEditingController _phoneController;
  TextEditingController _dailingCodeController;
  Color _firstNameFocusColor = Color(0xffbbbbbb);
  Color _lastNameFocusColor = Color(0xffbbbbbb);
  Color _userNameFocusColor = Color(0xffbbbbbb);
  Color _dailingCodeFocusColor = Color(0xffbbbbbb);
  Color _phoneFocusColor = Color(0xffbbbbbb);
  Map<String, String> _accountCreationData = {
    'first_name': '',
    'last_name': '',
    'user_name': '',
    'phone': '',
    'dailing_code': ''
  };

  @override
  void initState() {
    final dialingCode = Provider.of<Auth>(context, listen: false).dailingCode;
    super.initState();
    setState(() {
      _dailingCodeController = TextEditingController(text: dialingCode);
      _accountCreationData['dailing_code'] = dialingCode;
    });
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

  Future<void> _toTheNextStage() async {
    // print(_formKey.currentState);
    _formKey.currentState.save();
    print(_accountCreationData);
    if (!_formKey.currentState.validate()) {
      // Invalid!

      print("invalid");
      return;
    }

    print(_accountCreationData);
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Auth>(context, listen: false)
          .toFinalRegStage(_accountCreationData);
      int regstep = Provider.of<Auth>(context, listen: false).regstep;

      if (regstep == 3) {
        setState(() {
          _isLoading = false;
        });
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.leftToRightWithFade,
            child: SelectUserType(),
          ),
        );
      }
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog(e.toString());
    }
  }

  Future<void> _signout() async {
    try {
      await Provider.of<Auth>(context, listen: false).logout();
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: HomePage(),
        ),
      );
    } catch (e) {
      print(e);
      _showErrorDialog(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Function _focusHandler = (bool hasFocus, String control) {
      switch (control) {
        case "first_name":
          {
            setState(() {
              _firstNameFocusColor =
                  hasFocus ? Color(0xff6C63FF) : Color(0xffbbbbbb);
            });
          }
          break;
        case "last_name":
          {
            setState(() {
              _lastNameFocusColor =
                  hasFocus ? Color(0xff6C63FF) : Color(0xffbbbbbb);
            });
          }
          break;

        case "user_name":
          {
            setState(() {
              _userNameFocusColor =
                  hasFocus ? Color(0xff6C63FF) : Color(0xffbbbbbb);
            });
          }
          break;
        case "dailing_code":
          {
            setState(() {
              _dailingCodeFocusColor =
                  hasFocus ? Color(0xff6C63FF) : Color(0xffbbbbbb);
            });
          }
          break;
        case "phone":
          {
            setState(() {
              _phoneFocusColor =
                  hasFocus ? Color(0xff6C63FF) : Color(0xffbbbbbb);
            });
          }
          break;
      }
    };

    Function _allBlurHandler = () {
      setState(() {
        _firstNameFocusColor = Color(0xffbbbbbb);
        _lastNameFocusColor = Color(0xffbbbbbb);
        _userNameFocusColor = Color(0xffbbbbbb);
        _dailingCodeFocusColor = Color(0xffbbbbbb);
        _phoneFocusColor = Color(0xffbbbbbb);
      });
    };
    String _validatorHandler(String value, String control) {
      // print(control);
      // print(value);
      String somethingtoreturn = "";
      if (control == "first_name") {
        if (value.isEmpty) {
          somethingtoreturn = 'Required';
          return somethingtoreturn;
        } else if (value.length < 3) {
          somethingtoreturn = "should be over 2 characters";
          return somethingtoreturn;
        }
      } else if (control == "last_name") {
        if (value.isEmpty) {
          somethingtoreturn = 'Required';
          return somethingtoreturn;
        } else if (value.length < 3) {
          somethingtoreturn = "should be over 3 characters";
          return somethingtoreturn;
        }
      } else if (control == "user_name") {
        if (value.isEmpty) {
          somethingtoreturn = 'Required';
          return somethingtoreturn;
        } else if (value.trim().contains(" ")) {
          somethingtoreturn = "must not contain space";
          return somethingtoreturn;
        } else if (value.length < 4) {
          somethingtoreturn = "should be over 4 characters";
          return somethingtoreturn;
        }
      } else if (control == "phone") {
        // print("hit here");
        if (value.isEmpty) {
          somethingtoreturn = 'Required';
          return somethingtoreturn;
        } else if (value.length < 10 || value.length > 10) {
          somethingtoreturn = "Must be 10 characters";
          return somethingtoreturn;
        }
        // print(somethingtoreturn);
      } else if (control == "dailing_code") {
        if (value.isEmpty) {
          somethingtoreturn = 'Required';
          return somethingtoreturn;
        } else if (!value.contains("+")) {
          somethingtoreturn = "Must contain '+'";
          return somethingtoreturn;
        }
      }

      // return null;

      // print(somethingtoreturn);
    }

    void _toNextInput(FocusNode currentNode, FocusNode nextNode) {
      currentNode.unfocus();
      FocusScope.of(context).requestFocus(nextNode);
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
        _allBlurHandler();
      },
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
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
              // SizedBox(
              //   height: 30,
              // ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  "Let's get started!",
                  style: TextStyle(
                    fontSize: 30,
                    color: _titlecolor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Set up your account",
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xffbbbbbb),
                  fontWeight: FontWeight.w400,
                ),
              ),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage("assets/images/step1reg.png"),
                  ),
                ),
              ),
              // SizedBox(
              //   height: 40,
              // ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SyselfForm(
                          focusNode: _firstnamefocus,
                          contentpadding: EdgeInsets.symmetric(horizontal: 10),
                          nextNode: _lastnamefocus,
                          controller: _firstNameController,
                          labeltext: "First name",
                          color: _firstNameFocusColor,
                          control: "first_name",
                          handleFocus: (bool hasFocus, String control) {
                            _focusHandler(hasFocus, control);
                          },
                          fieldSubmitted: (String data, String control,
                              FocusNode currentNode, FocusNode nextnode) {
                            // _accountCreationData["first_name"] = data;

                            _allBlurHandler();
                            _toNextInput(currentNode, nextnode);
                          },
                          type: TextInputType.text,
                          icontype: Icons.account_circle,
                          validator: (String data) {
                            return _validatorHandler(data, "first_name");
                          },
                          onSaved: (value) {
                            print(289);
                            // setState(() {
                            _accountCreationData["first_name"] = value;
                            // });
                          },
                        ),
                        SyselfForm(
                          focusNode: _lastnamefocus,
                          contentpadding: EdgeInsets.symmetric(horizontal: 10),
                          nextNode: _usernamefocus,
                          controller: _lastNameController,
                          labeltext: "Last name",
                          color: _lastNameFocusColor,
                          control: "last_name",
                          handleFocus: (bool hasFocus, String control) {
                            _focusHandler(hasFocus, control);
                          },
                          fieldSubmitted: (String data, String control,
                              FocusNode currentNode, FocusNode nextnode) {
                            // _accountCreationData["last_name"] = data;

                            _allBlurHandler();
                            _toNextInput(currentNode, nextnode);
                          },
                          type: TextInputType.text,
                          icontype: Icons.person,
                          validator: (String data) {
                            return _validatorHandler(data, "last_name");
                          },
                          onSaved: (value) {
                            _accountCreationData["last_name"] = value;
                          },
                        ),
                        SyselfForm(
                          focusNode: _usernamefocus,
                          contentpadding: EdgeInsets.symmetric(horizontal: 10),
                          nextNode: _dailingcodefocus,
                          fieldSubmitted: (String data, String control,
                              FocusNode currentNode, FocusNode nextnode) {
                            _accountCreationData["user_name"] = data;

                            _allBlurHandler();
                            _toNextInput(currentNode, nextnode);
                          },
                          controller: _userNameController,
                          labeltext: "Username",
                          color: _userNameFocusColor,
                          control: "user_name",
                          handleFocus: (bool hasFocus, String control) {
                            _focusHandler(hasFocus, control);
                          },
                          type: TextInputType.text,
                          icontype: Icons.account_box,
                          validator: (String data) {
                            return _validatorHandler(data, "user_name");
                          },
                          onSaved: (value) {
                            _accountCreationData["user_name"] = value;
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: SyselfForm(
                                focusNode: _dailingcodefocus,
                                // nextNode: _dailingcodefocus,
                                fieldSubmitted: (String data, String control,
                                    FocusNode currentNode, FocusNode nextnode) {
                                  // _accountCreationData["dailing_code"] = data;

                                  _allBlurHandler();
                                  // _toNextInput(currentNode, nextnode);
                                },
                                controller: _dailingCodeController,
                                labeltext: "code",
                                color: _dailingCodeFocusColor,
                                control: "dailing_code",
                                handleFocus: (bool hasFocus, String control) {
                                  _focusHandler(hasFocus, control);
                                },
                                type: TextInputType.phone,
                                // icontype: Icons.phone,
                                validator: (String data) {
                                  return _validatorHandler(
                                      data, "dailing_code");
                                },
                                onSaved: (value) {
                                  _accountCreationData["dailing_code"] = value;
                                },
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: SyselfForm(
                                focusNode: _phonefocus,
                                contentpadding:
                                    EdgeInsets.symmetric(horizontal: 10),

                                // nextNode: _dailingcodefocus,
                                fieldSubmitted: (String data, String control,
                                    FocusNode currentNode, FocusNode nextnode) {
                                  // _accountCreationData["phone"] = data;

                                  _allBlurHandler();
                                  // _toNextInput(currentNode, nextnode);
                                },
                                controller: _phoneController,
                                labeltext: "Phone number",
                                color: _phoneFocusColor,
                                control: "phone",
                                handleFocus: (bool hasFocus, String control) {
                                  _focusHandler(hasFocus, control);
                                },
                                type: TextInputType.phone,
                                icontype: Icons.phone,
                                validator: (String data) {
                                  return _validatorHandler(data, "phone");
                                },
                                onSaved: (value) {
                                  _accountCreationData["phone"] = value;
                                },
                              ),
                            ),
                          ],
                        ),
                        if (_isLoading)
                          CircularProgressIndicator()
                        else
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: FlatButton(
                              // color: Color(0xffec6b67),
                              color: Color(0xff6C63FF),
                              textColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 20.0),
                              onPressed: _toTheNextStage,
                              child: Text(
                                'NEXT STEP',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        SizedBox(
                          height: 30,
                        ),
                        FlatButton(
                          onPressed: _signout,
                          child: Text(
                            "Logout",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
