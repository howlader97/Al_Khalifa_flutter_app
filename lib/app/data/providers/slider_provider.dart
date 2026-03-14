import 'dart:convert';
import 'package:http/http.dart' as http;

class SliderProvider {
  static const String baseUrl = 'https://akfoodapi.maktechlaravel.cloud';

  Future<List<dynamic>> getActiveSliders() async {
    final response = await http.get(Uri.parse('$baseUrl/sliders/?active_only=true'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load sliders');
  }
}
