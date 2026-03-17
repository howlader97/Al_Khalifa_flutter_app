import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/constants.dart';

class CmsProvider {
  static  String baseUrl = '$apiBaseUrl/cms';

  Future<Map<String, dynamic>> getPage(String slug) async {
    final response = await http.get(Uri.parse('$baseUrl/$slug'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load $slug');
    }
  }
}
