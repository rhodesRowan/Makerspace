import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Leaderboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LEADERBOARD", style: TextStyle(backgroundColor: Colors.redAccent)),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Container(),
    );
  }
}