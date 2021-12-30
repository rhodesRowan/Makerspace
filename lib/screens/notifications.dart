import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:makerspace/helpers/app_colours.dart';
import 'package:makerspace/models/makerspace_notification.dart';
import 'package:makerspace/providers/firestore_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/src/provider.dart';

import 'detail_post.dart';

class Notifications extends StatefulWidget {
  var items = List.generate(100, (index) => "item ${index}");

  @override
  State<StatefulWidget> createState() => NotificationsState();
}

class NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("NOTIFICATIONS",
            style: TextStyle(fontWeight: FontWeight.w900)),
        backgroundColor: AppColors.backgroundColor,
        elevation: 0.0,
        leading: CloseButton(
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(null),
        ),
      ),
      backgroundColor: AppColors.backgroundColor,
      body: StreamBuilder(
        stream: context.read<FirestoreProvider>().getNotificationsStream(),
        builder: (BuildContext context,
            AsyncSnapshot<List<MakerspaceNotification>> snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading...");
          }

          return ListView(
              shrinkWrap: true,
              children:
                  snapshot.data!.map((MakerspaceNotification notification) {
                return GestureDetector(
                    onTap: () {
                      pushNewScreen(context,
                          screen: DetailPost(
                            post: notification.post,
                          ),
                          withNavBar: true);
                      setState(() {
                        context
                            .read<FirestoreProvider>()
                            .markAsRead(notification.post);
                      });
                    },
                    child: Card(
                        shadowColor: Colors.transparent,
                        margin: EdgeInsets.only(
                            left: 16, right: 16, top: 8, bottom: 8),
                        color: AppColors.tileBackgroundColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 15),
                            Row(
                              children: [
                                SizedBox(width: 15),
                                Container(
                                  width: 15.0,
                                  height: 15.0,
                                  decoration: new BoxDecoration(
                                    color: (notification.isRead)
                                        ? Colors.transparent
                                        : AppColors.orange,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 10),
                                CircleAvatar(
                                  foregroundImage:
                                      NetworkImage(notification.user.photoUrl != null ? notification.user.photoUrl! : ""),
                                  maxRadius: 25,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                    child: Text(
                                        "${notification.user.displayName} ${notification.text}",
                                        style: TextStyle(color: Colors.white))),
                              ],
                            ),
                            SizedBox(height: 15)
                          ],
                        )));
              }).toList());
        },
      ),
    );
  }
}
