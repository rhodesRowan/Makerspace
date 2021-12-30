import 'package:makerspace/helpers/app_colours.dart';
import 'package:makerspace/providers/auth_provider.dart';
import 'package:makerspace/widgets/authenticate_button.dart';
import 'package:makerspace/widgets/authenticate_text_field.dart';
import 'package:makerspace/helpers/validator.dart';
import 'package:makerspace/widgets/error_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/src/provider.dart';

class ForgotPassword extends StatefulWidget {
  @override
  State createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController forgotPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final AuthProvider _auth = context.read<AuthProvider>();
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            "Forgot Password".toUpperCase(),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
          ),
        ),
        body: SafeArea(
          minimum: EdgeInsets.only(bottom: 50),
          child: SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: size.width * 0.8,
                  child: Text(
                    "Enter the email address associated with your account and we'll send you a link to reset your password",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: AuthenticateTextField(
                    hintText: "email address",
                    controller: forgotPasswordController,
                    maxLines: 1,
                    validator: (value) => value?.emailValidator(),
                  ),
                ),
                AuthenticateButton(
                  text: "Reset Password",
                  onPressed: () async {
                    try {
                      if (_formKey.currentState!.validate()) {
                        EasyLoading.show(status: "Loading...");
                        await _auth.sendResetPasswordEmail(
                            forgotPasswordController.text);
                        EasyLoading.dismiss();
                      }
                    } catch (exception) {
                      EasyLoading.dismiss();
                      showFailedAuthDialog(context, exception.toString());
                    }
                  }
                )
              ],
            ),
          ),
        )
    );
  }
}
