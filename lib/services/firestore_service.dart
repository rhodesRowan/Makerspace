import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_practise/services/auth_service.dart';

class Firestore_Service {

  final CollectionReference _postsPath = FirebaseFirestore.instance.collection("posts");

  Future<void> addPost(String post) {
      return _postsPath.add({
        "post" : post,
        "createdAt" : DateTime.now().millisecondsSinceEpoch,
        "user" : AuthService().getCurrentUser().uid
      }).then((value) => print(value)).catchError((error) =>  throw error);
  }

  Stream getPostsStream() {
    return _postsPath.snapshots();
  }
}