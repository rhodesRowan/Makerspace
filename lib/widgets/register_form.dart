import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:makerspace/helpers/app_colours.dart';
import 'package:makerspace/providers/auth_provider.dart';
import 'package:makerspace/widgets/error_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/src/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'authenticate_button.dart';
import 'authenticate_social_container.dart';
import 'authenticate_text_field.dart';
import 'package:makerspace/helpers/validator.dart';
import 'package:image/image.dart' as img;

class RegisterForm extends StatefulWidget {
  RegisterForm({Key? key}) : super(key: key);

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  XFile? _image;
  Uint8List? imageData;


  Future<XFile?> pickImage() async {
    return await _picker.pickImage(source: ImageSource.gallery);
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthProvider _auth = context.read<AuthProvider>();

    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: GestureDetector(
                  onTap: () async {
                    var image = await pickImage();
                    var bytes = await image?.readAsBytes();
                    setState(() {
                      _image = image;
                      imageData = bytes;
                    });
                  },
                  child: Stack(
                    children: [
                      CircleAvatar(
                        foregroundImage: imageData != null ? MemoryImage(imageData!) : Image.asset("assets/user.png")
                            .image,
                        maxRadius: 70,
                      ),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 4,
                                color: AppColors.orange,
                              ),
                              color: AppColors.orange,
                            ),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              AuthenticateTextField(
                hintText: "Name",
                controller: _nameController,
                maxLines: 1,
                validator: (value) {
                  return value?.nameValidator();
                },
              ),
              AuthenticateTextField(
                hintText: "Email",
                controller: _emailController,
                maxLines: 1,
                validator: (value) => value?.emailValidator(),
              ),
              AuthenticateTextField(
                  hintText: "Bio",
                  controller: _bioController,
                  obscureText: false,
                  hasCounter: true,
                  maxLines: 6,
                  validator: (value) => value?.isNotEmptyString()),
              AuthenticateTextField(
                hintText: "Password",
                obscureText: true,
                controller: _passwordController,
                maxLines: 1,
                validator: (value) => value?.passwordValidator(),
              ),
              AuthenticateTextField(
                hintText: "Confirm Password",
                obscureText: true,
                controller: _confirmPasswordController,
                maxLines: 1,
                validator: (value) =>
                    value?.confirmPasswordValidator(_passwordController.text),
              ),
              AuthenticateButton(
                  text: "Sign Up",
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        EasyLoading.show(status: "loading...");
                        await _auth.signUpWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text,
                            name: _nameController.text,
                            image: _image,
                            bio: _bioController.text,
                            context: context);
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
              Padding(padding: EdgeInsets.symmetric(horizontal: 35), child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: "By creating an account, you agree to the makerspace ",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: "terms and conditions",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold, decoration: TextDecoration.underline
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _launchURL("https://www.app-privacy-policy.com/live.php?token=o0qMLiR7xNIN0Rhk0GmI83fOvBiW1KnO");
                            }
                      ),
                      TextSpan(
                          text: " and "
                      ),
                      TextSpan(
                          text: "privacy policy",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold, decoration: TextDecoration.underline
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _launchURL("https://www.app-privacy-policy.com/live.php?token=7GfMlCerTuYMZ0NmTnivjOI6LYNj0lQU");
                            }
                      )
                    ]
                ),
              )
              ),
              AuthenticateSocialContainer(_auth),
            ],
          ),
        ));
  }
}
