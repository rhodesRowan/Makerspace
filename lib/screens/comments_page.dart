import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:makerspace/helpers/app_colours.dart';
import 'package:makerspace/screens/compose.dart';
import 'package:makerspace/screens/leaderboard.dart';
import 'package:makerspace/screens/notifications.dart';
import 'package:makerspace/screens/profile.dart';
import 'package:makerspace/providers/firestore_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/src/provider.dart';

class Comments extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CommentState();
}

class CommentState extends State {
  late Widget body;
  late String title;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    body = home();
    title = "Comments";
  }

  String formatDate(DateTime date) => new DateFormat("dd-MM-yyyy").format(date);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        bottomSheet: Container(
          padding: EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 32),
          color: AppColors.backgroundColor,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: AppColors.tileBackgroundColor,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(children: [
                new Expanded(
                  child: new TextField(
                    maxLines: null,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      //border: ,
                      hintStyle: TextStyle(color: Colors.white38),
                      hintText: "Add a comment",
                      fillColor: AppColors.tileBackgroundColor,
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.send, color: AppColors.orange))
              ]),
            ),
          ),
        ),
        appBar: AppBar(
          elevation: 0.0,
          title: Text(title.toUpperCase(),
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(CupertinoIcons.back)),
          backgroundColor: AppColors.backgroundColor,
          centerTitle: true,
        ),
        body: body);
  }

  Widget home() {
    return ListView(
        padding: EdgeInsets.all(0),
        shrinkWrap: true,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          Card(
              shadowColor: Colors.transparent,
              margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
              color: AppColors
                  .tileBackgroundColor, //Color.fromRGBO(255, 255, 255, 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      CircleAvatar(
                        foregroundImage: NetworkImage(
                            "https://thispersondoesnotexist.com/image"),
                        maxRadius: 25,
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Rowan Rhodes  🔥 2 ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white)),
                          Text("10 mins ago",
                              style: TextStyle(color: Colors.white70))
                        ],
                      ),
                      SizedBox(width: 10)
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      SizedBox(width: 25),
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      SizedBox(width: 10),
                      Text("added the push notifications to the first",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white))
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: 25),
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "changed the header colors",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.white),
                      )
                    ],
                  ),
                  SizedBox(height: 15),
                ],
              )),
          Divider(
            thickness: 1.0,
            color: Colors.white54,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: context.read<FirestoreProvider>().getTodosStream(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text("Something went wrong");
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading...");
              }

              return ListView(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Object? data = document.data();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 15),
                        Row(
                          children: [
                            SizedBox(width: 20),
                            CircleAvatar(
                              foregroundImage: NetworkImage(
                                  "https://thispersondoesnotexist.com/image"),
                              maxRadius: 25,
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Rowan Rhodes",
                                    style: TextStyle(color: Colors.white)),
                                Text("10 mins ago",
                                    style: TextStyle(color: Colors.white))
                              ],
                            ),
                            SizedBox(width: 10)
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            SizedBox(width: 75),
                            Text("Wow this looks so good man",
                                style: TextStyle(color: Colors.white))
                          ],
                        ),
                        SizedBox(height: 20),
                        Divider(height: 1.0, color: Colors.white54)
                      ],
                    );
                  }).toList());
            },
          ),
        ]);
  }
}
