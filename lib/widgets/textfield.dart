import 'package:flutter/material.dart';

class CTextField extends StatelessWidget {
  final String labelText;
  final bool autoFocus;
  CTextField({this.labelText, this.autoFocus});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: TextField(
        autofocus: autoFocus == null ? false : autoFocus,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(40.0))),
        ),
        style: TextStyle(color: Colors.white),
        cursorColor: Colors.white,
      ),
    );
  }
}
