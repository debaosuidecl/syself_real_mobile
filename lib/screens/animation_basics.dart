import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimationBasics extends StatefulWidget {
  @override
  _AnimationBasicsState createState() => _AnimationBasicsState();
}

class _AnimationBasicsState extends State<AnimationBasics>
    with SingleTickerProviderStateMixin {
  AnimationController animController;
  Animation<double> animation;
  @override
  void initState() {
    // TODO: implement initState
    animController =
        AnimationController(duration: Duration(seconds: 3), vsync: this);
    // vsync  synchronizes the fps to the fps of the device with the SingleTickerProviderStateMixin
    animController.forward();
    final CurvedAnimation curvedAnimation = CurvedAnimation(
      parent: animController,
      curve: Curves.linear,
      reverseCurve: Curves.bounceIn,
    );
    animation =
        Tween<double>(begin: 0, end: 2 * math.pi).animate(curvedAnimation)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              animController.reverse();
            }
          });
    // tween is an animatable convert to Animation with the .animate package
    // the tween generates the value
    // and we call setstate each time a value is generated
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RotatingTransition(
      child: GmailIcon(),
      angle: animation,
    ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animController.dispose();
    super.dispose();
  }
}

class RotatingTransition extends StatelessWidget {
  final Widget child;
  final Animation<double> angle;
  RotatingTransition({@required this.angle, @required this.child});
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: angle,
      builder: (context, child) {
        return Transform.rotate(
          angle: angle.value,
          child: child,
        );
      },
      child: child,
    );
  }
}

class GmailIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(50),
      alignment: Alignment.center,
      child: Image.asset("assets/images/Gmailicon.png"),
    );
  }
}
