import 'package:makerspace/helpers/app_colours.dart';
import 'package:makerspace/providers/auth_provider.dart';
import 'package:makerspace/providers/firestore_provider.dart';
import 'package:makerspace/screens/leaderboard.dart';
import 'package:makerspace/screens/profile.dart';
import 'package:makerspace/screens/tasks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/src/provider.dart';
import 'main_feed.dart';

class Home extends StatefulWidget {
  @override
  State createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext build) {
    return PersistentTabView(context,
        backgroundColor: AppColors.backgroundColor,
        screens: _buildScreens(),
        items: _navBarItems(),
        navBarStyle: NavBarStyle.style12);
  }

  @override
  void initState() {
    super.initState();
  }

  List<Widget> _buildScreens() {
    return [
      MainFeed(),
      Tasks(),
      Leaderboard(),
      Profile(context.read<AuthProvider>().getCurrentUser()!.uid)
    ];
  }

  List<PersistentBottomNavBarItem> _navBarItems() {
    return [
      PersistentBottomNavBarItem(
          icon: Icon(Icons.home_filled), // Icon(CupertinoIcons.home),
          title: "Feed",
          activeColorPrimary: AppColors.orange,
          inactiveColorPrimary: Colors.white70),
      PersistentBottomNavBarItem(
          icon: Icon(Icons.book),
          inactiveIcon: Icon(Icons.book),
          title: "Tasks",
          activeColorPrimary: AppColors.orange,
          inactiveColorPrimary: Colors.white70),
      PersistentBottomNavBarItem(
          icon: Icon(Icons.whatshot_sharp),
          title: "Explore",
          activeColorPrimary: AppColors.orange,
          inactiveColorPrimary: Colors.white70),
      PersistentBottomNavBarItem(
          icon: Icon(Icons.person),
          title: "Profile",
          activeColorPrimary: AppColors.orange,
          inactiveColorPrimary: Colors.white70)
    ];
  }
}
