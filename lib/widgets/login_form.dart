import 'package:firebase_auth/firebase_auth.dart';
import 'package:makerspace/helpers/validator.dart';
import 'package:makerspace/providers/auth_provider.dart';
import 'package:makerspace/screens/forgot_password.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:makerspace/screens/register.dart';
import 'package:provider/src/provider.dart';

import 'authenticate_button.dart';
import 'authenticate_social_container.dart';
import 'authenticate_text_field.dart';
import 'error_dialog.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final User? user = context.watch<User?>();
    AuthProvider _auth = context.read<AuthProvider>();

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AuthenticateTextField(
            controller: _emailController,
            hintText: "Email",
            maxLines: 1,
            validator: (value) => value?.emailValidator(),
          ),
          AuthenticateTextField(
            controller: _passwordController,
            hintText: "Password",
            obscureText: true,
            maxLines: 1,
            validator: (value) => value?.passwordValidator(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return ForgotPassword();
                    }));
                  },
                  child: Text("Forgot Password?",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold))),
              SizedBox(width: 35)
            ],
          ),
          AuthenticateButton(
              text: "Sign In",
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    EasyLoading.show(status: "loading...");
                    await _auth.signInWithEmailAndPassword(
                        _emailController.text,
                        _passwordController.text,
                        context);
                    EasyLoading.dismiss();
                    Navigator.pop(context);
                  } on FirebaseAuthException catch (exception) {
                    EasyLoading.dismiss();
                    showFailedAuthDialog(context, exception.message);
                  } catch (exception) {
                    EasyLoading.dismiss();
                    showFailedAuthDialog(context, exception.toString());
                  }
                }
              }),
          AuthenticateSocialContainer(_auth),
          TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Register();
                }));
              },
              child: RichText(
                text: TextSpan(
                  text: "Don't Have An Account? ",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: "Sign Up",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold, decoration: TextDecoration.underline
                        )
                    )
                  ]
                ),
              )
          )
        ],
      ),
    );
  }
}
