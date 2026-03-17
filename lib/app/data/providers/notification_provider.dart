import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';
import '../models/notification_model.dart';

class NotificationProvider {
  static  String baseUrl = '$apiBaseUrl/notifications';

  Future<NotificationListResponse> getNotifications(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return NotificationListResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(jsonDecode(response.body)['detail'] ?? 'Failed to load notifications');
    }
  }

  Future<void> markAsRead(String token, int notificationId) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$notificationId/read'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['detail'] ?? 'Failed to mark as read');
    }
  }

  Future<void> markAllAsRead(String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/read-all'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['detail'] ?? 'Failed to mark all as read');
    }
  }

  Future<void> deleteNotification(String token, int notificationId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$notificationId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['detail'] ?? 'Failed to delete notification');
    }
  }
}
