import 'package:flutter/material.dart';
import 'package:learn_animations/screens/account_creation_1.dart';
import 'package:learn_animations/screens/animation_basics.dart';
import 'package:learn_animations/screens/dashboard.dart';
import 'package:learn_animations/screens/select_user_type.dart';
import 'package:learn_animations/screens/sign_in.dart';
import 'package:learn_animations/screens/signup.dart';
import 'package:learn_animations/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import './providers/auth.dart';

import 'package:learn_animations/screens/home_page.dart';
import 'package:learn_animations/screens/page_2.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return
        // providers: [
        //   ChangeNotifierProvider.value(
        //   value: Auth(),
        // ),
        //debaosuideclfds23@gmail.com
        // ],
        MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          // home: AnimationBasics(),
          // home: SelectUserType(),
          // home: SignIn(),
          // home: HomePage(),
          // home: AccountCreationOne(),
          // home: Dashboard(),
          home: auth.isAuth && auth.regComplete != true
              ? AccountCreationOne()
              : auth.isAuth
                  ? Dashboard()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (ctx, authResultSnapshot) =>
                          authResultSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? SplashScreen()
                              : HomePage(),
                    ),
          routes: {
            HomePage.routeName: (ctx) => HomePage(),
            PageTwo.routeName: (ctx) => PageTwo(),
          },
        ),
      ),
    );
  }
}
