import 'dart:convert';

class NotificationModel {
  final int id;
  final int userId;
  final String title;
  final String message;
  final String type; // ORDER, PROFILE, ACCOUNT
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      message: json['message'],
      type: json['type'],
      isRead: json['is_read'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'message': message,
      'type': type,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class NotificationListResponse {
  final List<NotificationModel> notifications;
  final int unreadCount;

  NotificationListResponse({
    required this.notifications,
    required this.unreadCount,
  });

  factory NotificationListResponse.fromJson(Map<String, dynamic> json) {
    return NotificationListResponse(
      notifications: (json['notifications'] as List)
          .map((i) => NotificationModel.fromJson(i))
          .toList(),
      unreadCount: json['unread_count'],
    );
  }
}
