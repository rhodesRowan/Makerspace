// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json, String id) => Task(
      id,
      json['text'] as String,
      (json['createdAt'] as Timestamp).toDate(),
      json['isDone'] as bool,
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'createdAt': instance.createdAt.toIso8601String(),
      'isDone': instance.isDone,
      'text': instance.text,
      'id': instance.id,
    };
