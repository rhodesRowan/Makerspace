import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_practise/screens/leaderboard.dart';
import 'package:firebase_practise/screens/members.dart';
import 'package:firebase_practise/screens/profile.dart';
import 'package:firebase_practise/screens/timer_page.dart';
import 'package:firebase_practise/services/auth_service.dart';
import 'package:firebase_practise/services/firestore_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import 'main_feed.dart';

class Home extends StatefulWidget {

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {

  PersistentTabController _tabController = PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [
      MainFeed(),
      Leaderboard(),
      Members(),
      Profile()
    ];
  }

  List<PersistentBottomNavBarItem> _navBarItems() {
    return [
      PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.flame, color: Colors.orange),
          activeColorPrimary: Colors.orange
      ),
      PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.chart_bar_circle, color: Colors.redAccent),
          activeColorPrimary: Colors.redAccent
      ),
      PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.bell, color: Colors.redAccent),
          activeColorPrimary: Colors.redAccent
      ),
      PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.profile_circled, color: Colors.redAccent),
          activeColorPrimary: Colors.redAccent
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
        context,
        controller: _tabController,
        screens: _buildScreens(),
        items: _navBarItems(),
        navBarStyle: NavBarStyle.style2,
    );
  }
}
