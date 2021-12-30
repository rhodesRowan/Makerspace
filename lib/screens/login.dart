import 'package:firebase_auth/firebase_auth.dart';
import 'package:makerspace/helpers/app_colours.dart';
import 'package:makerspace/helpers/hex_color.dart';
import 'package:makerspace/widgets/authenticate_button.dart';
import 'package:makerspace/widgets/authenticate_social_container.dart';
import 'package:makerspace/widgets/authenticate_text_field.dart';
import 'package:makerspace/widgets/login_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:provider/src/provider.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0.0,
        centerTitle: true,
        title: Text("Login".toUpperCase(),
            style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
      ),
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        minimum: EdgeInsets.only(bottom: 50),
        child: SizedBox.expand(child: LoginForm()),
      ));
  }
}
