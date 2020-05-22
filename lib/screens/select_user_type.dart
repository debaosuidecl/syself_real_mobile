import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_animations/helperCode/platformspecific.dart';
import 'package:learn_animations/providers/auth.dart';
import 'package:learn_animations/screens/dashboard.dart';
import 'package:learn_animations/screens/home_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class SelectUserType extends StatefulWidget {
  @override
  _SelectUserTypeState createState() => _SelectUserTypeState();
}

class _SelectUserTypeState extends State<SelectUserType>
    with SingleTickerProviderStateMixin {
  // set up the animation controller and the animation variable
  AnimationController buttonScaleController;
  Animation<double> buttonScaleAnim;

  @override
  void initState() {
    super.initState();

    // TODO: implement initState
    buttonScaleController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    // vsync  synchronizes the fps to the fps of the device with the SingleTickerProviderStateMixin
    // final CurvedAnimation curvedAnimation = CurvedAnimation(
    //   parent: buttonScaleController,
    //   curve: Curves.linear,
    //   reverseCurve: Curves.bounceIn,
    // );
    buttonScaleAnim = Tween<double>(
      begin: 0,
      end: 30,
    ).animate(buttonScaleController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // animController.reverse();
          Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child: Dashboard(),
            ),
          );
        }
      });
    // buttonScaleController.forward();
  }

  final Color _titlecolor = Color(0xff6C63FF);
  String _selectedUser = "";
  List<String> userType = [
    "Freelancer",
    "Jobseeker",
    "Project owner",
    "Recruiter"
  ];

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
    void _selectToggle(String userType) {
      if (_selectedUser != userType) {
        setState(() {
          _selectedUser = userType;
        });
      } else {
        setState(() {
          _selectedUser = "";
        });
      }
    }

    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Row(
              children: <Widget>[
                InkWell(
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
            SizedBox(
              height: 60,
            ),
            Text(
              "Join us",
              style: TextStyle(
                fontSize: 35,
                color: _titlecolor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "as a",
              style: TextStyle(
                fontSize: 19,
                color: Color(0xffbbbbbb),
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            for (int i = 0; i < userType.length; i++)
              GestureDetector(
                onTap: () {
                  _selectToggle(userType[i]);
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    // color: _selectedUser == userType[i]?,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    decoration: BoxDecoration(
                      color: _selectedUser == userType[i]
                          ? Colors.red
                          : Colors.white,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Color(0xffeeeeee).withOpacity(1),
                          offset: Offset(1, 1),
                          spreadRadius: 1.6,
                        )
                      ],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      userType[i],
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: _selectedUser == userType[i]
                              ? Colors.white
                              : Color(0xff777777)),
                    ),
                  ),
                ),
              ),
            SizedBox(
              height: 75,
            ),
            Text(
              "Proceed to dashboard",
              style: TextStyle(
                color: Color(0xff555555),
                fontWeight: FontWeight.w300,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  height: 90,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _titlecolor.withOpacity(.51)
                      // color: buttonOpacityAnimation.value,
                      ),
                ),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _titlecolor.withOpacity(1),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    print("go");
                    if (_selectedUser.length > 1) {
                      try {
                        await Provider.of<Auth>(context)
                            .submitAccountSetUp(_selectedUser);
                        buttonScaleController.forward();
                      } catch (e) {
                        _showErrorDialog(e.toString());
                      }
                    }
                  },
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                ),
                ScaleAnimation(
                  size: buttonScaleAnim,
                  color: _titlecolor,
                  child: ScaleCircle(
                    color: _titlecolor,
                  ),
                ),
              ],
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
    );
  }
}

class ScaleAnimation extends StatelessWidget {
  final Widget child;
  final Animation<double> size;
  final Color color;
  const ScaleAnimation({
    // @required Color titlecolor,
    this.child,
    @required this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: size,
      builder: (context, child) {
        return Transform.scale(
          scale: size.value,
          child: child,
        );
      },
      child: child,
    );
  }
}

class ScaleCircle extends StatelessWidget {
  final Color color;
  const ScaleCircle({this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
