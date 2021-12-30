import 'package:makerspace/helpers/app_colours.dart';
import 'package:makerspace/widgets/register_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          elevation: 0.0,
          centerTitle: true,
          title: Text("Register".toUpperCase(),
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
        ),
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: RegisterForm(),
          ),
        );
  }
}
