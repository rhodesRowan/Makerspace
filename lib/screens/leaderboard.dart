import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:makerspace/helpers/app_colours.dart';
import 'package:makerspace/providers/firestore_provider.dart';
import 'package:makerspace/screens/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/src/provider.dart';
import 'package:makerspace/models/streak.dart';
import 'package:makerspace/models/makerspace_user.dart';

class Leaderboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LeaderboardState();
  }
}

class LeaderboardState extends State<Leaderboard> {
  @override
  Widget build(BuildContext context) {
    List<String> data = ['PRODUCTS', 'LEADERBOARD'];
    int initPosition = 0;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.backgroundColor,
        elevation: 0.0,
        title: Text("Leaderboard".toUpperCase(),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
      ),
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
          child: LeaderboardList(firestore: context.read<FirestoreProvider>())),
    );
  }
}

class LeaderboardList extends StatelessWidget {
  const LeaderboardList({
    required FirestoreProvider firestore,
  }) : _firestore = firestore;

  final FirestoreProvider _firestore;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firestore.getStreaksStream(),
      builder:
          (BuildContext context, AsyncSnapshot<List<MakerspaceUser>> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading...");
        }

        return Container(
            color: AppColors.backgroundColor,
            child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                shrinkWrap: true,
                children: snapshot.data!.map((MakerspaceUser user) {
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    margin: EdgeInsets.all(8),
                    child: ListTile(
                      onTap: () {
                        pushNewScreen(context,
                            screen: new Profile(user.id));
                      },
                      contentPadding: EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      tileColor: AppColors.tileBackgroundColor,
                      leading: CircleAvatar(
                        foregroundImage: NetworkImage(user.photoUrl != null ? user.photoUrl! : ""),
                        backgroundImage: AssetImage("assets/user.png"),
                        maxRadius: 25,
                      ),
                      title: Text(user.displayName, style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      trailing: Text(
                        "🔥 ${user.streak?.count}",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  );
                }).toList()));
      },
    );
  }
}

class ProductList extends StatelessWidget {
  const ProductList({
    required FirestoreProvider firestore,
  }) : _firestore = firestore;

  final FirestoreProvider _firestore;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.getTodosStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading...");
        }

        return Container(
            color: AppColors.backgroundColor,
            child: ListView(
                shrinkWrap: true,
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    margin: EdgeInsets.all(8),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      tileColor: AppColors.tileBackgroundColor,
                      leading: CircleAvatar(
                        foregroundImage: NetworkImage(
                            "https://thispersondoesnotexist.com/image"),
                        maxRadius: 25,
                      ),
                      title: Text("MyFirstProduct.com",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      subtitle: Text("made by Rowan Rhodes",
                          style: TextStyle(color: Colors.grey)),
                      trailing: IconButton(
                          icon: Icon(Icons.chevron_right, color: Colors.white),
                          onPressed: () {}),
                    ),
                  );
                }).toList()));
      },
    );
  }
}

class CustomTabView extends StatefulWidget {
  final int itemCount;
  final IndexedWidgetBuilder tabBuilder;
  final IndexedWidgetBuilder pageBuilder;
  final Widget stub;
  final ValueChanged<int> onPositionChange;
  final ValueChanged<double> onScroll;
  final int initPosition;

  CustomTabView({
    required this.itemCount,
    required this.tabBuilder,
    required this.pageBuilder,
    required this.stub,
    required this.onPositionChange,
    required this.onScroll,
    required this.initPosition,
  });

  @override
  _CustomTabsState createState() => _CustomTabsState();
}

class _CustomTabsState extends State<CustomTabView>
    with TickerProviderStateMixin {
  late TabController controller;
  late int _currentCount;
  late int _currentPosition;

  @override
  void initState() {
    _currentPosition = widget.initPosition;
    controller = TabController(
      length: widget.itemCount,
      vsync: this,
      initialIndex: _currentPosition,
    );
    controller.addListener(onPositionChange);
    controller.animation?.addListener(onScroll);
    _currentCount = widget.itemCount;
    super.initState();
  }

  @override
  void didUpdateWidget(CustomTabView oldWidget) {
    if (_currentCount != widget.itemCount) {
      controller.animation?.removeListener(onScroll);
      controller.removeListener(onPositionChange);
      controller.dispose();

      if (widget.initPosition != null) {
        _currentPosition = widget.initPosition;
      }

      if (_currentPosition > widget.itemCount - 1) {
        _currentPosition = widget.itemCount - 1;
        _currentPosition = _currentPosition < 0 ? 0 : _currentPosition;
        if (widget.onPositionChange is ValueChanged<int>) {
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            if (mounted) {
              widget.onPositionChange(_currentPosition);
            }
          });
        }
      }

      _currentCount = widget.itemCount;
      setState(() {
        controller = TabController(
          length: widget.itemCount,
          vsync: this,
          initialIndex: _currentPosition,
        );
        controller.addListener(onPositionChange);
        controller.animation?.addListener(onScroll);
      });
    } else if (widget.initPosition != null) {
      controller.animateTo(widget.initPosition);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.animation?.removeListener(onScroll);
    controller.removeListener(onPositionChange);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount < 1) return widget.stub;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          color: AppColors.backgroundColor,
          alignment: Alignment.center,
          child: TabBar(
            labelStyle: TextStyle(fontWeight: FontWeight.w900),
            isScrollable: true,
            controller: controller,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            indicator: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.white,
                  width: 2,
                ),
              ),
            ),
            tabs: List.generate(
              widget.itemCount,
              (index) => widget.tabBuilder(context, index),
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: controller,
            children: List.generate(
              widget.itemCount,
              (index) => widget.pageBuilder(context, index),
            ),
          ),
        ),
      ],
    );
  }

  onPositionChange() {
    if (!controller.indexIsChanging) {
      _currentPosition = controller.index;
      if (widget.onPositionChange is ValueChanged<int>) {
        widget.onPositionChange(_currentPosition);
      }
    }
  }

  onScroll() {
    if (widget.onScroll is ValueChanged<double>) {
      widget.onScroll(controller.animation!.value);
    }
  }
}
