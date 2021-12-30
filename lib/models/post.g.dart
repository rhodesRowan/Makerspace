// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(
        Map<String, dynamic> json, String id, MakerspaceUser user) =>
    Post(
        id,
        json['userID'] as String,
        (json['updatedAt'] as Timestamp).toDate(),
        (json["likes"] != null) ? json['likes'] as Map : Map(),
        ((json['done'] as List<dynamic>).map((e) => e as String))
            .toList(growable: true),
        user);

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'userID': instance.userID,
      'updatedAt': instance.updatedAt.toIso8601String(),
      'likes': instance.likes,
      'todos': instance.todos,
      'user': instance.user,
    };
