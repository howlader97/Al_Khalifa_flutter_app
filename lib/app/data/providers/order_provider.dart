import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../providers/auth_provider.dart';

class OrderProvider {
  static const String baseUrl = 'http://10.0.2.2:8001/orders';

  Future<Map<String, dynamic>> placeOrder(Map<String, dynamic> orderData, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(orderData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body)['detail'] ?? 'Failed to place order');
    }
  }

  Future<List<dynamic>> getMyOrders(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/my'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body)['detail'] ?? 'Failed to fetch orders');
    }
  }

  Future<void> submitReview(Map<String, dynamic> reviewData, String token) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8001/reviews/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(reviewData),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(jsonDecode(response.body)['detail'] ?? 'Failed to submit review');
    }
  }
}
