import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../constants/constants.dart';
import '../models/cart_model.dart';

class CartProvider {
  static  String baseUrl = '$apiBaseUrl/cart';
  final _storage = GetStorage();

  String? get _token => _storage.read('access_token');

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  Future<CartResponse> getCart() async {
    final response = await http.get(Uri.parse(baseUrl), headers: _headers);
    if (response.statusCode == 200) {
      return CartResponse.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load cart');
  }

  Future<void> addToCart({int? productId, int? variationId, int? partyMenuId, int quantity = 1}) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: _headers,
      body: jsonEncode({
        'product_id': ? productId,
        'variation_id': ?variationId,
        'party_menu_id': ?partyMenuId,
        'quantity': quantity,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add to cart: ${jsonDecode(response.body)['detail']}');
    }
  }

  Future<void> updateQuantity(int itemId, int quantity) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$itemId'),
      headers: _headers,
      body: jsonEncode({'quantity': quantity}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update quantity');
    }
  }

  Future<void> removeItem(int itemId) async {
    final response = await http.delete(Uri.parse('$baseUrl/$itemId'), headers: _headers);
    if (response.statusCode != 200) {
      throw Exception('Failed to remove item');
    }
  }
}
