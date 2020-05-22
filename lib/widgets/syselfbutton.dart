import 'package:flutter/material.dart';

class SyselfButton extends StatelessWidget {
  final String content;
  final Color background;
  final Color textColor;
  final FontWeight fontWeight;

  SyselfButton(
      {@required this.content,
      @required this.background,
      @required this.textColor,
      @required this.fontWeight});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // reach facebook api
      },
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
              color: background,
              borderRadius: BorderRadius.circular(6)),
          alignment: Alignment.center,
          padding: EdgeInsets.all(15),
          width: double.infinity,
          child: Text(
            "CONTINUE WITH GOOGLE",
            style: TextStyle(
              color: textColor,
              fontWeight: fontWeight,
              fontSize: 17,
            ),
          ),
        ),
      ),
    );
  }
}
