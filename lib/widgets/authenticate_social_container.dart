import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:makerspace/providers/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'error_dialog.dart';

class AuthenticateSocialContainer extends StatelessWidget {
  AuthProvider _auth;

  AuthenticateSocialContainer(this._auth);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: socialButtons(context),
      ),
    );
  }

  List<Widget> socialButtons(BuildContext context) {
    var twitter = Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: SignInButton(Buttons.Twitter,
            mini: Platform.isIOS,
            padding: EdgeInsets.all(8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            onPressed: () async {
          try {
            EasyLoading.show(status: "Loading...");
            await _auth.signInWithTwitter(context);
            EasyLoading.dismiss();
            Navigator.pop(context);
          } on FirebaseAuthException catch (exception) {
            EasyLoading.dismiss();
            showFailedAuthDialog(context, exception.message);
          } catch (exception) {
            EasyLoading.dismiss();
          }
        }));

    var apple = Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: SignInButton(Buttons.Apple,
          mini: true,
          padding: EdgeInsets.all(8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          onPressed: () async {
        try {
          EasyLoading.show(status: "Loading...");
          await _auth.signInWithApple(context);
          Navigator.pop(context);
          EasyLoading.dismiss();
        } on FirebaseAuthException catch (exception) {
          EasyLoading.dismiss();
          showFailedAuthDialog(context, exception.message);
        } catch (exception) {
          EasyLoading.dismiss();
        }
      }),
    );

    return Platform.isIOS ? [twitter, apple] : [twitter];
  }
}
