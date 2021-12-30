import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:makerspace/providers/auth_provider.dart';
import 'package:makerspace/providers/firestore_provider.dart';
import 'package:makerspace/providers/local_storage_provider.dart';
import 'package:makerspace/screens/landing.dart';
import 'package:makerspace/wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;

import 'helpers/app_colours.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());

  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: AppColors.backgroundColor));
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<LocalStorageProvider>(
            create: (context) => LocalStorageProvider(),
          ),
          Provider<AuthProvider>(
            create: (_) => AuthProvider(),
          ),
          Provider<FirestoreProvider>(create: (context) {
            return FirestoreProvider(
                auth: context.read<AuthProvider>(),
                storage:
                    Provider.of<LocalStorageProvider>(context, listen: false));
          }),
          StreamProvider(
              initialData: null,
              create: (context) => context.read<AuthProvider>().user)
        ],
        child: MaterialApp(
          theme: ThemeData(
            toggleableActiveColor: Colors.white,
            checkboxTheme: Theme.of(context).checkboxTheme.copyWith(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                side: BorderSide(width: 1.5, color: Colors.green),
                splashRadius: 0),
          ),
          builder: EasyLoading.init(),
          home: Wrapper(),
        ));
  }
}
