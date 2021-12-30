import 'package:makerspace/helpers/app_colours.dart';
import 'package:makerspace/providers/auth_provider.dart';
import 'package:makerspace/providers/firestore_provider.dart';
import 'package:makerspace/widgets/authenticate_button.dart';
import 'package:makerspace/widgets/authenticate_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:makerspace/helpers/validator.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/src/provider.dart';

enum AccountField { DisplayName, Bio, Website, IndieHackers, TwitterHandle }

class UpdateAccountField extends StatefulWidget {
  final AccountField field;

  UpdateAccountField({required this.field});

  @override
  State<StatefulWidget> createState() => UpdateAccountFieldState();
}

class UpdateAccountFieldState extends State<UpdateAccountField> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();

  String GetTitle() {
    switch (widget.field) {
      case AccountField.DisplayName:
        return "Display Name".toUpperCase();
      case AccountField.Bio:
        return "Bio".toUpperCase();
      case AccountField.IndieHackers:
        return "Indie Hackers Handle".toUpperCase();
      case AccountField.TwitterHandle:
        return "Twitter handle".toUpperCase();
      case AccountField.Website:
        return "Website".toUpperCase();
    }
  }

  String? validator(String? value) {
    switch (widget.field) {
      case AccountField.DisplayName:
        return value?.nameValidator();
      case AccountField.Bio:
        return value?.isNotEmptyString();
      case AccountField.IndieHackers:
        return value?.socialHandleValidator();
      case AccountField.TwitterHandle:
        return value?.socialHandleValidator();
      case AccountField.Website:
        return value?.urlValidator();
    }
  }

  Future<bool> submit() {
    switch (widget.field) {
      case AccountField.DisplayName:
        return context
            .read<AuthProvider>()
            .updateDisplayName(context: context, name: _controller.text);
      case AccountField.Bio:
        return context.read<FirestoreProvider>().saveBio(_controller.text);
      case AccountField.IndieHackers:
        return context
            .read<FirestoreProvider>()
            .saveIndieHackersHandle(_controller.text);
      case AccountField.TwitterHandle:
        return context
            .read<FirestoreProvider>()
            .saveTwitterHandle(_controller.text);
      case AccountField.Website:
        return context.read<FirestoreProvider>().saveURL(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.backgroundColor,
          title: Text(GetTitle(),
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
        ),
        backgroundColor: AppColors.backgroundColor,
        body: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                AuthenticateTextField(
                    hintText: GetTitle().toLowerCase(),
                    controller: _controller,
                    obscureText: false,
                    padding: 5,
                    hasCounter: widget.field == AccountField.Bio,
                    maxLines: (widget.field == AccountField.Bio) ? 4 : 1,
                    validator: (value) => validator(value)),
                AuthenticateButton(
                    text: "Update",
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          if (await submit()) {
                            Navigator.of(context).pop();
                          }
                        } catch (exception) {
                          EasyLoading.dismiss();
                        }
                      }
                    }),
              ],
            ),
          ),
        ));
  }
}
