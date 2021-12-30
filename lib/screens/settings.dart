import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:makerspace/helpers/app_colours.dart';
import 'package:makerspace/models/makerspace_notification.dart';
import 'package:makerspace/providers/auth_provider.dart';
import 'package:makerspace/providers/firestore_provider.dart';
import 'package:makerspace/providers/local_storage_provider.dart';
import 'package:makerspace/screens/update_account_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:makerspace/models/makerspace_user.dart';

class AccountSettings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    AuthProvider _auth = context.read<AuthProvider>();
    MakerspaceUser? _user = context.read<LocalStorageProvider>().user;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          elevation: 0,
          centerTitle: true,
          title: Text("Settings".toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.w900)),
          actions: [
            IconButton(
                onPressed: () {
                  _auth.signOut(context);
                  Navigator.pop(context);
                },
                icon: Icon(Icons.logout, color: Colors.white))
          ],
          leading: CloseButton(
            color: Colors.white,
            onPressed: () => Navigator.of(context).pop(null),
          ),
        ),
        body: Consumer<LocalStorageProvider>(
          builder: (context, localstorage, child) => Container(
            color: AppColors.backgroundColor,
            padding: EdgeInsets.only(left: 16, top: 0, right: 16),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: ListView(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          foregroundImage: NetworkImage(localstorage.user?.photoUrl != null ? localstorage.user!.photoUrl! : ""),
                          backgroundImage: AssetImage("assets/user.png"),
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
                  SizedBox(height: 10),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    color: AppColors.tileBackgroundColor,
                    child: ListTile(
                      onTap: () {
                        pushNewScreen(context,
                            screen: UpdateAccountField(
                                field: AccountField.DisplayName));
                      },
                      subtitle: Text(localstorage.user?.displayName ?? "",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                              fontSize: 14)),
                      title: Text("Display Name",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white)),
                      trailing: Icon(Icons.chevron_right,
                          color: Colors.white, size: 30),
                    ),
                  ),
                  Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      color: AppColors.tileBackgroundColor,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: ListTile(
                          onTap: () {
                            pushNewScreen(context,
                                screen: UpdateAccountField(
                                    field: AccountField.Bio));
                          },
                          title: Text("Bio",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white)),
                          subtitle: Text(localstorage.user?.bio ?? "",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                  fontSize: 14)),
                          trailing: Icon(Icons.chevron_right,
                              color: Colors.white, size: 30),
                        ),
                      )),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    color: AppColors.tileBackgroundColor,
                    child: ListTile(
                      onTap: () {
                        pushNewScreen(context,
                            screen: UpdateAccountField(
                                field: AccountField.Website));
                      },
                      title: Text("Website",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white)),
                      subtitle: Text(localstorage.user?.website ?? "",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                              fontSize: 14)),
                      trailing: Icon(Icons.chevron_right,
                          color: Colors.white, size: 30),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    color: AppColors.tileBackgroundColor,
                    child: ListTile(
                      onTap: () {
                        pushNewScreen(context,
                            screen: UpdateAccountField(
                                field: AccountField.IndieHackers));
                      },
                      subtitle: Text(
                          localstorage.user?.indieHackersHandle ?? "",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                              fontSize: 14)),
                      title: Text("Indie Hackers",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white)),
                      trailing: Icon(Icons.chevron_right,
                          color: Colors.white, size: 30),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    color: AppColors.tileBackgroundColor,
                    child: ListTile(
                      onTap: () {
                        pushNewScreen(context,
                            screen: UpdateAccountField(
                                field: AccountField.TwitterHandle));
                      },
                      subtitle: Text(localstorage.user?.twitterHandle ?? "",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                              fontSize: 14)),
                      title: Text("Twitter",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white)),
                      trailing: Icon(Icons.chevron_right,
                          color: Colors.white, size: 30),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20),
        textAlign: TextAlign.start,
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Colors.grey,
                    ),
                  )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            labelStyle: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Colors.grey,
            )),
      ),
    );
  }
}
