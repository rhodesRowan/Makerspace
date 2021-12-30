import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:makerspace/helpers/report_type.dart';
import 'package:makerspace/models/post.dart';
import 'package:makerspace/models/makerspace_user.dart';
import 'package:makerspace/models/task.dart';
import 'package:makerspace/models/makerspace_notification.dart';
import 'package:makerspace/providers/auth_provider.dart';
import 'package:makerspace/providers/local_storage_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:makerspace/models/streak.dart';
import 'package:localstorage/localstorage.dart';

class FirestoreProvider {
  FirestoreProvider(
      {required AuthProvider auth, required LocalStorageProvider storage})
      : _auth = auth,
        _storageProvider = storage;

  AuthProvider _auth;
  LocalStorageProvider _storageProvider;

  final CollectionReference _todoPath = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("todos");
  final CollectionReference _postsPath =
      FirebaseFirestore.instance.collection("posts");
  final CollectionReference _usersPath =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference _streaksPath =
      FirebaseFirestore.instance.collection("streaks");
  final CollectionReference _notificationsPath =
      FirebaseFirestore.instance.collection("notifications");
  final CollectionReference _userNotificationsPath = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("notifications");
  final CollectionReference _reportedContentPath = FirebaseFirestore.instance.collection("reported");

  Future<void> saveTokenToDatabase(String? token) async {
    // Assume user is logged in for this example
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      await _usersPath.doc(userId).set({
        'tokens': FieldValue.arrayUnion([token]),
      }, SetOptions(merge: true));
    }
  }

  Future<void> removeToken() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    String? token = await FirebaseMessaging.instance.getToken();

    if (userId != null && token != null) {
      return FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot =
            await transaction.get(_usersPath.doc(userId));

        if (!snapshot.exists) {
          throw Exception("user doesnt exist");
        }

        var data = snapshot.data() as Map<String, dynamic>;
        var tokensData = data["tokens"] as List;
        var tokens = tokensData.map((e) => e.toString()).toList();

        if (tokens.contains(token)) {
          transaction.update(_usersPath.doc(userId), {
            "tokens": FieldValue.arrayRemove(["token"])
          });
        }
      });
    }
  }

  Future<void> saveUserOnRegister(String displayName, String email, String? bio, String? photo, String? indieHackers, String? website, String? twitter) async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      var userMap = {
        "displayName" : displayName,
        "email" : email,
      };

      if (bio != null) {
        userMap["bio"] = bio;
      }

      if (photo != null) {
        userMap["photoUrl"] = photo;
      }

      if (indieHackers != null) {
        userMap["indieHackersHandle"] = indieHackers;
      }

      if (twitter != null) {
        userMap["twitterHandle"] = twitter;
      }

      await _usersPath.doc(userId).set(userMap, SetOptions(merge: true));
      await getCurrentUser();
    } catch (exception) {
      throw exception;
    }
  }

  Future<void> saveDisplayName(String displayName) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    await _usersPath.doc(userId).set({
      "displayName": displayName,
    }, SetOptions(merge: true));

    Map<String, dynamic> currentUserInfo =
        json.decode(_storageProvider.getItem('current_user'));
    MakerspaceUser currentUser = MakerspaceUser.fromJson(currentUserInfo);
    currentUser.displayName = displayName;
    _storageProvider.setCurrentUser(currentUser);
  }

  Future<bool> saveBio(String bio) async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      await _usersPath.doc(userId).set({"bio": bio}, SetOptions(merge: true));

      Map<String, dynamic> currentUserInfo =
          json.decode(_storageProvider.getItem('current_user'));
      MakerspaceUser currentUser = MakerspaceUser.fromJson(currentUserInfo);
      currentUser.bio = bio;
      _storageProvider.setCurrentUser(currentUser);
      print("Returning");
      return true;
    } catch (exception) {
      print("ERROR ${exception}");
      throw exception;
    }
  }

  Future<bool> saveTwitterHandle(String twitterHandle) async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      await _usersPath
          .doc(userId)
          .set({"twitterHandle": twitterHandle}, SetOptions(merge: true));

      Map<String, dynamic> currentUserInfo =
          json.decode(_storageProvider.getItem('current_user'));
      MakerspaceUser currentUser = MakerspaceUser.fromJson(currentUserInfo);
      currentUser.twitterHandle = twitterHandle;
      _storageProvider.setCurrentUser(currentUser);

      return true;
    } catch (exception) {
      throw exception;
    }
  }

  Future<bool> saveIndieHackersHandle(String indieHackersHandle) async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      await _usersPath.doc(userId).set(
          {"indieHackersHandle": indieHackersHandle}, SetOptions(merge: true));

      Map<String, dynamic> currentUserInfo =
          json.decode(_storageProvider.getItem('current_user'));
      MakerspaceUser currentUser = MakerspaceUser.fromJson(currentUserInfo);
      currentUser.indieHackersHandle = indieHackersHandle;
      _storageProvider.setCurrentUser(currentUser);

      return true;
    } catch (exception) {
      throw exception;
    }
  }

  Future<bool> saveURL(String url) async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      await _usersPath.doc(userId).set({"url": url}, SetOptions(merge: true));

      Map<String, dynamic> currentUserInfo =
          json.decode(_storageProvider.getItem('current_user'));
      MakerspaceUser currentUser = MakerspaceUser.fromJson(currentUserInfo);
      currentUser.website = url;
      _storageProvider.setCurrentUser(currentUser);

      return true;
    } catch (exception) {
      throw exception;
    }
  }

  Future<MakerspaceUser> getCurrentUser() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    var user = await _usersPath.doc(userId).get();

    var streak = await _streaksPath.doc(userId).get();

    var count = (streak.exists)
        ? (streak.data() as Map<String, dynamic>)["count"] as int
        : 0;

    Streak usersStreak = Streak(count);

    var makerspaceUser = MakerspaceUser(
        user.id, user.data() as Map<String, dynamic>, usersStreak);

    _storageProvider.setCurrentUser(makerspaceUser);

    return makerspaceUser;
  }

  Future<MakerspaceUser> getUser(String id) async {
    String? currentUserId = _auth.getCurrentUser()?.uid;
    if (currentUserId == id) {
      return await getCurrentUser();
    }

    var user = await _usersPath.doc(id).get();

    var streak = await _streaksPath.doc(id).get();

    var count = (streak.exists)
        ? (streak.data() as Map<String, dynamic>)["count"] as int
        : 0;

    Streak usersStreak = Streak(count);

    return MakerspaceUser(
        user.id, user.data() as Map<String, dynamic>, usersStreak);
  }

  Future<void> reportPost(String postID, reportType type, String description) async {
    try {
      return await _reportedContentPath.doc().set({
        "post" : postID,
        "type" : type,
        "description" : description
      });
    } catch (exception) {
      throw exception;
    }
  }

  Future<void> addToDo(String post, bool isDone) {
    try {
      var currentUserId = _auth.getCurrentUser()!.uid;
      return _todoPath
          .add({
            "text": post,
            "createdAt": DateTime.now(),
            "userId": currentUserId,
            "isDone": isDone
          })
          .then((value) => print(value))
          .catchError((error) => throw error);
    } catch (exception) {
      throw exception;
    }
  }

  Future<void> updateToDoText(String updatedText, String toDoID) {
    try {
      return _todoPath.doc(toDoID).update({
        "text": updatedText,
        "createdAt": DateTime.now(),
      }).catchError((error) => throw error);
    } catch (exception) {
      throw exception;
    }
  }

  Future<void> markAsRead(Post post) async {
    return _notificationsPath.doc(post.id).update({"isRead": true});
  }

  Future<void> markToDoAsDone(Task toDo) async {
    DocumentReference toDoPath = _todoPath.doc(toDo.id);

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      var userStreaksPath = _streaksPath.doc(_auth.getCurrentUser()!.uid);
      DocumentSnapshot snapshot = await transaction.get(userStreaksPath);

      transaction.update(toDoPath, {"isDone": true});
      var now = DateTime.now();
      var startOfDayTimestamp = (DateTime(
                  DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .millisecondsSinceEpoch)
          .round();
      var startOfDay = (DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day));
      int steakEndTimestamp = startOfDayTimestamp + (86400000 * 2);
      var streakEndDate =
          DateTime.fromMillisecondsSinceEpoch(steakEndTimestamp);
      var userID = _auth.getCurrentUser()!.uid;
      var postID = startOfDayTimestamp.toString() + userID;
      List<String> doneList = [toDo.text];
      DocumentReference postsPath = _postsPath.doc(postID);
      transaction.set(
          postsPath,
          {
            "userID": userID,
            "startOfDay": startOfDay,
            "updatedAt": now,
            "done": FieldValue.arrayUnion(doneList)
          },
          SetOptions(merge: true));

      var usersPostPath = _usersPath
          .doc(_auth.getCurrentUser()!.uid)
          .collection("posts")
          .doc(postID);
      transaction.set(
          usersPostPath,
          {
            "userID": userID,
            "startOfDay": startOfDay,
            "updatedAt": now,
            "done": FieldValue.arrayUnion(doneList)
          },
          SetOptions(merge: true));

      if (!snapshot.exists) {
        transaction.set(userStreaksPath,
            {"count": 1, "streakEnds": streakEndDate, "userID": userID});
        return;
      }

      var data = snapshot.data() as Map<String, dynamic>;

      if (data.containsKey("streakEnds")) {
        var currentStreakEndsDate = (data["streakEnds"] as Timestamp).toDate();
        var count = data["count"] as int;
        if (count == 0) {
          transaction.set(userStreaksPath,
              {"count": 1, "streakEnds": streakEndDate, "userID": userID});
        } else if (DateTime.now().millisecondsSinceEpoch >
            currentStreakEndsDate.millisecondsSinceEpoch) {
          transaction.set(userStreaksPath,
              {"count": 1, "streakEnds": streakEndDate, "userID": userID});
        } else if (startOfDay.millisecondsSinceEpoch ==
            currentStreakEndsDate
                .subtract(Duration(hours: 24))
                .millisecondsSinceEpoch) {
          transaction.set(userStreaksPath, {
            "count": data["count"] + 1,
            "streakEnds": streakEndDate,
            "userID": userID
          });
        } else {
          transaction.set(userStreaksPath, {
            "count": data["count"],
            "streakEnds": streakEndDate,
            "userID": userID
          });
        }
      } else {
        transaction.set(userStreaksPath,
            {"count": 1, "streakEnds": streakEndDate, "userID": userID});
      }
    });
  }

  Future<void> removeToDo(String toDo) {
    return _todoPath.doc(toDo).delete();
  }

  Stream<QuerySnapshot> getTodosStream() {
    return _todoPath
        .where("isDone", isEqualTo: false)
        .orderBy("createdAt")
        .snapshots();
  }

  Future<MakerspaceUser> _getUser(String userID) async {
    var userDoc = await _usersPath.doc(userID).get();
    var userMap = userDoc.data() as Map<String, dynamic>;
    var streak = await GetStreakForUser(userID);
    return MakerspaceUser(userDoc.id, userMap, streak);
  }

  Future<List<Post>> _getPostsWithUser(QuerySnapshot snapshot) {
    return Future.wait(snapshot.docs.map((DocumentSnapshot postDoc) async {
      return await getPostWithUser(postDoc);
    }));
  }

  Future<List<MakerspaceUser>> _getStreaksWithUser(QuerySnapshot snapshot) {
    return Future.wait(snapshot.docs.map((DocumentSnapshot postDoc) async {
      return await _getStreakWithUser(postDoc);
    }));
  }

  Future<void> toggleLike(bool like, String postID, String postsUserID) {
    var batch = FirebaseFirestore.instance.batch();
    var postPath = _postsPath.doc(postID);
    var currentUser = _auth.getCurrentUser()!.uid;
    var usersPosthPath =
        _usersPath.doc(postsUserID).collection("posts").doc(postID);
    var usersNotificationsPath =
        _usersPath.doc(postsUserID).collection("notifications").doc(postID);

    if (like) {
      batch.update(postPath, {"likes.${_auth.getCurrentUser()!.uid}": true});
      batch.update(
          usersPosthPath, {"likes.${_auth.getCurrentUser()!.uid}": true});

      if (postsUserID != currentUser) {
        batch.set(_notificationsPath.doc(postID), {
          "text": "liked your update",
          "userID": "${_auth.getCurrentUser()!.uid}",
          "isRead": false,
        });

        batch.set(usersNotificationsPath, {"timestamp": (DateTime.now())});
      }
    } else {
      batch.update(postPath, {"likes.${_auth.getCurrentUser()!.uid}": false});
      batch.update(
          usersPosthPath, {"likes.${_auth.getCurrentUser()!.uid}": false});
    }

    return batch.commit();
  }

  Future<Streak> GetStreakForUser(String userID) {
    return _streaksPath
        .doc(userID)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var documentData = documentSnapshot.data() as Map<String, dynamic>;
        var count = documentData["count"] as int;
        return Streak(count);
      } else {
        return Streak(0);
      }
    });
  }

  Future<Post> getPostWithUser(DocumentSnapshot post) {
    String userID = (post.data() as Map<String, dynamic>)["userID"] as String;
    return _usersPath
        .doc(userID)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        var postJson = post.data() as Map<String, dynamic>;
        var userJson = documentSnapshot.data() as Map<String, dynamic>;
        var streak = await GetStreakForUser(documentSnapshot.id);
        var user = MakerspaceUser(documentSnapshot.id, userJson, streak);
        return Post.fromJson(postJson, post.id, user);
      } else {
        throw Exception("Unknown error");
      }
    });
  }

  Future<MakerspaceUser> _getStreakWithUser(DocumentSnapshot streakDocument) {
    String userID =
        (streakDocument.data() as Map<String, dynamic>)["userID"] as String;

    return _usersPath
        .doc(userID)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var streakJson = streakDocument.data() as Map<String, dynamic>;
        var count = streakJson["count"] as int;
        var userJson = documentSnapshot.data() as Map<String, dynamic>;
        var streak = Streak(count);
        var user = MakerspaceUser(documentSnapshot.id, userJson, streak);
        return user;
      } else {
        throw Exception("Unknown error");
      }
    });
  }

  Stream<List<Post>> getPostsStream() {
    return _postsPath
        .orderBy("updatedAt", descending: true)
        .snapshots()
        .asyncMap((QuerySnapshot doneStream) => _getPostsWithUser(doneStream));
  }

  Stream<List<Post>> getPostsStreamForCurrentUser() {
    var currentUserId = _auth.getCurrentUser()!.uid;
    return _usersPath
        .doc(currentUserId)
        .collection("posts")
        .orderBy("updatedAt", descending: true)
        .snapshots()
        .asyncMap((QuerySnapshot usersDoneStream) =>
            _getPostsWithUser(usersDoneStream));
  }

  Future<List<MakerspaceNotification>> _getNotificationsFromSnapshot(
      QuerySnapshot snapshot) {
    return Future.wait(snapshot.docs.map((DocumentSnapshot notificationDoc) {
      return _getNotification(notificationDoc);
    }));
  }

  Future<Post> _getPost(String postID, MakerspaceUser user) async {
    var post = await _postsPath.doc(postID).get();
    var postData = post.data() as Map<String, dynamic>;
    return Post.fromJson(postData, post.id, user);
  }

  Future<MakerspaceNotification> _getNotification(
      DocumentSnapshot notification) async {
    var notificationMap = await _notificationsPath.doc(notification.id).get();
    var notificationData = notificationMap.data() as Map<String, dynamic>;
    var user = await _getUser(notificationData["userID"]);
    var post = await _getPost(notification.id, user);
    return MakerspaceNotification(
        notification.id,
        notificationData["text"] as String,
        notificationData["isRead"] as bool,
        user,
        post);
  }

  Stream<List<MakerspaceUser>> getStreaksStream() {
    return _streaksPath.orderBy("count", descending: true).snapshots().asyncMap(
        (QuerySnapshot streaksStream) => _getStreaksWithUser(streaksStream));
  }

  Stream<List<MakerspaceNotification>> getNotificationsStream() {
    return _userNotificationsPath.orderBy("timestamp").limitToLast(100).snapshots().asyncMap(
        (QuerySnapshot notifications) =>
            _getNotificationsFromSnapshot(notifications));
  }
}
