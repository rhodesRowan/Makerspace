import 'package:firebase_auth/firebase_auth.dart';
import 'package:makerspace/helpers/app_colours.dart';
import 'package:makerspace/models/post.dart';
import 'package:makerspace/providers/auth_provider.dart';
import 'package:makerspace/providers/firestore_provider.dart';
import 'package:makerspace/providers/local_storage_provider.dart';
import 'package:makerspace/screens/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:makerspace/widgets/feed_tile.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:makerspace/models/makerspace_user.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  final String userID;

  Profile(this.userID);

  @override
  State<StatefulWidget> createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  late Future<MakerspaceUser> user;

  @override
  void initState() {
    user = context.read<FirestoreProvider>().getUser(widget.userID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final FirestoreProvider _firestore = context.read<FirestoreProvider>();
    final User _currentUser = context.read<AuthProvider>().getCurrentUser()!;
    List<String> data = ['DONE', "PROFILE"];
    int initPosition = 0;

    return FutureBuilder(
      future: user,
      builder: (BuildContext context, AsyncSnapshot<MakerspaceUser> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          EasyLoading.show(status: "loading..."); // your widget while loading
          return Container(color: AppColors.backgroundColor);
        }

        if (!snapshot.hasData) {
          EasyLoading.dismiss();
          return Container(
              color:
                  AppColors.backgroundColor); //your widget when error happens
        } else {
          print("ROWAN " + snapshot.data!.toJson().toString());
          EasyLoading.dismiss();
        }

        return (snapshot.data!.id == _currentUser.uid) ?
          Consumer<LocalStorageProvider>(
            builder: (context, localStorage, child) => buildProfileScaffold(localStorage.user!, true, context, initPosition, data, _firestore)) :
          buildProfileScaffold(snapshot.data!, false, context, initPosition, data, _firestore);
      },
    );
  }

  Scaffold buildProfileScaffold(MakerspaceUser user, bool isCurrentUser, BuildContext context, int initPosition, List<String> data, FirestoreProvider _firestore) {
    return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: Text(
                      user.displayName.toUpperCase(),
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  backgroundColor: AppColors.backgroundColor,
                  elevation: 0.0,
                  actions: (isCurrentUser)
                      ? [
                          IconButton(
                              onPressed: () {
                                pushNewScreen(context,
                                    screen: AccountSettings(),
                                    withNavBar: false,
                                    pageTransitionAnimation:
                                        PageTransitionAnimation.slideUp);
                              },
                              icon: Icon(Icons.settings))
                        ]
                      : [],
                ),
                body: SafeArea(
                  child: CustomTabView(
                    stub: Text(""),
                    initPosition: initPosition,
                    itemCount: data.length,
                    tabBuilder: (context, index) => Tab(text: data[index]),
                    pageBuilder: (context, index) {
                      if (index == 0) {
                        return doneposts(firestore: _firestore);
                      } else {
                        return SocialList();
                      }
                    },
                    onPositionChange: (index) {
                      print('current position: $index');
                      initPosition = index;
                    },
                    onScroll: (position) => print('$position'),
                  ),
                ),
              );
  }
}

class SocialList extends StatelessWidget {
  const SocialList({
    Key? key,
  })  : super(key: key);

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalStorageProvider>(
        builder: (context, localstorage, child) => Container(
            color: AppColors.backgroundColor,
            child: Container(
                padding: EdgeInsets.all(16),
                child: ListView(
                  children: [
                    Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        color: AppColors.tileBackgroundColor,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          child: ListTile(
                            onTap: () {},
                            title: Text("Bio",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white)),
                            subtitle: Text(localstorage.user?.bio ?? "-",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                    fontSize: 14)),
                          ),
                        )),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      color: AppColors.tileBackgroundColor,
                      child: ListTile(
                        onTap: () {
                          if (localstorage.user?.website != null) {
                            _launchURL(localstorage.user!.website!);
                          }
                        },
                        title: Text("Website",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white)),
                        subtitle: Text(
                            localstorage.user?.website ?? "-",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                                fontSize: 14)),
                        trailing: localstorage.user?.website != null
                            ? Icon(Icons.chevron_right,
                                color: Colors.white, size: 30)
                            : null,
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      color: AppColors.tileBackgroundColor,
                      child: ListTile(
                        onTap: () async {
                          if (localstorage.user?.indieHackersHandle != null) {
                            var indieHackersHandle = localstorage.user?.indieHackersHandle?.replaceAll("@", "");
                            _launchURL("https://www.indiehackers.com/$indieHackersHandle");
                          }
                        },
                        subtitle: Text(
                            localstorage.user?.indieHackersHandle ?? "-",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                                fontSize: 14)),
                        title: Text("Indie Hackers",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white)),
                        trailing: localstorage.user?.indieHackersHandle != null
                            ? Icon(Icons.chevron_right,
                                color: Colors.white, size: 30)
                            : null,
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      color: AppColors.tileBackgroundColor,
                      child: ListTile(
                        onTap: () {
                          if (localstorage.user?.twitterHandle != null) {
                            var twitterHandle = localstorage.user?.twitterHandle?.replaceAll("@", "");
                            _launchURL("https://twitter.com/$twitterHandle");
                          }
                        },
                        subtitle: Text(
                            localstorage.user?.twitterHandle ?? "-",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                                fontSize: 14)),
                        title: Text("Twitter",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white)),
                        trailing: localstorage.user?.twitterHandle != null
                            ? Icon(Icons.chevron_right,
                                color: Colors.white, size: 30)
                            : null,
                      ),
                    )
                  ],
                ))));
  }
}

class doneposts extends StatefulWidget {
  const doneposts({
    Key? key,
    required FirestoreProvider firestore,
  })  : _firestore = firestore,
        super(key: key);

  final FirestoreProvider _firestore;

  @override
  State<StatefulWidget> createState() => doneState();
}

class doneState extends State<doneposts> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppColors.backgroundColor,
        child: SizedBox.expand(
            child: StreamBuilder(
          stream: widget._firestore.getPostsStreamForCurrentUser(),
          builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading...");
            }

            return ListView(
                shrinkWrap: true,
                children: snapshot.data!.map((Post post) {
                  return FeedTile(
                      post: post,
                      currentUserID:
                          context.read<AuthProvider>().getCurrentUser()!.uid,
                      provider: context.read<FirestoreProvider>());
                }).toList());
          },
        )));
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
    User _user = context.read<AuthProvider>().getCurrentUser()!;
    if (widget.itemCount < 1) return widget.stub;

    return Consumer<LocalStorageProvider>(
        builder: (context, localstorage, child) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  color: AppColors.backgroundColor,
                  child: Row(
                    children: [
                      SizedBox(width: 20),
                      CircleAvatar(
                        foregroundImage: NetworkImage(localstorage.user?.photoUrl != null ? localstorage.user!.photoUrl! : ""),
                        backgroundImage: AssetImage("assets/user.png"),
                        maxRadius: 50,
                      ),
                      SizedBox(height: 5),
                      IntrinsicHeight(
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Daily \n Streak",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.grey)),
                                  SizedBox(height: 5),
                                  Text(
                                      localstorage.user?.streak?.count
                                              .toString() ??
                                          0.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.white)),
                                ],
                              ),
                              SizedBox(width: 20),
                              Column(
                                children: [
                                  Text("Tasks \n Done",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.grey)),
                                  SizedBox(height: 5),
                                  Text("23",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.white))
                                ],
                              ),
                              SizedBox(height: 20)
                            ]),
                      )
                    ],
                  ),
                ),
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
            ));
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
