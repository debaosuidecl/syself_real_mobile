import 'package:flutter/material.dart';

class SyselfForm extends StatelessWidget {
  final Function fieldSubmitted;
  final Color color;
  final IconData icontype;
  final String labeltext;
  final FocusNode focusNode;
  final FocusNode nextNode;
  final TextInputType type;
  final TextEditingController controller;
  final Function validator;
  final String control;
  final Function onSaved;
  final EdgeInsetsGeometry contentpadding;
  final Function handleFocus;

  SyselfForm(
      {@required this.fieldSubmitted,
      @required this.controller,
      this.icontype,
      this.contentpadding,
      @required this.labeltext,
      @required this.validator,
      @required this.onSaved,
      @required this.type,
      @required this.control,
      @required this.handleFocus,
      @required this.focusNode,
      this.nextNode,
      @required this.color});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Focus(
        onFocusChange: (bool hasFocus) {
          handleFocus(hasFocus, this.control);
        },
        child: TextFormField(
          // initialValue: "",
          autocorrect: false,
          focusNode: focusNode,
          textInputAction: TextInputAction.next,

          controller: controller,
          onFieldSubmitted: (value) =>
              fieldSubmitted(value, this.control, focusNode, nextNode),
          decoration: InputDecoration(
            contentPadding: contentpadding,
            suffixIcon: Icon(
              icontype,
              color: color,
            ),
            labelText: labeltext,
            labelStyle: TextStyle(color: color),
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                style: BorderStyle.solid,
                width: 0,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide(
                style: BorderStyle.solid,
                width: 0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                style: BorderStyle.solid,
                color: color,
                width: 0,
              ),
            ),
          ),
          keyboardType: type,
          validator: validator,
          // validator: (value) {
          //   if (value.isEmpty || !value.contains('@')) {
          //     return 'Invalid email!';
          //   }
          // },
          // onSaved: onSaved,
          onSaved: onSaved,
        ),
      ),
    );
  }
}
