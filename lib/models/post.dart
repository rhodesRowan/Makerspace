import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:makerspace/models/makerspace_user.dart';
import 'package:makerspace/models/task.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class Post {
  String id;
  String userID;
  DateTime updatedAt;
  Map likes;
  List<String> todos;
  MakerspaceUser user;
  //List<Comment> comments;

  Post(
      this.id, this.userID, this.updatedAt, this.likes, this.todos, this.user) {
    this.todos = this.todos.reversed.toList();
  }

  factory Post.fromJson(
      Map<String, dynamic> json, String id, MakerspaceUser user) {
    return _$PostFromJson(json, id, user);
  }

  Map<String, dynamic> toJson() {
    return _$PostToJson(this);
  }
}
