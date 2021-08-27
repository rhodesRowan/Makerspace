import 'package:firebase_practise/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

class Authenticate extends StatefulWidget {
  @override
  AuthenticateState createState() => AuthenticateState();

}

class AuthenticateState extends State<Authenticate> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Build In Public"),
      ),
      body: Container(
        child: Column(
          children: [
            SignInButton(Buttons.Twitter, onPressed: () {
              _auth.signInWithTwitter();
            })
          ],
        ),
      ),
    );
  }
}
