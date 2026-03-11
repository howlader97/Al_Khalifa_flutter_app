import 'dart:convert';
import 'package:http/http.dart' as http;

class DeliveryFeeProvider {
  static const String baseUrl = 'http://10.0.2.2:8001/delivery-fee';

  Future<double> getLatestDeliveryFee() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        // We assume the first one is the active one, or admin manages it.
        // Usually, there's only one active fee.
        return (data.first['fee'] as num).toDouble();
      }
      return 0.0;
    }
    throw Exception('Failed to load delivery fee');
  }
}
