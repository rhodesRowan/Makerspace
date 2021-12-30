import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:makerspace/helpers/app_colours.dart';
import 'package:makerspace/models/post.dart';
import 'package:makerspace/providers/firestore_provider.dart';
import 'package:makerspace/screens/detail_post.dart';
import 'package:makerspace/screens/profile.dart';
import 'package:makerspace/screens/report_content.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:timeago/timeago.dart' as timeago;


class FeedTile extends StatelessWidget {
  const FeedTile(
      {Key? key,
        required Post post,
        bool isDetailView = false,
        required String currentUserID,
        required FirestoreProvider provider})
      : _post = post,
        this._firestore = provider,
        _isDetailView = isDetailView,
        this.currentUserID = currentUserID,
        super(key: key);

  final bool isLiked = false;
  final String currentUserID;
  final FirestoreProvider _firestore;

  handleLikedPost() {
    if (_post.likes[currentUserID] == true) {
      _firestore.toggleLike(false, _post.id, _post.user.id);
    } else {
      _firestore.toggleLike(true, _post.id, _post.user.id);
    }
  }

  List<Widget> updates(BuildContext context) {
    List<Widget> postWidgets = List.empty(growable: true);

    for (var update in _post.todos) {
      if (_post.todos.indexOf(update) < 4 || _isDetailView) {
        var updateRow = Row(children: [
          SizedBox(width: 25),
          Icon(
            Icons.check_circle,
            color: Colors.green,
          ),
          SizedBox(width: 10),
          Expanded(
              child: Text(update,
                  style: TextStyle(color: Colors.white, fontSize: 16))),
          SizedBox(width: 20, height: 20)
        ]);
        postWidgets.add(updateRow);
      }
    }

    if (_post.todos.length > 4 && !_isDetailView) {
      var seeMoreButton = new TextButton(
          onPressed: () {
            pushNewScreen(context,
                screen: DetailPost(post: _post), withNavBar: true);
          },
          child: Text("See More"));
      postWidgets.add(seeMoreButton);
    }

    postWidgets.add(SizedBox(height: 20));
    return postWidgets;
  }

  final Post _post;
  final bool _isDetailView;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Positioned(
          child: Card(
              shadowColor: Colors.transparent,
              margin: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 20),
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
                        foregroundImage: NetworkImage(_post.user.photoUrl != null ? _post.user.photoUrl! : ""),
                        backgroundImage: AssetImage("assets/user.png"),
                        maxRadius: 25,
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: EdgeInsets.all(2),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              pushNewScreen(context,
                                  screen: Profile(_post.userID));
                            },
                            child: Text(
                                "${_post.user.displayName}  🔥 ${_post.user.streak?.count} ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white)),
                          ),
                          Text(timeago.format(_post.updatedAt),
                              style: TextStyle(color: Colors.white70))
                        ],
                      ),
                      SizedBox(width: 10),
                      Expanded(child: SizedBox()),
                      PopupMenuButton(
                        icon: Icon(CupertinoIcons.ellipsis, color: Colors.white),
                        itemBuilder: (context) => [
                          PopupMenuItem(child: TextButton(onPressed: () {
                            pushNewScreen(context, screen: ReportContent(postID: _post.id));
                          },
                          child: Text("Report")))
                        ])
                    ],
                  ),
                  SizedBox(height: 15),
                  Column(children: updates(context)),
                  SizedBox(height: 15)
                ],
              )),
        ),
        Positioned(
            right: 40,
            child: Row(
              children: [
                SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.green, width: 1.5),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    padding: EdgeInsets.all(12),
                    primary: Colors.green, //AppColors.blue,
                    onPrimary: Colors.black,
                  ),
                  onPressed: () {
                    handleLikedPost();
                  },
                  child: Row(
                    children: [
                      Icon(
                          (_post.likes[currentUserID] == true)
                              ? Icons.celebration
                              : Icons.celebration_outlined,
                          color: Colors.white),
                      SizedBox(width: 6),
                      Text(
                          "${_post.likes.values.where((element) => element as bool == true).length}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ],
                  ),
                ),
              ],
            )),
      ],
    );
  }
}
