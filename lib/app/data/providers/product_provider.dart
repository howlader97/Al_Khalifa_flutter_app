import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/constants.dart';

class ProductProvider {
  static  String baseUrl = apiBaseUrl;

  Future<Map<String, dynamic>> getProducts({int page = 1, int size = 20, String? categoryId, int? sectionId}) async {
    String url = '$baseUrl/products/?page=$page&size=$size';
    if (sectionId != null) url += '&section_id=$sectionId';
    //if (categoryId != null) url += '&category_id=$categoryId';
    final response = await http.get(Uri.parse(url));
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

  Future<List<dynamic>> getHomeSections() async {
    final response = await http.get(Uri.parse('$baseUrl/product-sections/home'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load home sections');
  }
}
