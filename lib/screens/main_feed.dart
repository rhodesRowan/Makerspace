import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_practise/services/auth_service.dart';
import 'package:firebase_practise/services/firestore_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainFeed extends StatelessWidget {

  TextEditingController _controller = TextEditingController();
  Firestore_Service _firestore = Firestore_Service();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        textTheme: TextTheme(
        headline6: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
            fontSize: 20
        )
        ),
        elevation: 0.0,
        title: Text("FEED"),
        leading: IconButton(
            icon: Icon(Icons.exit_to_app,
                color: Colors.redAccent),
            onPressed: () {
              AuthService().signOut();
            }),
        titleTextStyle: TextStyle(fontWeight: FontWeight.bold, backgroundColor: Colors.black),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
            stream: _firestore.getPostsStream(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text("Something went wrong");
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading...");
              }

              return ListView(
                  shrinkWrap: true,
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data();
                    return ListTile(
                      title: Text(data["post"]),
                      subtitle: Text(DateTime.fromMillisecondsSinceEpoch(
                          data["createdAt"]).toString()),
                    );
                  }).toList()
              );
            },
          ),
    );
  }
}