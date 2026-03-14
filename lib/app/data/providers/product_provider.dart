import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductProvider {
  static const String baseUrl = 'https://akfoodapi.maktechlaravel.cloud';

  Future<Map<String, dynamic>> getProducts({int page = 1, int size = 20, String? categoryId}) async {
    String url = '$baseUrl/products/?page=$page&size=$size';
    //if (categoryId != null) url += '&category_id=$categoryId';
    final response = await http.get(Uri.parse(url));
    print("get products body: ${response.body}, statuscode: ${response.statusCode}");
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load products');
  }

  Future<Map<String, dynamic>> getProductById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/products/$id'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load product');
  }

  Future<List<dynamic>> getCategories() async {
    // categories/ with trailing slash because backend route is @router.get('/')
    final response = await http.get(Uri.parse('$baseUrl/categories/'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load categories');
  }

  Future<Map<String, dynamic>> getPartyMenus({int page = 1, int size = 10}) async {
    // party-menu without trailing slash because backend route is @router.get('')
    final response = await http.get(Uri.parse('$baseUrl/party-menu?page=$page&size=$size'));
    print("get partyMenus body: ${response.body}, statuscode: ${response.statusCode}");
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load party menus');
  }

  Future<Map<String, dynamic>> getPartyMenuById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/party-menu/$id'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load party menu');
  }
}
