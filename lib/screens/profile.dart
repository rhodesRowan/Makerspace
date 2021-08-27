import 'package:firebase_practise/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ROWAN RHODES"),
        backgroundColor: Colors.redAccent,
        actions: [
          IconButton(
              onPressed: () {
                AuthService().signOut();
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: Container(
        child: Column(
          children: [Text("This is the profile page")],
        ),
      ),
    );
  }
}
