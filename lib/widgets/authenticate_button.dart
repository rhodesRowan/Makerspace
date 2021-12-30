import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class AuthenticateButton extends StatelessWidget {
  String text;
  Function onPressed;
  Color? backgroundColor;

  AuthenticateButton(
      {required this.text, required this.onPressed, Color? backgroundColor});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.7,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
          onPressed: () {
            this.onPressed();
          },
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );
  }
}
