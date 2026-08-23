import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';

class DeliveryFeeProvider {
  static  String baseUrl = '$apiBaseUrl/delivery-fee/';

  Future<double> getLatestDeliveryFee() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        return (data.first['fee'] as num).toDouble();
      }
      return 0.0;
    }
    throw Exception('Failed to load delivery fee');
  }
}
