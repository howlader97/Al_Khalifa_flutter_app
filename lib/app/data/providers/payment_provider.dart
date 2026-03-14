import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentProvider {
  final String baseUrl = 'https://akfoodapi.maktechlaravel.cloud';

  Future<String?> initiatePayment(int orderId, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/payments/initiate'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'order_id': orderId,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['url'];
    } else {
      throw Exception('Failed to initiate payment: ${response.body}');
    }
  }
}
