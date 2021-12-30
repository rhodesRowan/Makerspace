import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:makerspace/main.dart';
import 'package:makerspace/providers/auth_provider.dart';
import 'package:makerspace/providers/firestore_provider.dart';
import 'package:makerspace/screens/home.dart';
import 'package:makerspace/screens/landing.dart';
import 'package:makerspace/screens/login.dart';
import 'package:makerspace/screens/main_feed.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  WrapperState createState() => WrapperState();
}

class WrapperState extends State<Wrapper> {
  @override
  initState() async* {
    super.initState();
    // Get the token each time the application loads
    String? token = await FirebaseMessaging.instance.getToken();

    // Save the initial token to the database
    context.read<FirestoreProvider>().saveTokenToDatabase(token);

    // Any time the token refreshes, store this in the database too.
    FirebaseMessaging.instance.onTokenRefresh
        .listen(context.read<FirestoreProvider>().saveTokenToDatabase);
  }

  @override
  Widget build(BuildContext context) {
    final User? user = context.watch<User?>();
    return user == null ? Login() : Home();
  }
}
