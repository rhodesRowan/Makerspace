import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User getCurrentUser() {
    return _auth.currentUser;
  }

  Stream<User> get user {
    return _auth.authStateChanges();
  }

  Future<UserCredential> signInWithTwitter() async {
    try {
      final TwitterLogin twitterLogin = new TwitterLogin(
        consumerKey: 'kcDfrbCAmbS93OFJvrRaGWWZq',
        consumerSecret: 'gVZTjzErMK2GpP5DVus4VWOK3AcclhczYqQa5pVgmxPn9aKxHT',
      );

      // Trigger the sign-in flow
      final TwitterLoginResult loginResult = await twitterLogin.authorize();

      print(loginResult.session);
      // Get the Logged In session
      final TwitterSession twitterSession = loginResult.session;

      // Create a credential from the access token
      final twitterAuthCredential = TwitterAuthProvider.credential(
        accessToken: twitterSession.token,
        secret: twitterSession.secret,
      );

      // Once signed in, return the UserCredential
      var user = await FirebaseAuth.instance
          .signInWithCredential(twitterAuthCredential);
      user.user.updateProfile(displayName: twitterSession.username);
      return user;
    } catch (exception) {
      throw exception;
    }
  }

  void signOut() {
    try {
      _auth.signOut();
    } catch (exception) {
      throw exception;
    }
  }
}
