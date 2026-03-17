import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/constants.dart';

class SliderProvider {
  static  String baseUrl = apiBaseUrl;

  Future<List<dynamic>> getActiveSliders() async {
    final response = await http.get(Uri.parse('$baseUrl/sliders/?active_only=true'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load sliders');
  }
}
