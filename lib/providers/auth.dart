import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  final facebookLogin = FacebookLogin();
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>['email', 'profile'],
  );
  String _token;
  // DateTime _expiryDate;
  String _userId;
  String _userType;
  String _dailingcode;
  String _firstName;
  String _lastName;
  String _loginMethod;
  String _userName;
  String _email;
  String _phone;
  String _avatar;
  int _regStep;
  bool _regComplete;
  // Timer _authTimer;
  final String _serverName =
      Platform.isIOS ? "http://0.0.0.0:2900" : "http://10.0.2.2:2900";
  bool get isAuth {
    print(_token);
    return _token != null;
  }

  bool get regComplete {
    return _regComplete;
  }

  String get dailingCode {
    return _dailingcode;
  }

  String get email {
    return _email;
  }

  // String get token {
  //   if (_expiryDate != null &&
  //       _expiryDate.isAfter(DateTime.now()) &&
  //       _token != null) {
  //     return _token;
  //   }
  //   return null;
  // }
  String get token {
    if (_token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> logintest(String email, String password) {
    print(email);
    print(password);
  }

  String get firstname {
    return _firstName;
  }

  String get lastname {
    return _lastName;
  }

  String get phone {
    return _phone;
  }

  String get username {
    return _userName;
  }

  int get regstep {
    return _regStep;
  }

  Future<void> authWithGoogle(GoogleSignInAccount currentUser) async {
    String displayName = currentUser.displayName;
    String email = currentUser.email;
    String googleid = currentUser.id;
    String avatar = currentUser.photoUrl;

    final registerUserInSyselfServerUrl =
        "$_serverName/api/auth/google-mobile-auth?displayName=$displayName&email=$email&picture=$avatar&googleid=$googleid";
    print("hit here 117");

    try {
      final response = await http.get(registerUserInSyselfServerUrl);
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['errors'] != null) {
        throw HttpException(responseData['errors'][0]['msg']);
      }
      _loginMethod = "google";
      _regComplete = responseData["regComplete"];
      _regStep = responseData["registrationStep"];

      _avatar = responseData["avatar"];
      _email = email;
      _token = responseData["token"];
      _userId = responseData["_id"];
      // _firstName = responseData["fi"]
      if (_regComplete) {
        // _firstName = first_name;
        // _lastName = last_name;
        _userName = responseData["userName"];
        _dailingcode = responseData["location"];
        _phone = responseData["phone"];
      }

      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': responseData["token"],
          'userId': responseData["_id"],
          // 'expiryDate': _expiryDate.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
      return responseData;
    } catch (e) {
      print(e);
      throw (e);
    }
    // String lastName = currentUser.displayName.split
  }

  Future<void> facebookAuth() async {
    var result;
    try {
      result = await facebookLogin.logIn(['email']);
    } catch (e) {
      print(e);
    }
    print(result);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=first_name,last_name,picture,email&access_token=${token}');
        final profile = json.decode(graphResponse.body);
        print(profile);
        final first_name = profile["first_name"];
        final last_name = profile["last_name"];
        print("hit here 110");
        final email = profile["email"];
        String picture;
        try {
          picture = profile["picture"]["data"]["url"];
        } catch (e) {
          picture = "";
        }

        final facebookid = profile["id"];

        final registerUserInSyselfServerUrl =
            "$_serverName/api/auth/facebook-mobile-auth?first_name=$first_name&last_name=$last_name&email=$email&picture=$picture&facebookid=$facebookid";
        print("hit here 117");
        try {
          final response = await http.get(registerUserInSyselfServerUrl);
          final responseData = json.decode(response.body);
          print(responseData);
          if (responseData['errors'] != null) {
            throw HttpException(responseData['errors'][0]['msg']);
          }
          _loginMethod = "facebook";
          _regComplete = responseData["regComplete"];
          _regStep = responseData["registrationStep"];

          _avatar = responseData["avatar"];
          _email = email;
          _token = responseData["token"];
          _userName = responseData["userName"];
          _userId = responseData["_id"];
          // _firstName = responseData["fi"]
          if (_regComplete) {
            _firstName = first_name;
            _lastName = last_name;
            _dailingcode = responseData["location"];
            _phone = responseData["phone"];
          }

          notifyListeners();
          final prefs = await SharedPreferences.getInstance();
          final userData = json.encode(
            {
              'token': responseData["token"],
              'userId': responseData["_id"],
              // 'expiryDate': _expiryDate.toIso8601String(),
            },
          );
          prefs.setString('userData', userData);
          return responseData;
        } catch (e) {
          print(e);
          throw (e);
        }

        break;

      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        break;
    }
  }

  Future<void> submitAccountSetUp(String selectedUser) async {
    // _userType;
    // print(_firstName);
    // print(_firstName);
    try {
      final postresponse = await http.post(
        "$_serverName/api/auth/final-reg-step",
        headers: {
          "Content-Type": "application/json",
          "x-auth-token": _token,
        },
        body: json.encode(
          {
            "email": _email,
            "location": _dailingcode,
            "firstName": _firstName,
            "lastName": _lastName,
            "userName": _userName,
            "phoneNumber": _phone
          },
        ),
      );
      if (json.decode(postresponse.body)['errors'] != null) {
        throw HttpException(json.decode(postresponse.body)['errors'][0]['msg']);
      }

      final data = json.decode(postresponse.body);
      print(data);
      if (data["success"] != true) {
        throw HttpException(
            "an unexpected error occured in creating your account");
      }
      _regComplete = true;
      _userType = selectedUser;
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }

    // final prefs = await SharedPreferences.getInstance();

    // final extractedUserData =
    //     json.decode(prefs.getString('userData')) as Map<String, Object>;
    // print(extractedUserData);
    return null;
    //  _dailingcode;
    //  _firstName;
    //  _lastName;
    //  _userName;
    //  _phone;
  }

  Future<void> toFinalRegStage(Map setupdata) async {
    try {
      final responseData = await http.get(
          "$_serverName/api/user/unique-username?username=${setupdata['user_name']}");

      print(json.decode(responseData.body));
      if (json.decode(responseData.body)['unique'] != true) {
        throw HttpException("Username is already in use");
      }
      final responseForPhone = await http.get(
          "$_serverName/api/user/check-unique-phone?username=${setupdata['phone']}&location=${setupdata["dailing_code"]}");
      if (json.decode(responseForPhone.body)['unique'] != true) {
        throw HttpException("Phone is already connected to another account");
      }

      // return;
      _dailingcode = setupdata["dailing_code"];
      _firstName = setupdata["first_name"];
      _lastName = setupdata["last_name"];
      _userName = setupdata["user_name"];
      _phone = setupdata["phone"];
      _regStep = 3;

      notifyListeners();
      return null;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> _authenticate(
      String email, String password, bool isSignIn) async {
    print(email);
    print(password);
    final url = isSignIn
        ? "$_serverName/api/auth/signin-local"
        : '$_serverName/api/auth/local';

    try {
      print(url);
      final deba = json.encode(
        {
          'email': email,
          'password': password,
          // 'returnSecureToken': true,
        },
      );
      print(deba);
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(
          {
            'email': email.trim(),
            'password': password.trim(),
            // 'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);

      print(response.body);

      print("line 76");
      if (responseData['errors'] != null) {
        throw HttpException(responseData['errors'][0]['msg']);
      }
      _token = responseData['token'];
      _userId = responseData['_id'];
      if (responseData["regComplete"] == false) {
        print("not yet complete");
      }

      _regComplete = responseData["regComplete"] as bool;

      // _expiryDate = DateTime.now().add(
      //   Duration(
      //     seconds: int.parse(
      //       responseData['expiresIn'],
      //     ),
      //   ),
      // );
      // _autoLogout();

      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          // 'expiryDate': _expiryDate.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
      return responseData;
    } catch (error) {
      // print(error);
      // print("an error");
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, false);
  }

  Future<void> getIP() async {
    final url = "https://ip.nf/me.json";
    final response = await http.get(url);
    final responseData = json.decode(response.body);

    print(responseData["ip"]["country_code"]);

    final postresponse = await http.post(
      "$_serverName/api/auth/get_ip",
      headers: {"Content-Type": "application/json"},
      body: json.encode(
        {
          "country_code": responseData["ip"]["country_code"]
          // 'returnSecureToken': true,
        },
      ),
    );
    final dailingCodeData = json.decode(postresponse.body);
    print(dailingCodeData);
    _dailingcode = dailingCodeData['country_code'];
    // notifyListeners();
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, true);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    // final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    // if (expiryDate.isBefore(DateTime.now())) {
    //   return false;
    // }

    try {
      final postresponse = await http.get(
        "$_serverName/api/auth",
        headers: {
          "Content-Type": "application/json",
          "x-auth-token": extractedUserData['token'],
        },

        // body: json.encode(
        //   {
        //     // "country_code": responseData["ip"]["country_code"]
        //     // 'returnSecureToken': true,

        //   },
        // ),
      );

      if (json.decode(postresponse.body)['errors'] != null) {
        throw HttpException(json.decode(postresponse.body)['errors'][0]['msg']);
      }

      print(
        json.decode(postresponse.body),
      );
      Map<String, dynamic> responseData = json.decode(postresponse.body);
      _regComplete = responseData['regComplete'];
      _email = responseData['email'];
      _token = extractedUserData['token'];
      _userId = extractedUserData['userId'];
      // await Duration(milliseconds: 2000);
      await Future.delayed(Duration(milliseconds: 2000));

      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }

    // _expiryDate = expiryDate;
    notifyListeners();
    // _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    //  _userId =;
    _userType = null;
    _dailingcode = null;
    _firstName = null;
    _lastName = null;
    _userName = null;
    _email = null;
    _phone = null;
    _regStep = null;
    _regComplete = null;
    // _expiryDate = null;
    // if (_authTimer != null) {
    //   _authTimer.cancel();
    //   _authTimer = null;
    // }
    if (_loginMethod == "facebook") {
      facebookLogin.logOut();
    }
    if (_loginMethod == "google") {
      _googleSignIn.signOut();
      // _googleSignIn.signOut();
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
  }

  // void _autoLogout() {
  //   if (_authTimer != null) {
  //     _authTimer.cancel();
  //   }
  //   final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
  //   _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  // }
}
