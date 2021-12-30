import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:makerspace/status.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

@JsonSerializable()
class Task {
  DateTime createdAt;
  bool isDone;
  String text;
  String id;

  Task(this.id, this.text, this.createdAt, this.isDone);

  factory Task.fromJson(Map<String, dynamic> json, key) {
    return _$TaskFromJson(json, key);
  }

  Map<String, dynamic> toJson() {
    return _$TaskToJson(this);
  }
}
