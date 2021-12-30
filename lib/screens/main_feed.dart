import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:makerspace/helpers/app_colours.dart';
import 'package:makerspace/models/post.dart';
import 'package:makerspace/providers/auth_provider.dart';
import 'package:makerspace/screens/comments_page.dart';
import 'package:makerspace/providers/firestore_provider.dart';
import 'package:makerspace/screens/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:intl/intl.dart';
import 'package:makerspace/widgets/feed_tile.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/src/provider.dart';
import 'compose.dart';
import 'detail_post.dart';
import 'notifications.dart';
import 'package:badges/badges.dart';

class MainFeed extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainFeedState();
}

class MainFeedState extends State {
  Widget body = Text("");
  String title = "";
  String _numberOfNotifications = 0.toString();

  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    stream();
    body = home();
    title = "Makerspace";
  }

  stream() {
    context.read<FirestoreProvider>().getNotificationsStream().listen((event) {
      setState(() {
        _numberOfNotifications = event.where((element) => !(element.isRead)).length.toString();
      });
    });
  }

  String formatDate(DateTime date) => new DateFormat("dd-MM-yyyy").format(date);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          elevation: 0.0,
          title: Text(title.toUpperCase(),
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
          backgroundColor:
              AppColors.backgroundColor, //Color.fromRGBO(244, 246, 251, 1),
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: () {
                pushNewScreen(context,
                    screen: Notifications(),
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.slideUp);
                FlutterAppBadger.removeBadge();
              },
              child: Badge(
                  position: BadgePosition.topEnd(top: 0, end: -8),
                  stackFit: StackFit.passthrough,
                  showBadge: _numberOfNotifications != 0.toString(),
                  badgeContent: Text(_numberOfNotifications,
                      style: TextStyle(color: Colors.white)),
                  child: Icon(Icons.notifications, color: Colors.white)
                  // IconButton(onPressed: () {
                  // }, icon: Icon(Icons.notifications, color: Colors.white)),
                  ),
            ),
            SizedBox(width: 40)
          ],
        ),
        body: body);
  }

  Widget home() {
    return StreamBuilder(
      stream: context.read<FirestoreProvider>().getPostsStream(),
      builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
        if (snapshot.hasError) {
          return Text(
            "Something went wrong ${snapshot.error.toString()}",
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading...");
        }

        return ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: ScrollPhysics(),
            shrinkWrap: true,
            children: snapshot.data!.map((Post post) {
              return FeedTile(
                  post: post,
                  currentUserID:
                      context.read<AuthProvider>().getCurrentUser()!.uid,
                  provider: context.read<FirestoreProvider>());
            }).toList());
      },
    );
  }
}