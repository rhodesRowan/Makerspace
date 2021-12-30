import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:makerspace/providers/firestore_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/src/provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:twitter_login/twitter_login.dart';
import 'package:crypto/crypto.dart';

class AuthProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? getCurrentUser() => _auth.currentUser;

  Stream<User?> get user => _auth.authStateChanges();

  Future<bool> sendResetPasswordEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (exception) {
      throw exception;
    }
  }

  Future<bool> updateDisplayName(
      {required BuildContext context, required String name}) async {
    try {
      await _auth.currentUser?.updateDisplayName(name);
      await context.read<FirestoreProvider>().saveDisplayName(name);
      return true;
    } catch (exception) {
      throw exception;
    }
  }

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      var credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      String? token = await FirebaseMessaging.instance.getToken();
      context.read<FirestoreProvider>().saveTokenToDatabase(token);
      return credential;
    } catch (exception) {
      throw exception;
    }
  }

  Future<UserCredential?> signUpWithEmailAndPassword(
      {required String email,
      required String password,
      required String name,
      required XFile? image,
      required String bio,
      required BuildContext context}) async {
    try {
      final UserCredential credential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      credential.user?.updateDisplayName(name);
      String? photoUrl;
      if (image != null) {
        photoUrl = await uploadImageToFirebase(image);
      }
      await context.read<FirestoreProvider>().saveUserOnRegister(name, email, bio, photoUrl, null, null, null);
      String? token = await FirebaseMessaging.instance.getToken();
      await context.read<FirestoreProvider>().saveTokenToDatabase(token);
    } catch (exception) {
      throw exception;
    }
  }

  Future<UserCredential?> signInWithTwitter(BuildContext context) async {
    try {
      final TwitterLogin twitterLogin = new TwitterLogin(
          apiKey: 'kcDfrbCAmbS93OFJvrRaGWWZq',
          apiSecretKey: 'gVZTjzErMK2GpP5DVus4VWOK3AcclhczYqQa5pVgmxPn9aKxHT',
          redirectURI: "twitter://");

      final authResult = await twitterLogin.login();

      switch (authResult.status) {
        case TwitterLoginStatus.loggedIn:
          final twitterAuthCredential = TwitterAuthProvider.credential(
            accessToken: authResult.authToken!,
            secret: authResult.authTokenSecret!,
          );

          var image = authResult.user!.thumbnailImage;

          if (authResult.user!.thumbnailImage.contains("_normal")) {
            image = authResult.user!.thumbnailImage.replaceAll("_normal", "");
          }

          final user = await FirebaseAuth.instance
              .signInWithCredential(twitterAuthCredential);
          user.user?.updateDisplayName(authResult.user!.name);
          user.user?.updateEmail(authResult.user!.email);
          user.user?.updatePhotoURL(image);
          await context.read<FirestoreProvider>().saveUserOnRegister(authResult.user!.name, authResult.user!.email, null, image, null, null, null);
          String? token = await FirebaseMessaging.instance.getToken();
          await context.read<FirestoreProvider>().saveTokenToDatabase(token);
          await context
              .read<FirestoreProvider>()
              .saveDisplayName(authResult.user!.name);
          await context
              .read<FirestoreProvider>()
              .saveTwitterHandle("@${authResult.user!.screenName}");

          return user;
        case TwitterLoginStatus.error:
          throw Exception("There was an issue authorizing");
        case TwitterLoginStatus.cancelledByUser:
          throw Exception("User cancelled");
        default:
          throw Exception("Unknown Exception");
      }
    } catch (exception) {
      throw exception;
    }
  }

  Future<UserCredential> signInWithApple(BuildContext context) async {
    try {
      // To prevent replay attacks with the credential returned from Apple, we
      // include a nonce in the credential request. When signing in with
      // Firebase, the nonce in the id token returned by Apple, is expected to
      // match the sha256 hash of `rawNonce`.
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      final user = userCredential.user;

      if (appleCredential.familyName != null &&
          appleCredential.givenName != null) {
        user?.updateDisplayName(
            '${appleCredential.givenName!} ${appleCredential.familyName!}');
      }

      if (appleCredential.email != null) {
        user?.updateEmail(appleCredential.email!);
      }

      await context.read<FirestoreProvider>().saveUserOnRegister('${appleCredential.givenName} ${appleCredential.familyName}', appleCredential.email!, null, null, null, null, null);
      String? token = await FirebaseMessaging.instance.getToken();
      await context.read<FirestoreProvider>().saveTokenToDatabase(token);
      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      return userCredential;
    } catch (exception) {
      throw exception;
    }
  }

  void signOut(BuildContext context) {
    try {
      context.read<FirestoreProvider>().removeToken();
      _auth.signOut();
    } catch (exception) {
      throw exception;
    }
  }

  Future<String?> uploadImageToFirebase(XFile image) async {
    try {
      String imageFile = image.name;
      var firebaseStorageRef = FirebaseStorage.instance.ref().child('uploads/${_auth.currentUser!.uid}/$imageFile');
      var uploadTask = await firebaseStorageRef.putFile(File(image.path));
      return uploadTask.ref.getDownloadURL();
    } catch (exception) {
    }
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
