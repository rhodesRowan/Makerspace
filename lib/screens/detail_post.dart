import 'package:makerspace/helpers/app_colours.dart';
import 'package:makerspace/models/post.dart';
import 'package:makerspace/providers/auth_provider.dart';
import 'package:makerspace/providers/firestore_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:makerspace/widgets/feed_tile.dart';
import 'package:provider/src/provider.dart';

class DetailPost extends StatefulWidget {
  DetailPost({required Post post}) : this._post = post;

  final Post _post;

  @override
  State<StatefulWidget> createState() => DetailPostState();
}

class DetailPostState extends State<DetailPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(widget._post.user.displayName.toUpperCase(),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(CupertinoIcons.back)),
        backgroundColor: AppColors.backgroundColor,
        centerTitle: true,
      ),
      body: Container(
          child: Column(
        children: [
          FeedTile(
              post: widget._post,
              isDetailView: true,
              currentUserID: context.read<AuthProvider>().getCurrentUser()!.uid,
              provider: context.read<FirestoreProvider>())
        ],
      )),
    );
  }
}
