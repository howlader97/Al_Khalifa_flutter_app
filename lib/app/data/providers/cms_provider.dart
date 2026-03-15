import 'dart:convert';
import 'package:http/http.dart' as http;

class CmsProvider {
  static const String baseUrl = 'https://akfoodapi.maktechlaravel.cloud/cms';

  Future<Map<String, dynamic>> getPage(String slug) async {
    final response = await http.get(Uri.parse('$baseUrl/$slug'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load $slug');
    }
  }
}
