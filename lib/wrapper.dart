import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practise/screens/authenticate.dart';
import 'package:firebase_practise/screens/home.dart';
import 'package:firebase_practise/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return user == null ? Authenticate() : Home();
  }
}
