import 'package:flutter/material.dart';

class Todo {
  final String id;
  final String userId;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final Color color;
  final bool isCompleted;
  final bool sharedWithFriend;
  final String? friendId;

  Todo({
    required this.id,
    required this.userId,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.color,
    required this.isCompleted,
    required this.sharedWithFriend,
    this.friendId,
  });

  Todo copyWith({
    String? id,
    String? userId,
    String? title,
    DateTime? startDate,
    DateTime? endDate,
    Color? color,
    bool? isCompleted,
    bool? sharedWithFriend,
    String? friendId,
  }) {
    return Todo(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      color: color ?? this.color,
      isCompleted: isCompleted ?? this.isCompleted,
      sharedWithFriend: sharedWithFriend ?? this.sharedWithFriend,
      friendId: friendId ?? this.friendId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'color': color.value,
      'is_completed': isCompleted ? 1 : 0,
      'shared_with_friend': sharedWithFriend ? 1 : 0,
      'friend_id': friendId,
    };
  }

  static Todo fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      userId: map['user_id'],
      title: map['title'],
      startDate: DateTime.parse(map['start_date']),
      endDate: DateTime.parse(map['end_date']),
      color: Color(map['color']),
      isCompleted: map['is_completed'] == 1,
      sharedWithFriend: map['shared_with_friend'] == 1,
      friendId: map['friend_id'],
    );
  }
}